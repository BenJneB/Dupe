import 'dart:typed_data';

import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:supabase/supabase.dart';

/// Photos in the private bucket `covers`, folder of the signed-in user
/// (storage policies of the migration).
class SupabaseCoverStore implements CoverStore {
  const new(this._client, this._userId);

  final SupabaseClient _client;
  final String? Function() _userId;

  StorageFileApi get _bucket => _client.storage.from('covers');

  String _path(String name) {
    final user = _userId();
    if (user == null) {
      throw const SyncException('not signed in', failure: SyncFailure.session);
    }
    return '$user/$name';
  }

  @override
  Future<void> upload(String name, Uint8List bytes) async {
    try {
      await _bucket.uploadBinary(
        _path(name),
        bytes,
        fileOptions: FileOptions(
          upsert: true,
          contentType: name.endsWith('.png') ? 'image/png' : 'image/jpeg',
        ),
      );
    } on StorageException catch (e) {
      throw SyncException(e.message);
    }
  }

  @override
  Future<Uint8List?> download(String name) async {
    try {
      return await _bucket.download(_path(name));
    } on Object catch (e) {
      // Missing file, offline, signed out: unavailable, not an error to
      // retry in a loop (the placeholder is shown).
      if (e is! StorageException) appLog.warning('covers', e);
      return null;
    }
  }
}
