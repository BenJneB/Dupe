import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// Cover photos taken by the user (book not found online).
///
/// The item's cover URL is `dupe-cover:<file name>`; the file lives in the
/// app support directory and, once signed in, in the private Supabase
/// bucket `covers` under `<user id>/<file name>`.
class CoverPhotos {
  const new(this._dir);

  /// Directory of the local photos (created on first use).
  final Future<Directory> Function() _dir;

  static const scheme = 'dupe-cover:';

  static bool isUserCover(String? url) => url?.startsWith(scheme) ?? false;

  static String? nameOf(String? url) =>
      isUserCover(url) ? url!.substring(scheme.length) : null;

  Future<File> fileOf(String name) async =>
      File(p.join((await _dir()).path, name));

  /// Saves a new photo of [itemId] and returns its cover URL. A new name per
  /// photo, so that a replaced photo is uploaded again.
  Future<String> save(
    String itemId,
    Uint8List bytes, {
    required String extension,
    required DateTime now,
  }) async {
    final ext = extension.toLowerCase() == '.png' ? '.png' : '.jpg';
    final name = '$itemId-${now.millisecondsSinceEpoch}$ext';
    final file = await fileOf(name);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return '$scheme$name';
  }

  /// Uncropped photo of [itemId], kept on this device only (never synced)
  /// to crop it again (phase 29).
  Future<File> originalOf(String itemId) async =>
      File(p.join((await _dir()).path, _originals, '$itemId.jpg'));

  Future<void> saveOriginal(String itemId, Uint8List bytes) async {
    final file = await originalOf(itemId);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  }

  /// Disk space of the originals, in bytes.
  Future<int> originalsSize() async {
    var total = 0;
    await for (final f in _originalFiles()) {
      total += await f.length();
    }
    return total;
  }

  /// Deletes every original; the covers themselves are kept.
  Future<void> purgeOriginals() async {
    await for (final f in _originalFiles()) {
      await f.delete();
    }
  }

  Stream<File> _originalFiles() async* {
    final dir = Directory(p.join((await _dir()).path, _originals));
    if (!dir.existsSync()) return;
    await for (final entry in dir.list()) {
      if (entry is File) yield entry;
    }
  }

  static const _originals = 'originals';
}

/// Remote storage of the photos.
abstract interface class CoverStore {
  Future<void> upload(String name, Uint8List bytes);

  /// Null when the photo does not exist remotely.
  Future<Uint8List?> download(String name);
}
