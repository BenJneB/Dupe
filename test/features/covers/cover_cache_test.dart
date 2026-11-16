import 'dart:async';
import 'dart:io';

import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('journal causes never rely on class names (obfuscated Releases)', () {
    expect(
      coverError(const HttpExceptionWithStatus(404, 'Invalid statusCode')),
      'HTTP 404',
    );
    expect(
      coverError(const SocketException('Failed host lookup')),
      'pas de réseau',
    );
    expect(coverError(TimeoutException('slow')), 'délai dépassé');
    expect(coverError(StateError('broken\nsecond line')), 'Bad state: broken');
    final long = coverError(FormatException('x' * 200));
    expect(long.length, 81);
    expect(long, endsWith('…'));
  });
}
