import 'dart:async';

import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Android: "back" on a tab root asks for a second press before leaving the
/// app (a single press used to close it by mistake).
class ExitGuard extends StatefulWidget {
  const new({required this.child, super.key});

  /// Time allowed for the second press.
  static const window = Duration(seconds: 2);

  final Widget child;

  @override
  State<ExitGuard> createState() => _ExitGuardState();
}

class _ExitGuardState extends State<ExitGuard> {
  Timer? _armed;

  @override
  void dispose() {
    _armed?.cancel();
    super.dispose();
  }

  void _onBack(bool didPop, Object? _) {
    if (didPop) return;
    if (_armed?.isActive ?? false) {
      _armed?.cancel();
      unawaited(SystemNavigator.pop());
      return;
    }
    _armed = Timer(ExitGuard.window, () {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('exitHint'),
          content: Text(AppLocalizations.of(context).pressBackAgainToExit),
          duration: ExitGuard.window,
        ),
      );
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: defaultTargetPlatform != TargetPlatform.android,
    onPopInvokedWithResult: _onBack,
    child: widget.child,
  );
}
