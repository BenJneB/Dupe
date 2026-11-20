import 'package:dupe/core/utils/text_fold.dart';

/// Fields a CSV column can be mapped to.
enum ImportField {
  title,
  series,
  volume,
  volumeTitle,
  type,
  authors,
  publisher,
  isbn,
  ownership,
  readingStatus,
  purchasePrice,
  purchaseDate,
  coverPrice,
  location,
  notes,
  // Signed copies (phase 31), as the app's own CSV export writes them.
  signed,
  signedBy,
  signedOn,
  signedPlace,
  signingNote,
}

/// Header names recognised automatically (folded: lowercase, no accents),
/// including those of the app's own CSV export, Mangacollec and CLZ.
const _synonyms = <ImportField, List<String>>{
  ImportField.title: ['titre', 'title', 'nom', 'name', 'album'],
  ImportField.series: ['serie', 'series', 'collection title', 'manga'],
  ImportField.volume: [
    'tome',
    'volume',
    'numero',
    'issue',
    'issue nr',
    'no',
    'n',
  ],
  ImportField.volumeTitle: [
    'titre du tome',
    'sous titre',
    'subtitle',
    'volume title',
    'issue title',
  ],
  ImportField.type: ['type', 'categorie', 'category', 'format type'],
  ImportField.authors: [
    'auteurs',
    'auteur',
    'authors',
    'author',
    'scenariste',
    'writer',
    'auteur s',
    'author s',
    'creators',
  ],
  ImportField.publisher: [
    'editeur',
    'publisher',
    'edition',
    'maison d edition',
  ],
  ImportField.isbn: [
    'isbn',
    'isbn13',
    'isbn 13',
    'ean',
    'barcode',
    'code barre',
  ],
  ImportField.ownership: [
    'possession',
    'ownership',
    'statut',
    'status',
    'owned',
  ],
  ImportField.readingStatus: [
    'lecture',
    'lu',
    'read',
    'read status',
    'reading status',
  ],
  ImportField.purchasePrice: [
    'prix paye',
    'prix d achat',
    'purchase price',
    'price paid',
    'prix',
  ],
  ImportField.purchaseDate: [
    'date d achat',
    'purchase date',
    'achete le',
    'date',
  ],
  ImportField.coverPrice: [
    'prix editeur',
    'cover price',
    'prix public',
    'prix neuf',
  ],
  ImportField.location: ['emplacement', 'location', 'rangement', 'storage box'],
  ImportField.notes: ['notes', 'note', 'commentaire', 'comments', 'remarques'],
  ImportField.signed: ['dedicace', 'signed', 'autographed'],
  ImportField.signedBy: ['dedicace par', 'signed by'],
  ImportField.signedOn: ['date de dedicace', 'signed on', 'signing date'],
  ImportField.signedPlace: ['lieu de dedicace', 'signing place'],
  ImportField.signingNote: ['texte de dedicace', 'inscription'],
};

String _norm(String header) =>
    foldForSearch(header).replaceAll(RegExp('[^a-z0-9]+'), ' ').trim();

/// Column index guessed for each field from the headers (exact synonym
/// first; a column is used once).
Map<ImportField, int?> guessMapping(List<String> headers) {
  final names = headers.map(_norm).toList();
  final used = <int>{};
  final mapping = <ImportField, int?>{};
  for (final field in ImportField.values) {
    final synonyms = _synonyms[field]!;
    int? found;
    for (final synonym in synonyms) {
      final i = names.indexOf(synonym);
      if (i >= 0 && !used.contains(i)) {
        found = i;
        break;
      }
    }
    if (found != null) used.add(found);
    mapping[field] = found;
  }
  return mapping;
}
