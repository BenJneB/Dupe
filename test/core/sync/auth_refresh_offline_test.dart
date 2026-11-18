import 'dart:async';
import 'dart:convert';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/supabase_sync.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';

/// Offline, the token refresh fails every tick and gotrue reports it as an
/// error on onAuthStateChange: it was an uncaught error logged every 20 s.
void main() {
  // gotrue reads the expiry from the token itself.
  String jwt(int exp) {
    String part(Object json) =>
        base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
    return '${part({'alg': 'HS256'})}.${part({'sub': 'u', 'exp': exp})}.sig';
  }

  test('a failed token refresh offline is not an uncaught error', () async {
    await appLog.clear();
    final db = AppDatabase.memory();
    final settings = AppSettingsStore(db);
    final expired = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60;
    await settings.set(
      'supabase_session',
      jsonEncode({
        'access_token': jwt(expired),
        'refresh_token': 'r',
        'token_type': 'bearer',
        'expires_in': 3600,
        'expires_at': expired,
        'user': {
          'id': 'u',
          'aud': 'authenticated',
          'created_at': '2026-11-18T00:00:00Z',
          'app_metadata': <String, Object?>{},
          'user_metadata': <String, Object?>{},
        },
      }),
    );
    final uncaught = <Object>[];
    late SupabaseClient client;
    late SupabaseSyncAuth auth;

    // All in one error zone, as in the app (main): an error crossing a zone
    // boundary would be reported as uncaught even when handled.
    await runZonedGuarded(() async {
      // Nothing listens on port 9: connection refused, as with no network.
      client = SupabaseClient('http://127.0.0.1:9', 'anon');
      auth = SupabaseSyncAuth(client, settings);
      await auth.restore();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }, (e, _) => uncaught.add(e));

    expect(uncaught, isEmpty);
    expect(auth.userId, 'u', reason: 'the session is kept for later');
    auth.dispose();
    await client.dispose();
    await db.close();
  });
}
