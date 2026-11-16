import 'dart:async';
import 'dart:typed_data';

import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_scanner.dart';

/// Connection controlled by the test (no connection by default: the
/// prefetch does nothing unless a test asks for it).
class FakeNetworkStatus implements NetworkStatus {
  new([this.kind = NetworkKind.none]);

  NetworkKind kind;
  final _changes = StreamController<NetworkKind>.broadcast();

  void change(NetworkKind to) {
    kind = to;
    _changes.add(to);
  }

  @override
  Future<NetworkKind> current() async => kind;

  @override
  Stream<NetworkKind> get changes => _changes.stream;
}

/// Covers "downloaded" in memory; [failing] URLs throw.
class FakeCoverCache implements CoverCache {
  final cached = <String>{};
  final failing = <String>{};
  final fetched = <String>[];

  /// Completed by the test to let each download finish; null = at once.
  Completer<void>? gate;

  @override
  Future<bool> has(String url) async => cached.contains(url);

  @override
  Future<void> fetch(String url) async {
    fetched.add(url);
    await gate?.future;
    if (failing.contains(url)) throw StateError('404 $url');
    cached.add(url);
  }

  @override
  Future<int> sizeInBytes() async => cached.length * 100 * 1024;

  @override
  Future<void> clear() async => cached.clear();
}

/// Document scanner: unavailable by default (manual editor), or answers
/// [result] (null = cancelled).
class FakeCoverScanner implements CoverScanner {
  new({this.available = false, this.result});

  final bool available;
  final Uint8List? result;
  int scans = 0;

  @override
  Future<Uint8List?> scan() async {
    scans++;
    if (!available) throw const ScannerUnavailable('test');
    return result;
  }
}
