import 'dart:async';
import 'dart:convert';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/recommendations/data/recommendation_feedback_repository.dart';
import 'package:dupe/features/recommendations/data/suggestion_engine.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/recommendations/data/suggestion_wish.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggestions_controller.g.dart';

/// Suggestions are computed again after a week (or on demand).
const suggestionsMaxAge = Duration(days: 7);

const _cacheKey = 'suggestions_cache';

class SuggestionsState {
  const new({
    this.suggestions = const [],
    this.computedAt,
    this.loaded = false,
    this.running = false,
    this.done = 0,
    this.total = 0,
    this.failed = false,
  });

  final List<Suggestion> suggestions;
  final DateTime? computedAt;

  /// The cache has been read.
  final bool loaded;
  final bool running;
  final int done;
  final int total;

  /// The last computation failed (shown with the previous suggestions).
  final bool failed;

  SuggestionsState copyWith({
    List<Suggestion>? suggestions,
    DateTime? computedAt,
    bool? loaded,
    bool? running,
    int? done,
    int? total,
    bool? failed,
  }) => SuggestionsState(
    suggestions: suggestions ?? this.suggestions,
    computedAt: computedAt ?? this.computedAt,
    loaded: loaded ?? this.loaded,
    running: running ?? this.running,
    done: done ?? this.done,
    total: total ?? this.total,
    failed: failed ?? this.failed,
  );
}

/// The suggestions screen state (PLAN_V4 phase 30): cached on this device a
/// week, computed in the background (kept alive: leaving the screen does
/// not stop it).
@Riverpod(keepAlive: true)
class Suggestions extends _$Suggestions {
  @override
  SuggestionsState build() {
    unawaited(_load());
    return const SuggestionsState();
  }

  Future<void> _load() async {
    var loaded = const SuggestionsState(loaded: true);
    try {
      final json = await ref.read(appSettingsStoreProvider).get(_cacheKey);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        loaded = SuggestionsState(
          loaded: true,
          computedAt: DateTime.parse(map['computedAt'] as String),
          suggestions: [
            for (final s in map['suggestions'] as List<dynamic>)
              Suggestion.fromJson(s as Map<String, dynamic>),
          ],
        );
      }
    } on Object catch (e) {
      // Unreadable cache (older format): computed again.
      appLog.warning('suggestions', e);
    }
    if (!state.running) state = loaded;
  }

  /// Computes again when the cache is missing or older than a week.
  Future<void> ensureFresh() async {
    if (!state.loaded) await _load();
    final at = state.computedAt;
    final now = ref.read(clockProvider)();
    if (at == null || now.difference(at) > suggestionsMaxAge) await refresh();
  }

  Future<void> refresh() async {
    if (state.running) return;
    state = state.copyWith(running: true, done: 0, total: 0, failed: false);
    try {
      final repo = ref.read(collectionRepositoryProvider);
      final list = await SuggestionEngine(ref.read(suggestionSourcesProvider))
          .compute(
            items: await repo.listItems(),
            series: await repo.listSeries(),
            feedback: await ref
                .read(recommendationFeedbackRepositoryProvider)
                .list(),
            onProgress: (done, total) =>
                state = state.copyWith(done: done, total: total),
          );
      state = state.copyWith(
        suggestions: list,
        computedAt: ref.read(clockProvider)(),
        running: false,
        loaded: true,
      );
      await _save();
    } on Object catch (e, stack) {
      appLog.error('suggestions', e, stack);
      state = state.copyWith(running: false, failed: true);
    }
  }

  /// "Pas intéressé": gone now, and its reason weighs less next time.
  Future<void> dismiss(Suggestion s) async {
    await ref.read(recommendationFeedbackRepositoryProvider).dismiss(s);
    await _remove(s);
  }

  Future<void> addToWishes(Suggestion s) async {
    await addSuggestionToWishes(ref.read(collectionRepositoryProvider), s);
    await _remove(s);
  }

  Future<void> _remove(Suggestion s) async {
    state = state.copyWith(
      suggestions: [
        for (final x in state.suggestions)
          if (x.key != s.key) x,
      ],
    );
    await _save();
  }

  Future<void> _save() async {
    final at = state.computedAt;
    if (at == null) return;
    await ref
        .read(appSettingsStoreProvider)
        .set(
          _cacheKey,
          jsonEncode({
            'computedAt': at.toUtc().toIso8601String(),
            'suggestions': [for (final s in state.suggestions) s.toJson()],
          }),
        );
  }
}
