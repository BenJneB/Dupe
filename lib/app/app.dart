import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/theme.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_controller.dart';
import 'package:dupe/features/backup/data/auto_backups.dart';
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
    // Desktop: overdue loans reminder (Android schedules them instead).
    unawaited(ref.read(loanActionsProvider).notifyOverdueOnStartup());
    // Starts the sync (restores the session, then syncs if signed in).
    ref.read(syncControllerProvider);
    unawaited(
      ref
          .read(autoBackupsProvider)
          .weeklyIfDue()
          .then<void>(
            (_) {},
            onError: (Object e, StackTrace s) => appLog.error('backup', e, s),
          ),
    );
    unawaited(_checkForUpdate());
    // Long press on the icon → store-mode scan (Android).
    unawaited(
      ref
          .read(appShortcutsProvider)
          .setUp(
            scanTitle: lookupAppLocalizations(const Locale('fr')).scan,
            onScan: () =>
                ref.read(appRouterProvider).go(AppRoutes.scanFor(null)),
          )
          .then<void>(
            (_) {},
            onError: (Object e) => appLog.warning('shortcuts', e),
          ),
    );
  }

  /// Release builds only: debug runs are always "older" than the release.
  Future<void> _checkForUpdate() async {
    if (!kReleaseMode) return;
    try {
      final update = await ref.read(updateCheckerProvider).check();
      final messenger = rootMessengerKey.currentState;
      if (update == null || messenger == null) return;
      showUpdateNotice(
        messenger,
        lookupAppLocalizations(const Locale('fr')),
        update,
      );
    } on Object catch (e) {
      appLog.warning('update', e);
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
