import 'dart:io';
import 'dart:typed_data';

import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/supabase_cover_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cover_providers.g.dart';

@Riverpod(keepAlive: true)
CoverPhotos coverPhotos(Ref ref) => CoverPhotos(
  () async => Directory(
    p.join((await getApplicationSupportDirectory()).path, 'covers'),
  ),
);

/// Remote photo storage, or null in local-only mode.
@Riverpod(keepAlive: true)
CoverStore? coverStore(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return null;
  final auth = ref.watch(syncAuthProvider);
  return SupabaseCoverStore(client, () => auth.userId);
}

/// Local file of a user photo, downloaded on first display on another
/// device; null when unavailable (offline, not signed in).
@riverpod
Future<File?> userCoverFile(Ref ref, String name) async {
  final file = await ref.watch(coverPhotosProvider).fileOf(name);
  if (file.existsSync()) return file;
  final bytes = await ref.watch(coverStoreProvider)?.download(name);
  if (bytes == null) return null;
  await file.parent.create(recursive: true);
  return await file.writeAsBytes(bytes, flush: true);
}

typedef PickedImage = ({Uint8List bytes, String extension});

/// Takes a photo (camera on Android, file picker on desktop). Overridden in
/// tests.
@Riverpod(keepAlive: true)
Future<PickedImage?> Function({required bool camera}) pickImage(Ref ref) =>
    ({required camera}) async {
      final file = await ImagePicker().pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return null;
      return (
        bytes: await file.readAsBytes(),
        extension: p.extension(file.path),
      );
    };
