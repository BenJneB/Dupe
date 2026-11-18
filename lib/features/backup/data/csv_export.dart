import 'package:dupe/features/backup/data/csv_codec.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// Column headers: recognised again by the CSV import.
const csvHeaders = [
  'Type',
  'Série',
  'Tome',
  'Titre du tome',
  'Titre',
  'Auteurs',
  'Éditeur',
  'ISBN',
  'Possession',
  'Lecture',
  'Prix payé',
  "Date d'achat",
  'Prix éditeur',
  'Emplacement',
  'Notes',
  // Signed copies (phase 31).
  'Dédicacé',
  'Dédicacé par',
  'Date de dédicace',
  'Lieu de dédicace',
  'Texte de dédicace',
];

/// One line per item (copy), ordered by series then volume.
String itemsToCsv(List<Item> items, Map<String, Series> series) {
  String? money(double? v) => v?.toStringAsFixed(2).replaceAll('.', ',');
  String? day(DateTime? d) => d == null
      ? null
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';
  return Csv.write([
    csvHeaders,
    for (final i in items)
      [
        i.type.dbValue,
        series[i.seriesId]?.title,
        i.volumeNumber,
        i.volumeTitle,
        i.title,
        i.authors.join(', '),
        i.publisher,
        i.isbn13,
        switch (i.ownership) {
          Ownership.possede => 'possédé',
          Ownership.envie => 'envie',
        },
        switch (i.readingStatus) {
          ReadingStatus.nonLu => 'non lu',
          ReadingStatus.enCours => 'en cours',
          ReadingStatus.lu => 'lu',
          ReadingStatus.abandonne => 'abandonné',
        },
        money(i.purchasePrice),
        day(i.purchaseDate),
        money(i.coverPrice),
        i.location,
        i.notes,
        if (i.isSigned) 'oui' else null,
        i.signedBy,
        day(i.signedOn),
        i.signedPlace,
        i.signingNote,
      ],
  ]);
}
