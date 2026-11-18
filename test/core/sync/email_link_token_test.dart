import 'package:dupe/core/sync/sync_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the token of a pasted email link; a code is not a link', () {
    expect(
      emailLinkToken(
        [
          ' https://abc.supabase.co/auth/v1/verify?token=pkce_9f2a',
          'type=signup',
          'redirect_to=http://localhost:3000 ',
        ].join('&'),
      ),
      'pkce_9f2a',
    );
    expect(emailLinkToken('https://x.example/confirm?token_hash=h1'), 'h1');
    expect(emailLinkToken('123456'), isNull);
    expect(emailLinkToken('https://x.example/no-token'), isNull);
  });
}
