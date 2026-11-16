import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

/// The scanner cannot run (Google Play services missing or too old, module
/// not downloaded yet while offline…): the manual editor takes over.
class ScannerUnavailable implements Exception {
  const new(this.reason);

  final String reason;

  @override
  String toString() => 'ScannerUnavailable: $reason';
}

/// Automatic cover capture (edges detected, perspective corrected).
abstract interface class CoverScanner {
  /// The cropped cover, or null when the user cancels; throws
  /// [ScannerUnavailable] when it cannot run.
  Future<Uint8List?> scan();
}

/// ML Kit document scanner (Android only, through Google Play services).
class MlKitCoverScanner implements CoverScanner {
  @override
  Future<Uint8List?> scan() async {
    // Base mode: detection, crop and rotation, without the "cleaning"
    // filters that would retouch the illustration.
    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        mode: ScannerMode.base,
        isGalleryImport: true,
      ),
    );
    try {
      final result = await scanner.scanDocument();
      final path = result.images?.firstOrNull;
      if (path == null) return null;
      return await File(path).readAsBytes();
    } on PlatformException catch (e) {
      if (e.message == 'Operation cancelled') return null;
      throw ScannerUnavailable(e.message ?? e.code);
    } on MissingPluginException catch (e) {
      throw ScannerUnavailable(e.message ?? 'missing plugin');
    } finally {
      await scanner.close();
    }
  }
}
