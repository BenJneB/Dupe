/// What the user pasted to sign in: the 6-digit code, or the link of the
/// default Supabase email (`…/auth/v1/verify?token=<hash>&type=magiclink`).
///
/// The default email templates of Supabase (not editable without custom
/// SMTP) only contain a link; copying it into the app avoids deep links,
/// which are awkward on desktop.
sealed class EmailCredential {
  const new();

  /// Null when [input] is neither a 6-digit code nor a sign-in link.
  static EmailCredential? parse(String input) {
    final text = input.trim();
    if (RegExp(r'^\d{6}$').hasMatch(text)) return EmailCode(text);
    final match = RegExp(r'https?://\S+').firstMatch(text);
    final uri = match == null ? null : Uri.tryParse(match.group(0)!);
    final token = uri?.queryParameters['token'];
    final type = uri?.queryParameters['type'];
    if (uri == null || token == null || token.isEmpty || type == null) {
      return null;
    }
    // First sign-in = "confirm sign up" email, later = magic link.
    return switch (type) {
      'signup' || 'magiclink' || 'email' || 'invite' => EmailLink(token, type),
      _ => null,
    };
  }
}

class EmailCode extends EmailCredential {
  const new(this.code);

  final String code;
}

class EmailLink extends EmailCredential {
  const new(this.tokenHash, this.type);

  final String tokenHash;

  /// `signup`, `magiclink`, `email` or `invite`.
  final String type;
}
