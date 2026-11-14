import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_auth.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:http/http.dart' show ClientException;

/// A sentence for the user; the technical detail goes to the journal
/// (About → Journal), never on screen.
String errorText(AppLocalizations l10n, Object error) => switch (error) {
  SyncException(failure: SyncFailure.offline) ||
  SocketException() ||
  TimeoutException() ||
  ClientException() => l10n.errorOffline,
  DioException(
    type: DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout,
  ) =>
    l10n.errorOffline,
  SyncException(failure: SyncFailure.session) => l10n.errorSession,
  SyncException(failure: SyncFailure.unavailable) => l10n.errorUnavailable,
  SyncException() => l10n.errorServer,
  SignInException(failure: SignInFailure.tooManyAttempts) =>
    l10n.errorTooManyAttempts,
  SignInException(failure: SignInFailure.invalidCredentials) =>
    l10n.errorInvalidCredentials,
  SignInException(failure: SignInFailure.emailNotConfirmed) =>
    l10n.errorEmailNotConfirmed,
  SignInException(failure: SignInFailure.emailTaken) => l10n.errorEmailTaken,
  SignInException(failure: SignInFailure.weakPassword) =>
    l10n.errorWeakPassword,
  SignInException() => l10n.errorSignInRefused,
  BackupFormatException() => l10n.errorNotBackup,
  FileSystemException() => l10n.errorFileAccess,
  FormatException() => l10n.errorBadFile,
  _ => l10n.errorUnknown,
};

/// Logs [error] under [source] and returns its [errorText].
String reportError(
  AppLocalizations l10n,
  String source,
  Object error, [
  StackTrace? stack,
]) {
  appLog.error(source, error, stack);
  return errorText(l10n, error);
}
