import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';

typedef _Volume = ({String number, String title, String? isbn13});

typedef _SeriesSeed = ({
  CollectionType type,
  String title,
  List<String> authors,
  String publisher,
  PublicationStatus status,
  int? total,

  /// Owned volumes 1..ownedUpTo (titled like the series).
  int ownedUpTo,

  /// Volumes with their own title (book cycles, comics).
  List<_Volume> volumes,
});

/// The owner's initial collection, to bootstrap the app before sync and CSV
/// import exist. Volume counts checked on 2026-11-13.
const List<_SeriesSeed> _seeds = [
  (
    type: CollectionType.manga,
    title: 'One Piece',
    authors: ['Eiichirō Oda'],
    publisher: 'Glénat',
    status: PublicationStatus.enCours,
    total: 113,
    ownedUpTo: 113,
    volumes: [],
  ),
  (
    type: CollectionType.manga,
    title: 'Dreamland',
    authors: ['Reno Lemaire'],
    publisher: 'Pika',
    status: PublicationStatus.enCours,
    total: 24,
    ownedUpTo: 24,
    volumes: [],
  ),
  (
    type: CollectionType.bd,
    title: 'Le Donjon de Naheulbeuk',
    authors: ['John Lang', 'Marion Poinsot'],
    publisher: 'Clair de Lune',
    status: PublicationStatus.inconnue,
    total: 25,
    ownedUpTo: 25,
    volumes: [],
  ),
  (
    type: CollectionType.comic,
    title: 'Batman (DC Renaissance)',
    authors: ['Scott Snyder', 'Greg Capullo'],
    publisher: 'Urban Comics',
    status: PublicationStatus.terminee,
    total: null,
    ownedUpTo: 0,
    volumes: [
      (number: '1', title: 'La Cour des Hiboux', isbn13: null),
      (number: '2', title: 'La Nuit des Hiboux', isbn13: '9782365772068'),
    ],
  ),
  (
    type: CollectionType.livre,
    title: 'Les Fourmis',
    authors: ['Bernard Werber'],
    publisher: 'Albin Michel',
    status: PublicationStatus.terminee,
    total: 3,
    ownedUpTo: 0,
    volumes: [
      (number: '1', title: 'Les Fourmis', isbn13: null),
      (number: '2', title: 'Le Jour des fourmis', isbn13: null),
      (number: '3', title: 'La Révolution des fourmis', isbn13: null),
    ],
  ),
];

typedef _BookSeed = ({
  String title,
  List<String> authors,
  String publisher,
  String publishDate,
  String isbn13,
});

/// Standalone books (ISBN from the French Wikipedia bibliography).
const List<_BookSeed> _books = [
  (
    title: 'Votre cerveau est extraordinaire',
    authors: ['Fabien Olicard'],
    publisher: 'First',
    publishDate: '2017',
    isbn13: '9782412022917',
  ),
  (
    title: 'Votre cerveau est définitivement extraordinaire !',
    authors: ['Fabien Olicard'],
    publisher: 'First',
    publishDate: '2018',
    isbn13: '9782412035474',
  ),
  (
    title: 'Votre temps est infini',
    authors: ['Fabien Olicard'],
    publisher: 'First',
    publishDate: '2019',
    isbn13: '9782412049402',
  ),
  (
    title: 'Le bonheur est caché dans un coin de votre cerveau',
    authors: ['Fabien Olicard'],
    publisher: 'First',
    publishDate: '2020',
    isbn13: '9782412060230',
  ),
  (
    title: 'L’antiguide de la manipulation',
    authors: ['Fabien Olicard'],
    publisher: 'First',
    publishDate: '2021',
    isbn13: '9782412068465',
  ),
  (
    title: 'Mémoire : vous avez le pouvoir !',
    authors: ['Michel Cymes', 'Fabien Olicard'],
    publisher: 'First / Solar',
    publishDate: '2022',
    isbn13: '9782263179365',
  ),
  (
    title: 'Votre idée va devenir une réalité',
    authors: ['Fabien Olicard'],
    publisher: 'First',
    publishDate: '2023',
    isbn13: '9782412088371',
  ),
];

/// Inserts the starter collection; series already present (same type and
/// title) are skipped, so it can be run several times. Returns the number of
/// series and standalone books created.
Future<int> seedStarterCollection(CollectionRepository repo) async {
  var created = 0;
  for (final seed in _seeds) {
    if (await repo.findSeries(seed.type, seed.title) != null) continue;
    final series = repo
        .newSeries(seed.type)
        .copyWith(
          title: seed.title,
          authors: seed.authors,
          publisher: seed.publisher,
          statusPublication: seed.status,
          totalVolumes: seed.total,
        );
    await repo.saveSeries(series);
    if (seed.ownedUpTo > 0) {
      await repo.addVolumeRange(series, from: 1, to: seed.ownedUpTo);
    }
    for (final v in seed.volumes) {
      await repo.saveItem(
        repo
            .newItem(seed.type, series: series, volumeNumber: v.number)
            .copyWith(title: v.title, isbn13: v.isbn13),
      );
    }
    created++;
  }
  for (final book in _books) {
    if (await repo.findStandaloneItem(CollectionType.livre, book.title) !=
        null) {
      continue;
    }
    await repo.saveItem(
      repo
          .newItem(CollectionType.livre)
          .copyWith(
            title: book.title,
            authors: book.authors,
            publisher: book.publisher,
            publishDate: book.publishDate,
            isbn13: book.isbn13,
          ),
    );
    created++;
  }
  return created;
}
