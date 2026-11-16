import 'package:dupe/core/utils/isbn.dart';
import 'package:dupe/features/backup/data/csv_codec.dart';
import 'package:dupe/features/backup/domain/import_field.dart';
import 'package:dupe/features/backup/domain/import_values.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';

typedef ImportDefaults = ({CollectionType type, Ownership ownership});

class ImportReport {
  int created = 0;
  int seriesCreated = 0;

  /// Already in the collection (same ISBN, same series volume, same book).
  int duplicates = 0;

  /// Line numbers (1 = header) without a title.
  final invalidLines = <int>[];
}

/// Imports CSV [rows] (header excluded) with the column [mapping]. Series
/// are found by type + title, or created. Existing items are skipped, so an
/// import can be run again safely. All or nothing: one transaction.
Future<ImportReport> importCsvRows(
  CollectionRepository repo,
  List<List<String>> rows,
  Map<ImportField, int?> mapping,
  ImportDefaults defaults,
) => repo.inTransaction(() => _importRows(repo, rows, mapping, defaults));

Future<ImportReport> _importRows(
  CollectionRepository repo,
  List<List<String>> rows,
  Map<ImportField, int?> mapping,
  ImportDefaults defaults,
) async {
  final report = ImportReport();
  final seriesCache = <String, Series>{};
  final volumesCache = <String, List<Item>>{};

  for (final (index, row) in rows.indexed) {
    if (Csv.isBlank(row)) continue;
    String? get(ImportField f) {
      final i = mapping[f];
      if (i == null || i >= row.length) return null;
      final v = row[i].trim();
      return v.isEmpty ? null : v;
    }

    final type = ImportValues.type(get(ImportField.type)) ?? defaults.type;
    final seriesTitle = get(ImportField.series);
    final title = get(ImportField.title) ?? seriesTitle;
    if (title == null) {
      report.invalidLines.add(index + 2);
      continue;
    }
    final authors = ImportValues.people(get(ImportField.authors));
    final publisher = get(ImportField.publisher);
    final volume = get(ImportField.volume);
    final rawIsbn = get(ImportField.isbn);
    final isbn = rawIsbn == null ? null : Isbn.toIsbn13(rawIsbn);

    Series? series;
    if (seriesTitle != null) {
      final key = '${type.dbValue}|$seriesTitle';
      series = seriesCache[key] ??= await () async {
        final existing = await repo.findSeries(type, seriesTitle);
        if (existing != null) return existing;
        final created = repo
            .newSeries(type)
            .copyWith(
              title: seriesTitle,
              authors: authors,
              publisher: publisher,
            );
        await repo.saveSeries(created);
        report.seriesCreated++;
        return created;
      }();
    }

    if (await _isDuplicate(
      repo,
      volumesCache,
      type,
      series,
      title,
      volume,
      isbn,
    )) {
      report.duplicates++;
      continue;
    }
    final reading = ImportValues.reading(get(ImportField.readingStatus));
    final item = repo
        .newItem(type, series: series, volumeNumber: volume)
        .copyWith(
          title: title,
          volumeTitle: get(ImportField.volumeTitle),
          authors: authors,
          publisher: publisher,
          isbn13: isbn,
          ownership:
              ImportValues.ownership(get(ImportField.ownership)) ??
              defaults.ownership,
          readingStatus: reading ?? ReadingStatus.nonLu,
          purchasePrice: ImportValues.price(get(ImportField.purchasePrice)),
          purchaseDate: ImportValues.date(get(ImportField.purchaseDate)),
          coverPrice: ImportValues.price(get(ImportField.coverPrice)),
          location: get(ImportField.location),
          notes: get(ImportField.notes),
          source: 'csv',
        );
    await repo.saveItem(item);
    if (series != null) volumesCache[series.id]?.add(item);
    report.created++;
  }
  return report;
}

Future<bool> _isDuplicate(
  CollectionRepository repo,
  Map<String, List<Item>> volumesCache,
  CollectionType type,
  Series? series,
  String title,
  String? volume,
  String? isbn,
) async {
  if (isbn != null && await repo.findItemByIsbn(isbn) != null) return true;
  if (series == null) {
    return isbn == null && await repo.findStandaloneItem(type, title) != null;
  }
  final items = volumesCache[series.id] ??= await repo.listSeriesItems(
    series.id,
  );
  // Same volume (or same unnumbered title). Another copy with a different
  // ISBN is a new edition, not a duplicate.
  return items.any(
    (i) =>
        (volume == null
            ? i.volumeNumber == null && i.title == title
            : i.volumeNumber?.trim() == volume) &&
        (isbn == null || i.isbn13 == null || i.isbn13 == isbn),
  );
}
