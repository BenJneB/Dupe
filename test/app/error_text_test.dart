import 'dart:async';
import 'dart:io';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_auth.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('fr'));

  test('known errors become French sentences', () {
    final cases = <Object, String>{
      const SyncException.network('x'): l10n.errorOffline,
      const SocketException('x'): l10n.errorOffline,
      TimeoutException('x'): l10n.errorOffline,
      const SyncException('jwt', failure: SyncFailure.session):
          l10n.errorSession,
      const SyncException('rls'): l10n.errorServer,
      const SignInException(SignInFailure.tooManyAttempts, 'x'):
          l10n.errorTooManyAttempts,
      const SignInException(SignInFailure.invalidCode, 'x'):
          l10n.errorInvalidCode,
      const BackupFormatException(): l10n.errorNotBackup,
      const FileSystemException('x'): l10n.errorFileAccess,
      const FormatException('x'): l10n.errorBadFile,
      StateError('x'): l10n.errorUnknown,
    };
    for (final MapEntry(key: error, value: text) in cases.entries) {
      expect(errorText(l10n, error), text, reason: '$error');
    }
  });

  test('reportError logs the technical detail', () {
    final before = appLog.entries.length;
    final text = reportError(l10n, 'backup', const FormatException('ligne 3'));
    expect(text, l10n.errorBadFile);
    expect(appLog.entries.length, before + 1);
    expect(appLog.entries.last.source, 'backup');
    expect(appLog.entries.last.message, contains('ligne 3'));
  });
}
