import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/notifications/local_notifications.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_notifications.g.dart';

/// One grouped notification for the new releases (PLAN_V4 phase 33).
abstract interface class ReleaseNotifications {
  Future<void> show(int count);
}

@Riverpod(keepAlive: true)
ReleaseNotifications releaseNotifications(Ref ref) =>
    LocalReleaseNotifications();

class LocalReleaseNotifications implements ReleaseNotifications {
  final AppLocalizations _l10n = lookupAppLocalizations(const Locale('fr'));

  /// Its own id: never replaces a loan notification.
  static const _id = 7;

  @override
  Future<void> show(int count) async {
    try {
      if (!await initLocalNotifications()) return;
      await localNotifications.show(
        id: _id,
        title: _l10n.releasesNotificationTitle(count),
        body: _l10n.releasesNotificationBody,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'releases',
            _l10n.releasesTitle,
            channelDescription: _l10n.notificationChannelReleases,
          ),
        ),
      );
    } on Object catch (e) {
      appLog.warning('releases', e);
    }
  }
}
