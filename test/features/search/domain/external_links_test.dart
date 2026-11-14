import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/search/domain/external_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BD links search Bédéthèque by ISBN or text', () {
    expect(
      externalLinks(
        CollectionType.bd,
        isbn13: '9782266320481',
      ).single.uri.toString(),
      'https://www.bedetheque.com/search/albums?RechISBN=9782266320481',
    );
    expect(
      externalLinks(
        CollectionType.bd,
        query: 'naheulbeuk',
      ).single.uri.toString(),
      'https://www.bedetheque.com/search/tout?RechTexte=naheulbeuk',
    );
  });

  test('manga and comics link to Manga-News and Comic Vine', () {
    expect(
      externalLinks(CollectionType.manga, query: 'dreamland').single.name,
      'Manga-News',
    );
    expect(
      externalLinks(
        CollectionType.comic,
        query: 'batman 3',
      ).single.uri.toString(),
      'https://comicvine.gamespot.com/search/?q=batman+3',
    );
    expect(externalLinks(CollectionType.livre, query: 'x'), isEmpty);
  });
}
