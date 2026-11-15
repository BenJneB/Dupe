import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'file_io.g.dart';

typedef OpenedFile = ({String name, Uint8List bytes});

/// Outcome of [FileIo.shareText].
enum TextShare { shared, copied, cancelled }

/// Saving and opening user files. Desktop: system file dialogs. Android has
/// no "save as" dialog here: exports go through the share sheet (Drive,
/// Files, email…).
abstract interface class FileIo {
  /// False when cancelled.
  Future<bool> save(String name, Uint8List bytes, {required String mimeType});

  Future<OpenedFile?> open({
    required String label,
    required List<String> extensions,
    required List<String> mimeTypes,
  });

  /// Android: share sheet (messages, email…). Desktop: copied to the
  /// clipboard, to paste anywhere.
  Future<TextShare> shareText(String text, {required String subject});
}

class PlatformFileIo implements FileIo {
  const new();

  @override
  Future<bool> save(
    String name,
    Uint8List bytes, {
    required String mimeType,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, name: name, mimeType: mimeType)],
          fileNameOverrides: [name],
        ),
      );
      return result.status != ShareResultStatus.dismissed;
    }
    final location = await getSaveLocation(suggestedName: name);
    if (location == null) return false;
    await File(location.path).writeAsBytes(bytes, flush: true);
    return true;
  }

  @override
  Future<OpenedFile?> open({
    required String label,
    required List<String> extensions,
    required List<String> mimeTypes,
  }) async {
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(label: label, extensions: extensions, mimeTypes: mimeTypes),
      ],
    );
    if (file == null) return null;
    return (name: file.name, bytes: await file.readAsBytes());
  }

  @override
  Future<TextShare> shareText(String text, {required String subject}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final result = await SharePlus.instance.share(
        ShareParams(text: text, subject: subject),
      );
      return result.status == ShareResultStatus.dismissed
          ? TextShare.cancelled
          : TextShare.shared;
    }
    await Clipboard.setData(ClipboardData(text: text));
    return TextShare.copied;
  }
}

/// Overridden in tests.
@Riverpod(keepAlive: true)
FileIo fileIo(Ref ref) => const PlatformFileIo();
