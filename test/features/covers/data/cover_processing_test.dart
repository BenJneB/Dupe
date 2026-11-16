import 'dart:typed_data';

import 'package:dupe/features/covers/data/cover_processing.dart';
import 'package:dupe/features/covers/domain/perspective.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

/// A [width] × [height] JPEG, black, with a white quadrilateral [cover]
/// and EXIF data (orientation, GPS position, camera).
Uint8List photo(int width, int height, {Quad? cover, int orientation = 1}) {
  final image = img.Image(width: width, height: height);
  if (cover != null) {
    img.fillPolygon(
      image,
      vertices: [
        for (final p in [
          cover.topLeft,
          cover.topRight,
          cover.bottomRight,
          cover.bottomLeft,
        ])
          img.Point(p.x, p.y),
      ],
      color: img.ColorRgb8(255, 255, 255),
    );
  }
  image.exif.imageIfd
    ..orientation = orientation
    ..make = 'PhoneMaker';
  image.exif.gpsIfd['GPSLatitude'] = img.IfdValueRational(50, 1);
  return img.encodeJpg(image);
}

img.Image decode(Uint8List bytes) => img.decodeJpg(bytes)!;

void main() {
  test('the source photo really carries EXIF (test sanity)', () {
    expect(decode(photo(40, 20)).exif.isEmpty, isFalse);
  });

  test('prepare applies the EXIF orientation and removes the EXIF', () {
    final prepared = CoverProcessing.prepareSync(
      photo(400, 200, orientation: 6),
    );
    expect((prepared.width, prepared.height), (200, 400));
    final out = decode(prepared.bytes);
    expect((out.width, out.height), (200, 400));
    expect(out.exif.isEmpty, isTrue);
  });

  test('prepare reduces a large photo to 2400 px', () {
    final prepared = CoverProcessing.prepareSync(photo(3000, 4000));
    expect((prepared.width, prepared.height), (1800, 2400));
  });

  test('crop straightens a cover taken at an angle, without EXIF', () {
    const cover = (
      topLeft: (x: 150.0, y: 100.0),
      topRight: (x: 700.0, y: 160.0),
      bottomRight: (x: 660.0, y: 900.0),
      bottomLeft: (x: 90.0, y: 820.0),
    );
    final out = decode(
      CoverProcessing.cropSync(photo(800, 1000, cover: cover), cover),
    );
    expect(out.exif.isEmpty, isTrue);
    expect((out.width, out.height), outputSize(cover).toRecord());
    // Inside the cover only: no black table left, even near the corners.
    for (final (x, y) in [
      (3, 3),
      (out.width - 4, 3),
      (out.width - 4, out.height - 4),
      (3, out.height - 4),
      (out.width ~/ 2, out.height ~/ 2),
    ]) {
      expect(out.getPixel(x, y).r, greaterThan(200), reason: '($x, $y)');
    }
  });

  test('crop: 1200 px at most on the longest side, ratio preset kept', () {
    final big = defaultQuad(2400, 3200);
    final out = decode(
      CoverProcessing.cropSync(
        photo(2400, 3200),
        big,
        aspect: CoverAspect.album,
      ),
    );
    expect(out.height, maxCoverSide);
    expect(out.width, 900);
  });

  test('normalize (scanner output): 1200 px, upright, no EXIF', () {
    final out = decode(
      CoverProcessing.normalizeSync(photo(2000, 1500, orientation: 6)),
    );
    expect((out.width, out.height), (900, 1200));
    expect(out.exif.isEmpty, isTrue);
  });

  test('an unreadable file is refused', () {
    expect(
      () => CoverProcessing.prepareSync(Uint8List.fromList([1, 2, 3])),
      throwsFormatException,
    );
  });
}

extension on ({int width, int height}) {
  (int, int) toRecord() => (width, height);
}
