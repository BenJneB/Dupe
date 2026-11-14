import 'dart:async';

import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/data/scan_queue_worker.dart';
import 'package:dupe/features/scan/presentation/burst/burst_panel.dart';
import 'package:dupe/features/scan/presentation/camera_scanner_view.dart';
import 'package:dupe/features/scan/presentation/code_entry_field.dart';
import 'package:dupe/features/scan/presentation/parse_scanned_code.dart';
import 'package:dupe/features/scan/presentation/scan_mode.dart';
import 'package:dupe/features/scan/presentation/store/store_result_banner.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Barcode scan: camera on Android, keyboard / USB reader elsewhere.
/// Store mode shows a coloured verdict per code; burst mode queues codes.
class ScanScreen extends ConsumerStatefulWidget {
  const new({this.type, super.key});

  /// Tab the scan was opened from: sources and series are looked up as this
  /// type (books when opened elsewhere: the widest set of sources).
  final CollectionType? type;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  ScanMode _mode = ScanMode.store;
  String? _lastIsbn;

  CollectionType get _type => widget.type ?? CollectionType.livre;

  @override
  void initState() {
    super.initState();
    // Resume lookups left pending (app closed during a burst).
    unawaited(ref.read(scanQueueWorkerProvider).run());
  }

  Future<void> _onCode(String raw) async {
    final isbn = parseScannedCode(context, raw);
    if (isbn == null) return;
    unawaited(HapticFeedback.mediumImpact());
    if (_mode == ScanMode.store) {
      setState(() => _lastIsbn = isbn);
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final queue = ref.read(scanQueueRepositoryProvider);
    final added = await queue.enqueue(isbn, _type);
    unawaited(ref.read(scanQueueWorkerProvider).run());
    final count = await queue.count();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
            added ? l10n.burstQueued(count) : l10n.burstAlreadyQueued,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasCamera = defaultTargetPlatform == TargetPlatform.android;
    final isbn = _lastIsbn;
    final panel = switch (_mode) {
      ScanMode.store when isbn != null => StoreResultBanner(
        key: ValueKey(isbn),
        isbn13: isbn,
        type: _type,
      ),
      ScanMode.store => const SizedBox.shrink(),
      ScanMode.burst => const BurstPanel(),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scan),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SegmentedButton<ScanMode>(
              key: const Key('scanModeSelector'),
              segments: [
                ButtonSegment(
                  value: ScanMode.store,
                  icon: const Icon(Icons.storefront),
                  label: Text(l10n.scanModeStore),
                ),
                ButtonSegment(
                  value: ScanMode.burst,
                  icon: const Icon(Icons.burst_mode),
                  label: Text(l10n.scanModeBurst),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
          ),
        ),
      ),
      body: hasCamera
          ? CameraScannerView(onCode: _onCode, panel: panel)
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      l10n.scanUnavailableDesktop,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CodeEntryField(onSubmitted: _onCode),
                    const SizedBox(height: 16),
                    panel,
                  ],
                ),
              ),
            ),
    );
  }
}
