import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// The system notifications plugin, shared by every feature that notifies
/// (loans, new releases): each one uses its own channel and ids.
final localNotifications = FlutterLocalNotificationsPlugin();

Future<bool>? _ready;

/// Initializes the plugin once (and asks for the permission on Android).
/// False when notifications are unavailable (e.g. headless Linux without a
/// notification server): they are optional, the app works without them.
Future<bool> initLocalNotifications() => _ready ??= () async {
  final l10n = lookupAppLocalizations(const Locale('fr'));
  try {
    await localNotifications.initialize(
      settings: InitializationSettings(
        // White silhouette (res/drawable/ic_stat_dupe.xml): the coloured
        // launcher icon shows as a filled square in the status bar.
        android: const AndroidInitializationSettings('@drawable/ic_stat_dupe'),
        linux: LinuxInitializationSettings(
          defaultActionName: l10n.notificationOpen,
        ),
        windows: WindowsInitializationSettings(
          appName: l10n.appTitle,
          appUserModelId: 'Dev.Dupe.Dupe',
          guid: '6f1d9c2e-4b7a-4d55-9a0e-3c8b2f71d5a4',
        ),
      ),
    );
    if (defaultTargetPlatform == TargetPlatform.android) {
      await localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
    return true;
  } on Object catch (e) {
    appLog.warning('notifications', 'Notifications unavailable: $e');
    return false;
  }
}();
