import 'package:dupe/core/sync/sync_controller.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

extension SyncStateLabel on SyncState {
  String label(AppLocalizations l10n) {
    final at = lastSync;
    return switch (phase) {
      SyncPhase.localOnly => l10n.syncLocalOnly,
      SyncPhase.signedOut => l10n.syncSignedOut,
      SyncPhase.syncing => l10n.syncRunning,
      SyncPhase.offline => l10n.syncOffline,
      SyncPhase.failed => l10n.syncFailed(message ?? ''),
      SyncPhase.idle when at != null => l10n.syncIdleAt(
        DateFormat.Hm(l10n.localeName).format(at),
      ),
      SyncPhase.idle => l10n.syncIdle,
    };
  }

  IconData get icon => switch (phase) {
    SyncPhase.localOnly || SyncPhase.signedOut => Icons.cloud_off_outlined,
    SyncPhase.syncing => Icons.cloud_sync_outlined,
    SyncPhase.offline => Icons.cloud_off_outlined,
    SyncPhase.failed => Icons.sync_problem,
    SyncPhase.idle => Icons.cloud_done_outlined,
  };
}
