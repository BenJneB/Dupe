import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Takes a photo of the cover of [itemId] and puts its URL in [controller].
class CoverPhotoButton extends ConsumerWidget {
  const new({required this.itemId, required this.controller, super.key});

  final String itemId;
  final TextEditingController controller;

  Future<void> _take(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picked = await ref.read(pickImageProvider)(
        camera: defaultTargetPlatform == TargetPlatform.android,
      );
      if (picked == null) return;
      controller.text = await ref
          .read(coverPhotosProvider)
          .save(
            itemId,
            picked.bytes,
            extension: picked.extension,
            now: ref.read(clockProvider)(),
          );
    } on Object catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.coverPhotoError('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      key: const Key('coverPhotoButton'),
      tooltip: l10n.coverPhoto,
      icon: const Icon(Icons.photo_camera_outlined),
      onPressed: () => _take(context, ref),
    );
  }
}
