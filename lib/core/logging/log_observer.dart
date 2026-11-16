import 'package:dupe/core/logging/app_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sends provider failures (load errors shown on screen) to the journal.
final class LogObserver extends ProviderObserver {
  const new();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final provider = context.provider;
    appLog.error(
      // Generated providers have a name; never runtimeType (obfuscated in
      // public Releases).
      'provider:${provider.name ?? 'anonyme'}',
      error,
      stackTrace,
    );
  }
}
