import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_processing.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/features/covers/data/cover_scanner.dart';
import 'package:dupe/features/covers/presentation/crop/cover_crop_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Takes a cover photo of [itemId] and returns its new cover URL, or null
/// when the user cancels. Android: ML Kit scanner first, manual editor when
/// it cannot run; elsewhere: file picker then manual editor.
Future<String?> captureCover(
  BuildContext context,
  WidgetRef ref,
  String itemId,
) async {
  if (ref.read(coverScannerProvider) case final scanner?) {
    try {
      final scanned = await scanner.scan();
      if (scanned == null) return null;
      final cover = await CoverProcessing.normalize(scanned);
      final original = await CoverProcessing.prepare(scanned);
      return await _save(ref, itemId, (cover: cover, original: original.bytes));
    } on ScannerUnavailable catch (e) {
      appLog.warning('covers', e);
    }
  }
  final picked = await ref.read(pickImageProvider)(
    camera: defaultTargetPlatform == TargetPlatform.android,
  );
  if (picked == null || !context.mounted) return null;
  return await _edit(context, ref, itemId, picked.bytes);
}

/// Opens the editor again on the photo of [itemId] (its uncropped original
/// when this device still has it, else the cover itself).
Future<String?> recropCover(
  BuildContext context,
  WidgetRef ref,
  String itemId,
  String coverUrl,
) async {
  final photos = ref.read(coverPhotosProvider);
  final original = await photos.originalOf(itemId);
  final Uint8List bytes;
  if (original.existsSync()) {
    bytes = await original.readAsBytes();
  } else {
    final file = await ensureUserCover(
      photos,
      ref.read(coverStoreProvider),
      CoverPhotos.nameOf(coverUrl)!,
    );
    if (file == null) throw StateError('Cover photo unavailable');
    bytes = await file.readAsBytes();
  }
  if (!context.mounted) return null;
  return await _edit(context, ref, itemId, bytes);
}

Future<String?> _edit(
  BuildContext context,
  WidgetRef ref,
  String itemId,
  Uint8List bytes,
) async {
  final photo = await CoverProcessing.prepare(bytes);
  if (!context.mounted) return null;
  final result = await cropCover(context, photo);
  if (result == null) return null;
  return await _save(ref, itemId, result);
}

Future<String> _save(WidgetRef ref, String itemId, CropResult result) async {
  final photos = ref.read(coverPhotosProvider);
  await photos.saveOriginal(itemId, result.original);
  return await photos.save(
    itemId,
    result.cover,
    extension: '.jpg',
    now: ref.read(clockProvider)(),
  );
}
