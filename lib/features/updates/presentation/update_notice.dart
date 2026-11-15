import 'dart:async';

import 'package:dupe/features/updates/data/update_checker.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Version X available — Download" (the file for this device, else the
/// release page).
void showUpdateNotice(
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
  AvailableUpdate update,
) => messenger
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      key: const Key('updateNotice'),
      content: Text(l10n.updateAvailable(update.version)),
      duration: const Duration(seconds: 12),
      persist: false,
      action: SnackBarAction(
        label: l10n.updateDownload,
        onPressed: () => unawaited(
          launchUrl(
            update.download ?? update.page,
            mode: LaunchMode.externalApplication,
          ),
        ),
      ),
    ),
  );
