import 'dart:async';
import 'dart:io';

import 'package:file/file.dart' as fs;
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cover_cache.g.dart';

Future<Directory> _cacheDir() async => Directory(
  p.join((await getApplicationSupportDirectory()).path, 'cover_cache'),
);

/// Downloaded covers, shared by every `CachedNetworkImage` and the
/// prefetch. Not the default cache manager: it keeps 200 files for 30 days
/// in the temporary directory (/tmp on Linux, cleared by Android when space
/// runs low); the collection must stay visible offline.
final CacheManager coverCacheManager = CacheManager(
  Config(
    'dupe_covers',
    stalePeriod: const Duration(days: 730),
    maxNrOfCacheObjects: 20000,
    fileSystem: const _SupportFileSystem(_cacheDir),
  ),
);

class _SupportFileSystem implements FileSystem {
  const new(this._dir);

  final Future<Directory> Function() _dir;

  @override
  Future<fs.File> createFile(String name) async {
    final dir = await _dir();
    await dir.create(recursive: true);
    return const LocalFileSystem().file(p.join(dir.path, name));
  }
}

/// Covers downloaded from the metadata sources. Overridden in tests.
abstract interface class CoverCache {
  Future<bool> has(String url);

  /// Downloads [url] into the cache; throws when it fails.
  Future<void> fetch(String url);

  Future<int> sizeInBytes();

  Future<void> clear();
}

class NetworkCoverCache implements CoverCache {
  const new();

  @override
  Future<bool> has(String url) async =>
      await coverCacheManager.getFileFromCache(url) != null;

  @override
  Future<void> fetch(String url) => coverCacheManager.downloadFile(url);

  @override
  Future<int> sizeInBytes() async {
    final dir = await _cacheDir();
    if (!dir.existsSync()) return 0;
    var size = 0;
    await for (final entry in dir.list()) {
      if (entry is File) size += await entry.length();
    }
    return size;
  }

  @override
  Future<void> clear() => coverCacheManager.emptyCache();
}

@Riverpod(keepAlive: true)
CoverCache coverCache(Ref ref) => const NetworkCoverCache();

/// Short cause for the journal: "HTTP 404", "pas de réseau"… Never the
/// class name (`runtimeType`): public Releases are obfuscated, class names
/// become meaningless there; messages are kept (string literals).
String coverError(Object e) => switch (e) {
  HttpExceptionWithStatus(:final statusCode) => 'HTTP $statusCode',
  SocketException() => 'pas de réseau',
  TimeoutException() => 'délai dépassé',
  _ => _firstLine('$e'),
};

String _firstLine(String text) {
  final line = text.split('\n').first.trim();
  return line.length <= 80 ? line : '${line.substring(0, 80)}…';
}
