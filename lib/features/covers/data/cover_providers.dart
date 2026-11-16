import 'dart:io';

import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_scanner.dart';
import 'package:dupe/features/covers/data/supabase_cover_store.dart';
import 'package:flutter/foundation.dart';
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
Future<File?> userCoverFile(Ref ref, String name) => ensureUserCover(
  ref.watch(coverPhotosProvider),
  ref.watch(coverStoreProvider),
  name,
);

/// Local file of the user photo [name], downloaded from [store] when
/// missing; null when unavailable.
Future<File?> ensureUserCover(
  CoverPhotos photos,
  CoverStore? store,
  String name,
) async {
  final file = await photos.fileOf(name);
  if (file.existsSync()) return file;
  final bytes = await store?.download(name);
  if (bytes == null) return null;
  await file.parent.create(recursive: true);
  // Written aside then renamed: an app killed while writing leaves a
  // `.part`, never a truncated photo that would be kept for good.
  final partial = File('${file.path}.part');
  await partial.writeAsBytes(bytes, flush: true);
  return await partial.rename(file.path);
}

typedef PickedImage = ({Uint8List bytes, String extension});

/// Takes a photo (camera on Android, file picker on desktop). Overridden in
/// tests.
@Riverpod(keepAlive: true)
Future<PickedImage?> Function({required bool camera}) pickImage(Ref ref) =>
    ({required camera}) async {
      final file = await ImagePicker().pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        // Room to crop: the cover is often a part of the photo.
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 92,
      );
      if (file == null) return null;
      return (
        bytes: await file.readAsBytes(),
        extension: p.extension(file.path),
      );
    };

/// Automatic capture on Android (ML Kit), null elsewhere. Overridden in
/// tests (`pumpApp`).
@Riverpod(keepAlive: true)
CoverScanner? coverScanner(Ref ref) =>
    defaultTargetPlatform == TargetPlatform.android
    ? MlKitCoverScanner()
    : null;
