import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/home_widget/data/home_screen_widget.dart';
import 'package:dupe/features/home_widget/data/widget_counts.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener, Locale;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_widget_updater.g.dart';

/// Keeps the counters of the home-screen widget up to date: [delay] after
/// the last change of items or loans (local edits and sync alike), so that
/// an import or a sync refreshes the widget once, not for every row.
@Riverpod(keepAlive: true)
class HomeWidgetUpdater extends _$HomeWidgetUpdater {
  static const delay = Duration(seconds: 2);

  Timer? _timer;
  String? _shown;

  @override
  void build() {
    final db = ref.watch(appDatabaseProvider);
    final changes = db
        .tableUpdates(
          TableUpdateQuery.onAllTables([db.itemsTable, db.loansTable]),
        )
        .listen((_) => _schedule());
    // Back in the app: a loan may have become overdue since, without any
    // change of the data.
    final lifecycle = AppLifecycleListener(onResume: _schedule);
    ref.onDispose(() {
      _timer?.cancel();
      lifecycle.dispose();
      unawaited(changes.cancel());
    });
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(delay, () => unawaited(_update()));
  }

  Future<void> _update() async {
    try {
      final counts = await readWidgetCounts(
        ref.read(appDatabaseProvider),
        ref.read(clockProvider)(),
      );
      // The app is French only: no context needed.
      final l10n = lookupAppLocalizations(const Locale('fr'));
      final text = [
        l10n.widgetOwned(counts.owned),
        if (counts.overdueLoans > 0) l10n.widgetOverdue(counts.overdueLoans),
      ].join(' · ');
      if (text == _shown) return;
      _shown = text;
      await ref.read(homeScreenWidgetProvider).showCounts(text);
    } on Object catch (e) {
      appLog.warning('widget', e);
    }
  }
}
