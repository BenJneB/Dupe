import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dupe/features/covers/domain/perspective.dart';
import 'package:image/image.dart' as img;

/// A photo ready for the crop editor: upright (EXIF orientation applied),
/// without EXIF, at most [maxEditSide] pixels on its longest side.
typedef EditablePhoto = ({Uint8List bytes, int width, int height});

/// Longest side of the photo kept for cropping (the local original).
const maxEditSide = 2400;

/// JPEG quality of the saved covers.
const coverQuality = 85;

/// Image work of phase 29, each step in its own isolate so that the UI never
/// freezes on a 12 MP photo.
abstract final class CoverProcessing {
  /// Upright copy of [bytes] for the editor.
  static Future<EditablePhoto> prepare(Uint8List bytes) =>
      Isolate.run(() => prepareSync(bytes));

  /// [photo] turned a quarter clockwise.
  static Future<EditablePhoto> rotate(Uint8List photo) => Isolate.run(() {
    final turned = img.copyRotate(_decode(photo), angle: 90);
    return _editable(turned);
  });

  /// The cover inside [quad] of [photo], straightened.
  static Future<Uint8List> crop(
    Uint8List photo,
    Quad quad, {
    CoverAspect aspect = CoverAspect.free,
  }) => Isolate.run(() => cropSync(photo, quad, aspect: aspect));

  /// An already cropped image (document scanner) at the cover format.
  static Future<Uint8List> normalize(Uint8List bytes) =>
      Isolate.run(() => normalizeSync(bytes));

  static EditablePhoto prepareSync(Uint8List bytes) =>
      _editable(_upright(_decode(bytes), maxEditSide));

  static Uint8List normalizeSync(Uint8List bytes) =>
      _encode(_upright(_decode(bytes), maxCoverSide));

  static Uint8List cropSync(
    Uint8List photo,
    Quad quad, {
    CoverAspect aspect = CoverAspect.free,
  }) {
    var src = _decode(photo);
    var q = quad;
    final size = outputSize(q, aspect: aspect);
    // A much larger source is first reduced: sampling it pixel by pixel
    // would alias (moiré on the cover's screen printing).
    final natural = outputSize(q, maxSide: 1 << 30);
    final quadSide = math.max(natural.width, natural.height);
    final wanted = 2 * math.max(size.width, size.height);
    if (quadSide > wanted) {
      final f = wanted / quadSide;
      src = img.copyResize(
        src,
        width: math.max(1, (src.width * f).round()),
        interpolation: img.Interpolation.average,
      );
      Pt s(Pt p) => (x: p.x * f, y: p.y * f);
      q = (
        topLeft: s(q.topLeft),
        topRight: s(q.topRight),
        bottomRight: s(q.bottomRight),
        bottomLeft: s(q.bottomLeft),
      );
    }
    final h = Homography.rectToQuad(q, size.width, size.height);
    final out = img.Image(width: size.width, height: size.height);
    final maxX = src.width - 1.0;
    final maxY = src.height - 1.0;
    for (var y = 0; y < size.height; y++) {
      for (var x = 0; x < size.width; x++) {
        final p = h.map(x.toDouble(), y.toDouble());
        out.setPixel(
          x,
          y,
          src.getPixelInterpolate(p.x.clamp(0, maxX), p.y.clamp(0, maxY)),
        );
      }
    }
    return _encode(out);
  }

  static img.Image _decode(Uint8List bytes) =>
      img.decodeImage(bytes) ?? (throw const FormatException('Not an image'));

  /// EXIF orientation applied, then at most [maxSide] on the longest side.
  static img.Image _upright(img.Image image, int maxSide) {
    final baked = img.bakeOrientation(image);
    if (math.max(baked.width, baked.height) <= maxSide) return baked;
    return baked.width >= baked.height
        ? img.copyResize(
            baked,
            width: maxSide,
            interpolation: img.Interpolation.average,
          )
        : img.copyResize(
            baked,
            height: maxSide,
            interpolation: img.Interpolation.average,
          );
  }

  static EditablePhoto _editable(img.Image image) => (
    bytes: _encode(image, quality: 92),
    width: image.width,
    height: image.height,
  );

  /// JPEG without any EXIF (place, device, date of the photo).
  static Uint8List _encode(img.Image image, {int quality = coverQuality}) {
    image.exif = img.ExifData();
    return img.encodeJpg(image, quality: quality);
  }
}
