import 'dart:async';

import 'package:dupe/features/scan/presentation/code_entry_field.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Continuous camera barcode scanner (Android), with manual entry as a
/// fallback; [panel] (result, queue) is shown over the bottom of the preview.
class CameraScannerView extends StatefulWidget {
  const new({required this.onCode, required this.panel, super.key});

  final ValueChanged<String> onCode;
  final Widget panel;

  @override
  State<CameraScannerView> createState() => _CameraScannerViewState();
}

class _CameraScannerViewState extends State<CameraScannerView> {
  final _controller = MobileScannerController(
    // A code is reported once until another one is seen.
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.map((b) => b.rawValue).nonNulls.firstOrNull;
    if (raw != null) widget.onCode(raw);
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
          widget.onCode(code);
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
        Align(
          alignment: const Alignment(0, -0.6),
          child: Container(
            width: 280,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.panel,
              const SizedBox(height: 8),
              Center(
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.keyboard),
                  label: Text(l10n.typeIsbn),
                  onPressed: _manualEntry,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
