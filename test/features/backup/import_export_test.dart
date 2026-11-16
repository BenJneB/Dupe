import 'package:dupe/features/backup/data/csv_codec.dart';
import 'package:dupe/features/backup/data/csv_export.dart';
import 'package:dupe/features/backup/data/csv_import.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/backup/domain/import_field.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_repositories.dart';

const ImportDefaults defaults = (
  type: CollectionType.manga,
  ownership: Ownership.possede,
);

void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  Future<ImportReport> importText(String csv) {
    final rows = Csv.parse(csv);
    return importCsvRows(
      env.repo,
      rows.skip(1).toList(),
      guessMapping(rows.first),
      defaults,
    );
  }

  test('CSV import creates series and volumes, and skips duplicates', () async {
    const csv =
        'Série;Tome;Titre;Auteurs;Éditeur;ISBN;Lecture;Prix payé\n'
        'One Piece;1;;Eiichirō Oda;Glénat;978-2-7234-2877-4;lu;6,90\n'
        'One Piece;2;;Eiichirō Oda;Glénat;;non lu;\n'
        ';;;;;;;\n'
        ';;;Auteur seul;;;;\n'
        'Livre isolé;;;;;;;\n';
    final report = await importText(csv);
    expect(report.created, 3);
    expect(report.seriesCreated, 2);
    expect(report.invalidLines, [5]);

    final series = (await env.repo.findSeries(
      CollectionType.manga,
      'One Piece',
    ))!;
    expect(series.publisher, 'Glénat');
    final volumes = await env.repo.listSeriesItems(series.id);
    expect(volumes.map((v) => v.volumeNumber), ['1', '2']);
    expect(volumes.first.isbn13, '9782723428774');
    expect(volumes.first.readingStatus, ReadingStatus.lu);
    expect(volumes.first.purchasePrice, 6.9);
    expect(volumes.first.title, 'One Piece');

    // Running it again changes nothing.
    final again = await importText(csv);
    expect(again.created, 0);
    expect(again.duplicates, 3);
  });

  test('the CSV export is re-imported identically', () async {
    final series = env.repo
        .newSeries(CollectionType.bd)
        .copyWith(title: 'Naheulbeuk');
    await env.repo.saveSeries(series);
    final item = env.repo
        .newItem(CollectionType.bd, series: series, volumeNumber: '3')
        .copyWith(
          title: 'Naheulbeuk',
          volumeTitle: 'La Couette de l’oubli',
          authors: ['John Lang', 'Marion Poinsot'],
          ownership: Ownership.envie,
          readingStatus: ReadingStatus.enCours,
          purchaseDate: DateTime(2026, 2, 3),
          coverPrice: 14.5,
          notes: 'Dédicacé; "rare"',
        );
    await env.repo.saveItem(item);
    final csv = itemsToCsv([item], {series.id: series});

    final other = TestEnv();
    addTearDown(other.dispose);
    final rows = Csv.parse(csv);
    final report = await importCsvRows(
      other.repo,
      rows.skip(1).toList(),
      guessMapping(rows.first),
      (type: CollectionType.livre, ownership: Ownership.possede),
    );
    expect(report.created, 1);
    final copy = (await other.repo.listSeriesItems(
      (await other.repo.findSeries(CollectionType.bd, 'Naheulbeuk'))!.id,
    )).single;
    expect(copy.type, CollectionType.bd);
    expect(copy.volumeTitle, 'La Couette de l’oubli');
    expect(copy.authors, item.authors);
    expect(copy.ownership, Ownership.envie);
    expect(copy.readingStatus, ReadingStatus.enCours);
    expect(copy.purchaseDate, DateTime(2026, 2, 3));
    expect(copy.coverPrice, 14.5);
    expect(copy.notes, 'Dédicacé; "rare"');
  });

  test('two copies without ISBN of a volume are both imported', () async {
    // Editions of a volume, or a book bought twice: exported as two lines.
    const csv =
        'Série;Tome;Titre;ISBN\n'
        'One Piece;1;;\n'
        'One Piece;1;;\n'
        ';;Dune;\n'
        ';;Dune;\n';
    final report = await importText(csv);
    expect(report.created, 4);
    expect(report.duplicates, 0);

    // Running it again changes nothing.
    final again = await importText(csv);
    expect(again.created, 0);
    expect(again.duplicates, 4);
  });

  test('JSON backup restores everything, deletions included', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'X');
    await env.repo.saveSeries(series);
    await env.repo.addVolumeRange(series, from: 1, to: 3);
    final deleted = env.repo.newItem(CollectionType.livre).copyWith(title: 'Y');
    await env.repo.saveItem(deleted);
    await env.repo.deleteItem(deleted.id);
    final json = await JsonBackup(env.db).export(now: DateTime(2026, 11, 14));

    final other = TestEnv();
    addTearDown(other.dispose);
    expect(await JsonBackup(other.db).restore(json), 5);
    expect(await other.repo.listSeriesItems(series.id), hasLength(3));
    expect(await other.repo.getItem(deleted.id), isNull);
    // Restored rows will be pushed by the next sync.
    expect((await other.repo.getSeries(series.id))!.syncPending, isTrue);
    // A second restore changes nothing.
    expect(await JsonBackup(other.db).restore(json), 0);
    expect(
      () => JsonBackup(other.db).restore('{"hello": 1}'),
      throwsA(isA<BackupFormatException>()),
    );
  });
}
