import 'dart:io';

import 'package:dupe/core/logging/app_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  var clock = DateTime(2026, 11, 14, 10);
  DateTime now() => clock = clock.add(const Duration(seconds: 1));

  setUp(() async => dir = await Directory.systemTemp.createTemp('dupe_log'));
  tearDown(() => dir.delete(recursive: true));

  test('keeps the last entries only', () {
    final log = AppLog(capacity: 3, now: now);
    for (var i = 0; i < 5; i++) {
      log.info('test', 'm$i');
    }
    expect(log.entries.map((e) => e.message), ['m2', 'm3', 'm4']);
    expect(log.export(), contains('INFO [test] m4'));
  });

  test('errors keep the start of their stack trace', () {
    final log = AppLog(now: now)
      ..error('sync', StateError('boom'), StackTrace.current);
    final entry = log.entries.single;
    expect(entry.level, LogLevel.error);
    expect(entry.message, startsWith('Bad state: boom\n'));
    expect(entry.message.split('\n').length, lessThanOrEqualTo(9));
  });

  test('survives a restart through its file, compacted', () async {
    final file = File('${dir.path}/log.jsonl');
    final first = AppLog(capacity: 3, now: now);
    await first.attach(file);
    for (var i = 0; i < 10; i++) {
      first.warning('net', 'w$i');
    }
    await first.flush();
    expect((await file.readAsLines()).length, lessThanOrEqualTo(6));
    await file.writeAsString('not json\n', mode: FileMode.append);

    final second = AppLog(capacity: 3, now: now);
    await second.attach(file);
    expect(second.entries.map((e) => e.message), ['w7', 'w8', 'w9']);

    await second.clear();
    expect(await file.readAsString(), isEmpty);
  });

  test('a file that cannot be written leaves the journal in memory', () async {
    final log = AppLog(now: now);
    // A directory is not a writable file.
    await log.attach(File(dir.path));
    log.info('x', 'still logged');
    expect(log.entries.single.message, 'still logged');
  });
}
