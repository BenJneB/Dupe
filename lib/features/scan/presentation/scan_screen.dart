import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Barcode scan screen (camera on Android, manual/USB scanner on desktop).
/// Implemented in phases 2 and 4.
class ScanScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasCamera = defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scan)),
      body: PlaceholderBody(
        icon: Icons.qr_code_scanner,
        title: l10n.comingSoon,
        message: hasCamera ? null : l10n.scanUnavailableDesktop,
      ),
    );
  }
}
