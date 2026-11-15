import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/settings/data/starter_dreamland.dart';

/// `title` null: the volume is titled like its series.
typedef StarterVolume = ({
  String number,
  String? title,
  String? isbn13,
  String? edition,
});

typedef StarterSeries = ({
  CollectionType type,
  String title,
  List<String> authors,
  String publisher,
  PublicationStatus status,
  int? total,

  /// Owned volumes 1..ownedUpTo (titled like the series, without ISBN).
  int ownedUpTo,

  /// Volumes listed one by one (own title, ISBN, edition).
  List<StarterVolume> volumes,
});

typedef StarterBook = ({
  String title,
  List<String> authors,
  String publisher,
  String publishDate,
  String isbn13,
});

/// Series removed from the starter collection: deleted once (if still as
/// seeded, i.e. without any ISBN) by the next import.
const List<({CollectionType type, String title})> removedStarterSeries = [
  (type: CollectionType.manga, title: 'One Piece'),
];

/// The owner's initial collection, to bootstrap the app before sync and CSV
/// import exist. Volume counts checked on 2026-11-13.
final List<StarterSeries> starterSeries = [
  (
    type: CollectionType.manga,
    title: 'Dreamland',
    authors: const ['Reno Lemaire'],
    publisher: 'Pika',
    status: PublicationStatus.enCours,
    total: 24,
    ownedUpTo: 0,
    volumes: dreamlandVolumes,
  ),
  (
    type: CollectionType.bd,
    title: 'Le Donjon de Naheulbeuk',
    authors: const ['John Lang', 'Marion Poinsot'],
    publisher: 'Clair de Lune',
    status: PublicationStatus.inconnue,
    total: 25,
    ownedUpTo: 25,
    volumes: const [],
  ),
  (
    type: CollectionType.comic,
    title: 'Batman (DC Renaissance)',
    authors: const ['Scott Snyder', 'Greg Capullo'],
    publisher: 'Urban Comics',
    status: PublicationStatus.terminee,
    total: null,
    ownedUpTo: 0,
    volumes: const [
      (number: '1', title: 'La Cour des Hiboux', isbn13: null, edition: null),
      (
        number: '2',
        title: 'La Nuit des Hiboux',
        isbn13: '9782365772068',
        edition: null,
      ),
    ],
  ),
  (
    type: CollectionType.livre,
    title: 'Les Fourmis',
    authors: const ['Bernard Werber'],
    publisher: 'Albin Michel',
    status: PublicationStatus.terminee,
    total: 3,
    ownedUpTo: 0,
    volumes: const [
      (number: '1', title: 'Les Fourmis', isbn13: null, edition: null),
      (number: '2', title: 'Le Jour des fourmis', isbn13: null, edition: null),
      (
        number: '3',
        title: 'La Révolution des fourmis',
        isbn13: null,
        edition: null,
      ),
    ],
  ),
];

/// Standalone books (ISBN from the French Wikipedia bibliography).
const List<StarterBook> starterBooks = [
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
