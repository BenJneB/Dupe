import 'package:dupe/features/backup/data/csv_codec.dart';
import 'package:dupe/features/backup/domain/import_field.dart';
import 'package:dupe/features/backup/domain/import_values.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Csv', () {
    test('round trip with quotes, separators, line breaks and accents', () {
      final rows = [
        ['Titre', 'Notes'],
        ['L’Épée « magique »', 'a; b'],
        ['Dit "bonjour"', 'ligne 1\nligne 2'],
      ];
      final text = Csv.write(rows);
      expect(text, startsWith('﻿'));
      expect(Csv.parse(text), rows);
    });

    test('detects comma and tab separators; blank lines kept except at '
        'the end', () {
      expect(Csv.parse('a,b\r\n\r\n1,"2,5"\r\n\r\n'), [
        ['a', 'b'],
        [''],
        ['1', '2,5'],
      ]);
      expect(Csv.parse('a\tb\n1\t2'), [
        ['a', 'b'],
        ['1', '2'],
      ]);
    });
  });

  test('headers of other apps are mapped automatically', () {
    // CLZ-like export (English headers).
    final clz = guessMapping([
      'Series',
      'Issue Nr',
      'Title',
      'Publisher',
      'Barcode',
      'Read',
      'Purchase Price',
      'Purchase Date',
      'Storage Box',
      'Comments',
    ]);
    expect(clz[ImportField.series], 0);
    expect(clz[ImportField.volume], 1);
    expect(clz[ImportField.title], 2);
    expect(clz[ImportField.isbn], 4);
    expect(clz[ImportField.readingStatus], 5);
    expect(clz[ImportField.purchasePrice], 6);
    expect(clz[ImportField.location], 8);
    expect(clz[ImportField.notes], 9);
    expect(clz[ImportField.authors], isNull);

    // French headers (Mangacollec-like and our own export).
    final fr = guessMapping(['Série', 'Tome', 'Éditeur', 'Lu', "Date d'achat"]);
    expect(fr[ImportField.series], 0);
    expect(fr[ImportField.volume], 1);
    expect(fr[ImportField.publisher], 2);
    expect(fr[ImportField.readingStatus], 3);
    expect(fr[ImportField.purchaseDate], 4);
  });

  test('cell values are read leniently', () {
    expect(ImportValues.type('Mangas'), CollectionType.manga);
    expect(ImportValues.type('Bande dessinée'), CollectionType.bd);
    expect(ImportValues.type('???'), isNull);
    expect(ImportValues.ownership('Wishlist'), Ownership.envie);
    expect(ImportValues.reading('Oui'), ReadingStatus.lu);
    expect(ImportValues.reading('abandonné'), ReadingStatus.abandonne);
    expect(ImportValues.price('7,20 €'), 7.2);
    expect(ImportValues.price(r'$4.99'), 4.99);
    expect(ImportValues.date('2026-11-14'), DateTime(2026, 11, 14));
    expect(ImportValues.date('14/11/2026'), DateTime(2026, 11, 14));
    expect(ImportValues.date('31/13/2026'), isNull);
    expect(ImportValues.date('31/02/2026'), isNull); // Not March 3.
    expect(ImportValues.date('2026-02-30'), isNull);
    expect(ImportValues.people('Lang, Poinsot & Kim'), [
      'Lang',
      'Poinsot',
      'Kim',
    ]);
  });
}
