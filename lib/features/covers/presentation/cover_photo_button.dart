import 'package:dupe/app/error_text.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/presentation/crop/cover_capture.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Takes a photo of the cover of [itemId] and puts its URL in [controller];
/// a second button crops an existing photo again (phase 29).
class CoverPhotoButton extends ConsumerWidget {
  const new({required this.itemId, required this.controller, super.key});

  final String itemId;
  final TextEditingController controller;

  Future<void> _run(
    BuildContext context,
    Future<String?> Function() work,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (await work() case final url?) controller.text = url;
    } on Object catch (e, stack) {
      final text = reportError(l10n, 'cover', e, stack);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.coverPhotoError(text))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) => CoverPhotos.isUserCover(value.text)
              ? IconButton(
                  key: const Key('coverRecropButton'),
                  tooltip: l10n.coverRecrop,
                  icon: const Icon(Icons.crop),
                  onPressed: () => _run(
                    context,
                    () => recropCover(context, ref, itemId, value.text),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        IconButton(
          key: const Key('coverPhotoButton'),
          tooltip: l10n.coverPhoto,
          icon: const Icon(Icons.photo_camera_outlined),
          onPressed: () =>
              _run(context, () => captureCover(context, ref, itemId)),
        ),
      ],
    );
  }
}
