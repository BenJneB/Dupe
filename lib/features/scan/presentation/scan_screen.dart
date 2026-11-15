import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/presentation/camera_scanner_view.dart';
import 'package:dupe/features/scan/presentation/code_entry_field.dart';
import 'package:dupe/features/scan/presentation/handle_scanned_code.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Barcode scan: camera on Android, keyboard / USB reader elsewhere.
class ScanScreen extends StatelessWidget {
  const new({this.type, super.key});

  /// Collection type to look codes up as (tab the scan was opened from).
  final CollectionType? type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasCamera = defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scan)),
      body: hasCamera
          ? CameraScannerView(type: type)
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(24),
                  children: [
                    PlaceholderBody(
                      icon: Icons.qr_code_scanner,
                      title: l10n.scanDesktopTitle,
                      message: l10n.scanUnavailableDesktop,
                    ),
                    CodeEntryField(
                      onSubmitted: (code) =>
                          handleScannedCode(context, code, type: type),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
