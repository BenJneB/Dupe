import 'dart:async';

import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// "Deleted — Undo" message after a deletion (the row is only soft-deleted,
/// [undo] restores it and the sync propagates it).
void showUndoDelete(
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
  String message,
  Future<void> Function() undo,
) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 8),
        persist: false,
        action: SnackBarAction(
          key: const Key('undoDelete'),
          label: l10n.undo,
          onPressed: () => unawaited(undo()),
        ),
      ),
    );
}
