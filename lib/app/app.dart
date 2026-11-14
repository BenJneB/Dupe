import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/theme.dart';
import 'package:dupe/features/loans/data/loan_actions.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
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
