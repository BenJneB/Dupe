import 'dart:async';

import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_prefetch.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline_covers_section.g.dart';

@riverpod
Future<({bool enabled, bool wifiOnly})> prefetchOptions(Ref ref) async {
  final settings = ref.watch(prefetchSettingsProvider);
  return (enabled: await settings.enabled, wifiOnly: await settings.wifiOnly);
}

/// Disk space of the downloaded covers, measured again after each run.
@riverpod
Future<int> coverCacheSize(Ref ref) {
  ref.watch(coverPrefetchProvider.select((s) => s.running));
  return ref.watch(coverCacheProvider).sizeInBytes();
}

/// Settings section: covers downloaded for offline use.
class OfflineCoversSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final options =
        ref.watch(prefetchOptionsProvider).value ??
        (enabled: true, wifiOnly: true);
    final progress = ref.watch(coverPrefetchProvider);
    final size = ref.watch(coverCacheSizeProvider).value;

    Future<void> change(Future<void> Function(PrefetchSettings) write) async {
      await write(ref.read(prefetchSettingsProvider));
      ref.invalidate(prefetchOptionsProvider);
      await ref.read(coverPrefetchProvider.notifier).restart();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.offlineCoversSection,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SwitchListTile(
          key: const Key('prefetchSwitch'),
          secondary: const Icon(Icons.download_for_offline_outlined),
          title: Text(l10n.offlineCovers),
          subtitle: Text(l10n.offlineCoversHelp),
          value: options.enabled,
          onChanged: (on) => change((s) => s.setEnabled(enabled: on)),
        ),
        SwitchListTile(
          key: const Key('prefetchWifiSwitch'),
          secondary: const Icon(Icons.wifi),
          title: Text(l10n.offlineCoversWifiOnly),
          subtitle: Text(l10n.offlineCoversWifiOnlyHelp),
          value: options.wifiOnly,
          onChanged: options.enabled
              ? (on) => change((s) => s.setWifiOnly(wifiOnly: on))
              : null,
        ),
        ListTile(
          key: const Key('prefetchStatus'),
          leading: progress.running
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.photo_library_outlined),
          title: Text(_status(l10n, progress)),
          subtitle: Text(
            [
              if (size != null) l10n.offlineCoversSize(_megabytes(size)),
              l10n.offlineCoversRefresh,
            ].join(' · '),
          ),
          onTap: options.enabled
              ? () => unawaited(
                  ref.read(coverPrefetchProvider.notifier).restart(),
                )
              : null,
          trailing: TextButton(
            key: const Key('clearCoverCache'),
            onPressed: () => _clear(context, ref),
            child: Text(l10n.offlineCoversClear),
          ),
        ),
      ],
    );
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    await ref.read(coverCacheProvider).clear();
    ref.invalidate(coverCacheSizeProvider);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.offlineCoversCleared)));
  }

  static String _status(AppLocalizations l10n, PrefetchState s) => switch (s) {
    PrefetchState(pause: PrefetchPause.disabled) => l10n.offlineCoversDisabled,
    PrefetchState(pause: PrefetchPause.offline) => l10n.offlineCoversOffline,
    PrefetchState(pause: PrefetchPause.metered) => l10n.offlineCoversMetered,
    PrefetchState(running: true) => l10n.offlineCoversProgress(s.done, s.total),
    PrefetchState(total: 0) => l10n.offlineCoversNone,
    _ when s.failed > 0 => l10n.offlineCoversDoneWithFailures(
      s.total,
      s.failed,
    ),
    _ => l10n.offlineCoversDone(s.total),
  };

  /// French decimal comma, one decimal ("48,2").
  static String _megabytes(int bytes) =>
      (bytes / (1024 * 1024)).toStringAsFixed(1).replaceAll('.', ',');
}
