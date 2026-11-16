import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dupe/features/backup/data/file_io.dart';

/// Records saved files; [toOpen] is returned by the next open dialog.
class FakeFileIo implements FileIo {
  final saved = <String, Uint8List>{};
  OpenedFile? toOpen;

  /// Texts given to [shareText].
  final sharedTexts = <String>[];

  /// When set, [save] waits for it (share sheet left open).
  Completer<void>? gate;

  String text(String name) => utf8.decode(saved[name]!);

  @override
  Future<bool> save(
    String name,
    Uint8List bytes, {
    required String mimeType,
  }) async {
    await gate?.future;
    saved[name] = bytes;
    return true;
  }

  @override
  Future<OpenedFile?> open({
    required String label,
    required List<String> extensions,
    required List<String> mimeTypes,
  }) async => toOpen;

  @override
  Future<TextShare> shareText(String text, {required String subject}) async {
    sharedTexts.add(text);
    return TextShare.shared;
  }
}
