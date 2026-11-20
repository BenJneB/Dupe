import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';

/// "Archive complète" (PLAN_V4 phase 31): the JSON backup and every photo
/// (covers, signatures) in one zip, since a JSON backup only keeps their
/// references and a signature photo cannot be taken again.
class FullArchive {
  const new(this._db, this._photos, this._store);

  final AppDatabase _db;
  final CoverPhotos _photos;

  /// Downloads the photos taken on another device; null offline mode.
  final CoverStore? _store;

  static const backupEntry = 'sauvegarde.json';
  static const photosDir = 'photos/';

  /// The zip and the number of photos it holds (a photo neither on this
  /// device nor downloadable is left out).
  Future<({Uint8List bytes, int photos})> export({
    required DateTime now,
  }) async {
    final archive = Archive();
    final json = await JsonBackup(_db).export(now: now);
    archive.addFile(ArchiveFile.bytes(backupEntry, utf8.encode(json)));
    var photos = 0;
    for (final name in await _photoNames()) {
      final file = await ensureUserCover(_photos, _store, name);
      if (file == null) continue;
      archive.addFile(
        ArchiveFile.bytes('$photosDir$name', await file.readAsBytes()),
      );
      photos++;
    }
    return (
      bytes: Uint8List.fromList(ZipEncoder().encode(archive)),
      photos: photos,
    );
  }

  /// Merges the collection of [zip] (nothing deleted, as a JSON restore)
  /// and puts back its photos missing on this device.
  Future<({int rows, int photos})> restore(Uint8List zip) async {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zip);
    } on Object {
      throw const BackupFormatException();
    }
    final backup = archive.findFile(backupEntry);
    if (backup == null) throw const BackupFormatException();
    final json = utf8.decode(backup.content);
    JsonBackup.decode(json);
    var photos = 0;
    for (final entry in archive.files) {
      if (!entry.isFile || !entry.name.startsWith(photosDir)) continue;
      final name = entry.name.substring(photosDir.length);
      // A name, never a path: nothing written outside the photo folder (no
      // separator of any platform, no Windows drive "C:", no "..").
      if (name.isEmpty ||
          name.contains('..') ||
          name.contains(RegExp(r'[/\\:]'))) {
        continue;
      }
      final file = await _photos.fileOf(name);
      if (file.existsSync()) continue;
      await file.parent.create(recursive: true);
      await file.writeAsBytes(entry.content, flush: true);
      photos++;
    }
    final rows = await JsonBackup(_db).restore(json);
    return (rows: rows, photos: photos);
  }

  /// Photos referenced by live items: covers and item photos.
  Future<List<String>> _photoNames() async {
    final rows = await _db
        .customSelect(
          'SELECT cover_url AS url FROM items '
          "WHERE cover_url LIKE '${CoverPhotos.scheme}%' "
          'AND deleted_at IS NULL '
          'UNION SELECT url FROM item_photos '
          "WHERE url LIKE '${CoverPhotos.scheme}%' AND deleted_at IS NULL",
          readsFrom: {_db.itemsTable, _db.itemPhotosTable},
        )
        .get();
    return [for (final r in rows) CoverPhotos.nameOf(r.read<String>('url'))!];
  }
}
