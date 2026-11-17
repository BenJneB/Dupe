import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/item_photos_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_photo.dart';
import 'package:dupe/features/collection/presentation/confirm_delete_dialog.dart';
import 'package:dupe/features/collection/presentation/item/signing/photo_viewer.dart';
import 'package:dupe/features/covers/data/cover_processing.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Item sheet (PLAN_V4 phase 31): the signature, if any, and the photos of
/// the item (signature page…). Tap a photo: full screen with zoom; long
/// press: delete.
class ItemSigningSection extends ConsumerWidget {
  const new({required this.item, super.key});

  final Item item;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picked = await ref.read(pickImageProvider)(
        camera: defaultTargetPlatform == TargetPlatform.android,
      );
      if (picked == null) return;
      // Upright, without EXIF, 1200 px: no forced perspective correction
      // (a signature is often photographed with the book open).
      final bytes = await CoverProcessing.normalize(picked.bytes);
      final url = await ref
          .read(coverPhotosProvider)
          .save(
            item.id,
            bytes,
            extension: '.jpg',
            now: ref.read(clockProvider)(),
          );
      await ref.read(itemPhotosRepositoryProvider).add(item.id, url);
    } on Object catch (e, stack) {
      final text = reportError(l10n, 'photos', e, stack);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.coverPhotoError(text))),
      );
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ItemPhoto photo,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (await confirmDelete(context, l10n.deletePhotoMessage)) {
      await ref.read(itemPhotosRepositoryProvider).delete(photo);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final photos = ref.watch(itemPhotosProvider(item.id)).value ?? const [];
    if (!item.isSigned && photos.isEmpty) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          key: const Key('addItemPhoto'),
          icon: const Icon(Icons.add_a_photo_outlined),
          label: Text(l10n.addItemPhoto),
          onPressed: () => unawaited(_add(context, ref)),
        ),
      );
    }
    final on = item.signedOn;
    final details = [
      ?item.signedBy,
      if (on != null) Formatters.date(on, l10n.localeName),
      ?item.signedPlace,
    ].join(' · ');
    return Card(
      key: const Key('signingSection'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  item.isSigned ? Icons.draw_outlined : Icons.photo_outlined,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.isSigned ? l10n.signedTitle : l10n.itemPhotosTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            if (details.isNotEmpty) Text(details),
            if (item.signingNote case final note?)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '« $note »',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (i, p) in photos.indexed)
                  GestureDetector(
                    key: ValueKey('itemPhoto-$i'),
                    onTap: () => unawaited(showPhotos(context, photos, i)),
                    onLongPress: () => unawaited(_delete(context, ref, p)),
                    child: CoverImage(url: p.url, width: 72, height: 96),
                  ),
                SizedBox(
                  width: 72,
                  height: 96,
                  child: OutlinedButton(
                    key: const Key('addItemPhoto'),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => unawaited(_add(context, ref)),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      semanticLabel: l10n.addItemPhoto,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
