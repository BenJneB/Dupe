/// Compile-time configuration injected with `--dart-define-from-file=env.json`.
///
/// Never hardcode secrets here: values come from env.json (git-ignored).
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const comicVineApiKey = String.fromEnvironment('COMIC_VINE_API_KEY');
  static const googleBooksApiKey = String.fromEnvironment(
    'GOOGLE_BOOKS_API_KEY',
  );

  /// Contact email sent to Open Library in the User-Agent (raises its rate
  /// limit from 1 to 3 req/s). Optional.
  static const openLibraryContact = String.fromEnvironment(
    'OPEN_LIBRARY_CONTACT',
  );

  /// Whether cloud sync can be enabled (the app stays usable offline).
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
