import 'dart:async';

import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/presentation/code_entry_field.dart';
import 'package:dupe/features/scan/presentation/handle_scanned_code.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Camera barcode scanner (Android), with manual entry as a fallback.
class CameraScannerView extends StatefulWidget {
  const new({this.type, super.key});

  final CollectionType? type;

  @override
  State<CameraScannerView> createState() => _CameraScannerViewState();
}

class _CameraScannerViewState extends State<CameraScannerView> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );
  var _handled = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.map((b) => b.rawValue).nonNulls.firstOrNull;
    if (raw == null) return;
    _handled = handleScannedCode(context, raw, type: widget.type);
  }

  Future<void> _manualEntry() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: CodeEntryField(
        onSubmitted: (code) {
          Navigator.pop(sheetContext);
          handleScannedCode(context, code, type: widget.type);
        },
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
          errorBuilder: (context, error) => ColoredBox(
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.cameraUnavailable(error.errorCode.name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 280,
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 32,
          child: Column(
            children: [
              Text(
                l10n.scanHint,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.keyboard),
                label: Text(l10n.typeIsbn),
                onPressed: _manualEntry,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
