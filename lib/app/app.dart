import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/theme.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_controller.dart';
import 'package:dupe/features/backup/data/auto_backups.dart';
import 'package:dupe/features/home_widget/data/home_screen_widget.dart';
import 'package:dupe/features/home_widget/data/home_widget_updater.dart';
import 'package:dupe/features/loans/data/loan_actions.dart';
import 'package:dupe/features/scan/data/app_shortcuts.dart';
import 'package:dupe/features/settings/data/theme_mode_provider.dart';
import 'package:dupe/features/updates/data/update_checker.dart';
import 'package:dupe/features/updates/presentation/update_notice.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Messages shown outside a screen (new version at start-up).
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

class DupeApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DupeApp> createState() => _DupeAppState();
}

class _DupeAppState extends ConsumerState<DupeApp> {
  @override
  void initState() {
    super.initState();
    // Starts the sync (restores the session, then syncs if signed in).
    ref.read(syncControllerProvider);
    // Desktop: overdue loans reminder (Android schedules them instead).
    _inBackground(
      'loans',
      ref.read(loanActionsProvider).notifyOverdueOnStartup,
    );
    _inBackground('backup', ref.read(autoBackupsProvider).weeklyIfDue);
    _inBackground('update', _checkForUpdate);
    // Long press on the icon → store-mode scan (Android).
    _inBackground(
      'shortcuts',
      () => ref
          .read(appShortcutsProvider)
          .setUp(scanTitle: _l10n.scan, onScan: _openScan),
    );
    // Home-screen widget (Android): its "Scanner" button, and its counters.
    _inBackground('widget', _listenToHomeWidget);
    if (defaultTargetPlatform == TargetPlatform.android) {
      ref.read(homeWidgetUpdaterProvider);
    }
  }

  StreamSubscription<Uri?>? _widgetTaps;

  @override
  void dispose() {
    unawaited(_widgetTaps?.cancel());
    super.dispose();
  }

  void _openScan() => ref.read(appRouterProvider).go(AppRoutes.scanFor(null));

  Future<void> _listenToHomeWidget() async {
    final widget = ref.read(homeScreenWidgetProvider);
    void open(Uri? link) {
      if (link?.host == 'scan') _openScan();
    }

    open(await widget.initialLaunch());
    _widgetTaps = widget.taps.listen(open);
  }

  /// No context needed: the app is French only.
  AppLocalizations get _l10n => lookupAppLocalizations(const Locale('fr'));

  /// Start-up task that must neither delay nor break the app: a failure is
  /// only recorded in the journal.
  void _inBackground(String source, Future<Object?> Function() task) =>
      unawaited(
        task().then<void>(
          (_) {},
          onError: (Object e, StackTrace _) => appLog.warning(source, e),
        ),
      );

  /// Release builds only: debug runs are always "older" than the release.
  Future<void> _checkForUpdate() async {
    if (!kReleaseMode) return;
    final update = await ref.read(updateCheckerProvider).check();
    final messenger = rootMessengerKey.currentState;
    if (update != null && messenger != null) {
      showUpdateNotice(messenger, _l10n, update);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: rootMessengerKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(appThemeModeProvider),
      locale: const Locale('fr'),
      // gen-l10n still emits legacy flutter_localizations delegates, which do
      // not provide material_ui's MaterialLocalizations: use material_ui's.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
