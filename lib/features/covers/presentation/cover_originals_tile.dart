import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/features/covers/presentation/offline_covers_section.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cover_originals_tile.g.dart';

/// Disk space of the uncropped photos kept on this device.
@riverpod
Future<int> coverOriginalsSize(Ref ref) =>
    ref.watch(coverPhotosProvider).originalsSize();

/// Settings: the uncropped originals of the cover photos (phase 29), kept to
/// crop again, never synced; deleting them keeps the covers.
class CoverOriginalsTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final size = ref.watch(coverOriginalsSizeProvider).value ?? 0;
    return ListTile(
      key: const Key('coverOriginalsTile'),
      leading: const Icon(Icons.crop_original),
      title: Text(l10n.coverOriginals),
      subtitle: Text(
        '${l10n.offlineCoversSize(megabytes(size))} · '
        '${l10n.coverOriginalsHelp}',
      ),
      trailing: TextButton(
        key: const Key('purgeCoverOriginals'),
        onPressed: size == 0 ? null : () => _purge(context, ref),
        child: Text(l10n.offlineCoversClear),
      ),
    );
  }

  Future<void> _purge(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    await ref.read(coverPhotosProvider).purgeOriginals();
    ref.invalidate(coverOriginalsSizeProvider);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.coverOriginalsPurged)));
  }
}
