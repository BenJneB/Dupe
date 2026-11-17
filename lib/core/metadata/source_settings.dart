import 'package:dupe/core/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'source_settings.g.dart';

/// Sources the user can turn off in the settings. Comic Vine is one switch
/// for both its issue search and its series lookup.
enum SourceId {
  bnf,
  googleBooks,
  openLibrary,
  comicVine,
  anilist,
  mangaUpdates,
  mangadex,
}

/// Sources turned off by the user (all on by default), persisted in the
/// `app_settings` table.
@Riverpod(keepAlive: true)
class DisabledSources extends _$DisabledSources {
  static const _key = 'disabled_sources';

  @override
  Future<Set<SourceId>> build() async {
    final raw = await ref.watch(appSettingsStoreProvider).get(_key) ?? '';
    final names = raw.split(',').toSet();
    return {
      for (final id in SourceId.values)
        if (names.contains(id.name)) id,
    };
  }

  Future<void> setEnabled(SourceId id, {required bool enabled}) async {
    final current = {...?state.value};
    if (enabled) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = AsyncData(current);
    await ref
        .read(appSettingsStoreProvider)
        .set(_key, [for (final id in current) id.name].join(','));
  }
}
