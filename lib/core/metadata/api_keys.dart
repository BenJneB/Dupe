import 'package:dupe/core/config/env.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_keys.g.dart';

/// Sources that need an API key (PLAN_V3 phase 15). Public releases are built
/// without keys: the user enters them in Settings → Sources.
const Set<SourceId> keyedSources = {SourceId.googleBooks, SourceId.comicVine};

/// Keys compiled into this build from env.json (handy in development; empty
/// in public releases, where `release.yml` refuses them).
Map<SourceId, String> get builtInApiKeys => const {
  SourceId.googleBooks: Env.googleBooksApiKey,
  SourceId.comicVine: Env.comicVineApiKey,
};

/// The key used for each keyed source: the one entered in the app, else the
/// built-in one, else empty.
Map<SourceId, String> effectiveApiKeys(
  Map<SourceId, String> saved,
  Map<SourceId, String> builtIn,
) => {
  for (final id in keyedSources)
    id: (saved[id] ?? '').isNotEmpty ? saved[id]! : builtIn[id] ?? '',
};

/// Sources without a key are unavailable (Google Books without a key answers
/// HTTP 429); the others always have what they need.
bool sourceHasKey(SourceId id, Map<SourceId, String> keys) =>
    !keyedSources.contains(id) || (keys[id] ?? '').isNotEmpty;

/// Keys entered in the app, in the local `app_settings` table: never synced,
/// never in backups (only series, items and loans are), never in the journal
/// (registered with [AppLog.hideSecret]).
@Riverpod(keepAlive: true)
class SavedApiKeys extends _$SavedApiKeys {
  static String settingKey(SourceId id) => 'api_key_${id.name}';

  @override
  Future<Map<SourceId, String>> build() async {
    builtInApiKeys.values.forEach(appLog.hideSecret);
    final settings = ref.watch(appSettingsStoreProvider);
    final saved = <SourceId, String>{};
    for (final id in keyedSources) {
      final key = await settings.get(settingKey(id)) ?? '';
      if (key.isNotEmpty) saved[id] = key;
    }
    saved.values.forEach(appLog.hideSecret);
    return saved;
  }

  /// Saves [key] for [id]; an empty key removes it (back to the built-in one).
  Future<void> save(SourceId id, String key) async {
    final trimmed = key.trim();
    appLog.hideSecret(trimmed);
    await ref.read(appSettingsStoreProvider).set(settingKey(id), trimmed);
    state = AsyncData(
      {...?state.value, id: trimmed}..removeWhere((_, v) => v.isEmpty),
    );
  }
}

/// Keys in use (saved first). Empty for a moment at start-up, until the saved
/// ones are read.
@Riverpod(keepAlive: true)
Map<SourceId, String> apiKeys(Ref ref) => effectiveApiKeys(
  ref.watch(savedApiKeysProvider).value ?? const {},
  builtInApiKeys,
);
