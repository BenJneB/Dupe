/// Identity of a cover image across URL variants, to remember a refused one:
/// a Google Books volume id (any zoom, curl or protocol), an Open Library
/// cover id / ISBN / OLID (any size), otherwise host + path (no protocol, no
/// query).
String coverImageKey(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || uri.host.isEmpty) return url.trim();
  final host = uri.host.toLowerCase();
  final googleId = uri.queryParameters['id'];
  if (host.contains('books.google') && googleId != null) return 'gb:$googleId';
  if (host == 'covers.openlibrary.org') {
    final m = RegExp(
      r'^/b/(id|isbn|olid)/([^/]+?)(?:-[SML])?\.jpg$',
      caseSensitive: false,
    ).firstMatch(uri.path);
    if (m != null) return 'ol:${m[1]!.toLowerCase()}:${m[2]}';
  }
  return '$host${uri.path}';
}
