import 'package:dupe/features/collection/domain/collection_type.dart';

/// Website to look a work up manually when sources find nothing.
/// Links only: these sites have no API and must not be scraped.
typedef ExternalLink = ({String name, Uri uri});

/// Search pages checked on 2026-11-14 (HTTP 200; Comic Vine blocks curl but
/// works in a browser).
List<ExternalLink> externalLinks(
  CollectionType type, {
  String? isbn13,
  String? query,
}) {
  final text = query ?? isbn13 ?? '';
  return switch (type) {
    CollectionType.bd => [
      (
        name: 'Bédéthèque',
        uri: isbn13 != null
            ? Uri.https('www.bedetheque.com', '/search/albums', {
                'RechISBN': isbn13,
              })
            : Uri.https('www.bedetheque.com', '/search/tout', {
                'RechTexte': text,
              }),
      ),
    ],
    CollectionType.manga => [
      (
        name: 'Manga-News',
        uri: Uri.https('www.manga-news.com', '/index.php/recherche/', {
          'q': text,
        }),
      ),
    ],
    CollectionType.comic => [
      (
        name: 'Comic Vine',
        uri: Uri.https('comicvine.gamespot.com', '/search/', {'q': text}),
      ),
    ],
    CollectionType.livre => const [],
  };
}
