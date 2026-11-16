import 'dart:async';

import 'package:dupe/features/scan/presentation/code_entry_field.dart';
import 'package:dupe/features/scan/presentation/parse_scanned_code.dart';
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

  /// The controller is ours, so the widget does not follow the app
  /// lifecycle: the camera (and the torch) kept running with the app in the
  /// background (recette M-14). Stopped when hidden, restarted when shown.
  late final AppLifecycleListener _lifecycle;

  /// The scanner is the screen in front: not covered by another route
  /// (review, search, sheet) nor in a hidden tab of the shell. Otherwise the
  /// camera kept reporting codes under the other screen.
  bool? _visible;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => unawaited(_controller.stop()),
      onShow: () {
        if (_visible ?? true) unawaited(_controller.start());
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final visible =
        (ModalRoute.isCurrentOf(context) ?? true) &&
        TickerMode.valuesOf(context).enabled;
    final previous = _visible;
    _visible = visible;
    // The first time, MobileScanner starts the camera itself.
    if (previous == null || previous == visible) return;
    unawaited(visible ? _controller.start() : _controller.stop());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_visible == false) return; // A frame analysed before the stop.
    final raw = pickScannedCode(
      capture.barcodes.map((b) => b.rawValue).nonNulls,
    );
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
        Positioned(
          top: 12,
          right: 12,
          child: ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, state, _) => switch (state.torchState) {
              TorchState.unavailable => const SizedBox.shrink(),
              final torch => IconButton.filledTonal(
                key: const Key('torchButton'),
                tooltip: torch == TorchState.on ? l10n.torchOff : l10n.torchOn,
                icon: Icon(
                  torch == TorchState.on ? Icons.flash_off : Icons.flash_on,
                ),
                onPressed: () => unawaited(_controller.toggleTorch()),
              ),
            },
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
