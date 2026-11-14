import 'package:dupe/core/sync/email_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

const base = 'https://abcd.supabase.co/auth/v1/verify';

void main() {
  test('a 6-digit code', () {
    expect(EmailCredential.parse(' 123456 '), isA<EmailCode>());
    expect(EmailCredential.parse('12345'), isNull);
  });

  test('the link of the default magic link email', () {
    final c = EmailCredential.parse(
      '$base?token=f3a9c1&type=magiclink&redirect_to=http://localhost:3000',
    );
    expect(c, isA<EmailLink>());
    expect((c! as EmailLink).tokenHash, 'f3a9c1');
    expect((c as EmailLink).type, 'magiclink');
  });

  test('first sign-in: the "confirm sign up" link, even inside text', () {
    final c = EmailCredential.parse(
      'Confirm your mail <$base?token=9b8e&type=signup&redirect_to=x> thanks',
    );
    expect((c! as EmailLink).type, 'signup');
    expect((c as EmailLink).tokenHash, '9b8e');
  });

  test('other links are rejected', () {
    expect(EmailCredential.parse('$base?token=x&type=recovery'), isNull);
    expect(EmailCredential.parse('$base?type=magiclink'), isNull);
    expect(EmailCredential.parse('https://example.org'), isNull);
    expect(EmailCredential.parse('n’importe quoi'), isNull);
  });
}
