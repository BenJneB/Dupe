import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

@immutable
class LogEntry {
  const new(this.at, this.level, this.source, this.message);

  final DateTime at;
  final LogLevel level;

  /// Short area name: `sync`, `bnf`, `backup`…
  final String source;
  final String message;

  String toJsonLine() => jsonEncode({
    't': at.toUtc().toIso8601String(),
    'l': level.name,
    's': source,
    'm': message,
  });

  static LogEntry? tryParse(String line) {
    try {
      final m = jsonDecode(line) as Map<String, dynamic>;
      return LogEntry(
        DateTime.parse(m['t'] as String).toLocal(),
        LogLevel.values.byName(m['l'] as String),
        m['s'] as String,
        m['m'] as String,
      );
    } on Object {
      return null;
    }
  }

  @override
  String toString() =>
      '${at.toIso8601String()} ${level.name.toUpperCase()} [$source] '
      '$message';
}

/// Error journal kept on the device (PLAN_V2 phase 9): the last [capacity]
/// entries, in memory and, once [attach]ed, in a JSON-lines file. Shown in
/// About → Journal so problems can be copied and reported.
///
/// Never log secrets (passwords, tokens, API keys).
class AppLog {
  new({this.capacity = 500, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final int capacity;
  final DateTime Function() _now;
  final _entries = <LogEntry>[];
  final _changes = StreamController<void>.broadcast();
  File? _file;
  var _fileLines = 0;
  Future<void> _writes = Future.value();

  /// Oldest first.
  List<LogEntry> get entries => List.unmodifiable(_entries);
  Stream<void> get changes => _changes.stream;

  void info(String source, String message) =>
      _add(LogLevel.info, source, message);

  void warning(String source, Object error) =>
      _add(LogLevel.warning, source, '$error');

  void error(String source, Object error, [StackTrace? stack]) {
    final trace = stack == null
        ? ''
        : '\n${stack.toString().split('\n').take(8).join('\n')}';
    _add(LogLevel.error, source, '$error$trace');
  }

  void _add(LogLevel level, String source, String message) {
    final entry = LogEntry(_now(), level, source, message);
    if (_echo) debugPrint('$entry');
    _entries.add(entry);
    if (_entries.length > capacity) _entries.removeAt(0);
    _changes.add(null);
    final file = _file;
    if (file == null) return;
    _queue(() async {
      if (++_fileLines > capacity * 2) {
        await _rewrite(file);
      } else {
        await file.writeAsString(
          '${entry.toJsonLine()}\n',
          mode: FileMode.append,
          flush: true,
        );
      }
    });
  }

  /// Loads the previous entries from [file] and appends new ones to it.
  Future<void> attach(File file) async {
    try {
      if (file.existsSync()) {
        final previous = [
          for (final line in await file.readAsLines()) ?LogEntry.tryParse(line),
        ];
        _entries.insertAll(0, previous);
        if (_entries.length > capacity) {
          _entries.removeRange(0, _entries.length - capacity);
        }
        _changes.add(null);
      }
      await _rewrite(file);
      _file = file;
    } on Object catch (e) {
      // The journal must never break the app: memory only.
      if (_echo) debugPrint('Log file unavailable: $e');
    }
  }

  Future<void> clear() async {
    _entries.clear();
    _changes.add(null);
    if (_file case final file?) _queue(() => _rewrite(file));
    await _writes;
  }

  /// Waits for pending file writes.
  @visibleForTesting
  Future<void> flush() => _writes;

  /// Plain text, oldest first, for copying or sharing.
  String export() => _entries.join('\n');

  Future<void> _rewrite(File file) async {
    await file.parent.create(recursive: true);
    await file.writeAsString(
      _entries.map((e) => '${e.toJsonLine()}\n').join(),
      flush: true,
    );
    _fileLines = _entries.length;
  }

  void _queue(Future<void> Function() write) {
    _writes = _writes.then((_) => write()).catchError((Object e) {
      if (_echo) debugPrint('Log write failed: $e');
    });
  }
}

/// Debug runs print the journal to the console; tests don't (noise).
final bool _echo =
    kDebugMode && !Platform.environment.containsKey('FLUTTER_TEST');

/// The app's journal. A global (not a provider) so that any layer can log,
/// including code running before Riverpod or outside it.
final appLog = AppLog();
