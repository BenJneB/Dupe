import 'dart:convert';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';

/// Uploads the photos referenced by items (covers, other photos) and not
/// uploaded yet to the
/// account [userId] (part of the sync, after the rows): another account
/// signed in on this device gets them too. Returns the number uploaded.
Future<int> uploadPendingCovers(
  AppDatabase db,
  CoverPhotos photos,
  CoverStore store,
  AppSettingsStore settings, {
  required String userId,
}) async {
  final key = 'covers_uploaded_$userId';
  final done = {
    ...(jsonDecode(await settings.get(key) ?? '[]') as List<dynamic>)
        .cast<String>(),
  };
  final rows = await db
      .customSelect(
        // Covers and the other photos of the items (signatures, phase 31).
        'SELECT cover_url AS url FROM items '
        "WHERE cover_url LIKE '${CoverPhotos.scheme}%' AND deleted_at IS NULL "
        'UNION SELECT url FROM item_photos '
        "WHERE url LIKE '${CoverPhotos.scheme}%' AND deleted_at IS NULL",
        readsFrom: {db.itemsTable, db.itemPhotosTable},
      )
      .get();
  var uploaded = 0;
  for (final row in rows) {
    final name = CoverPhotos.nameOf(row.read<String>('url'))!;
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
