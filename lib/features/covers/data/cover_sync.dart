import 'dart:convert';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';

/// Uploads the photos referenced by items and not uploaded yet (part of the
/// sync, after the rows). Returns the number of photos uploaded.
Future<int> uploadPendingCovers(
  AppDatabase db,
  CoverPhotos photos,
  CoverStore store,
  AppSettingsStore settings,
) async {
  const key = 'covers_uploaded';
  final done = {
    ...(jsonDecode(await settings.get(key) ?? '[]') as List<dynamic>)
        .cast<String>(),
  };
  final rows = await db
      .customSelect(
        'SELECT DISTINCT cover_url FROM items '
        "WHERE cover_url LIKE '${CoverPhotos.scheme}%' AND deleted_at IS NULL",
        readsFrom: {db.itemsTable},
      )
      .get();
  var uploaded = 0;
  for (final row in rows) {
    final name = CoverPhotos.nameOf(row.read<String>('cover_url'))!;
    if (done.contains(name)) continue;
    final file = await photos.fileOf(name);
    if (!file.existsSync()) continue; // Taken on another device.
    await store.upload(name, await file.readAsBytes());
    done.add(name);
    uploaded++;
    await settings.set(key, jsonEncode(done.toList()));
  }
  return uploaded;
}
