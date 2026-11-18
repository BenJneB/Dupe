import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_completion.dart';
import 'package:flutter_test/flutter_test.dart';

final _at = DateTime.utc(2026, 11, 17);

Item volume(String n, {String? isbn, String? publisher}) => Item(
  id: 'v$n',
  createdAt: _at,
  updatedAt: _at,
  type: CollectionType.manga,
  title: 'Everdark',
  seriesId: 's',
  volumeNumber: n,
  isbn13: isbn,
  publisher: publisher,
);

MetadataResult record(int n) => MetadataResult(
  source: MetadataSource.bnf,
  sourceId: 'r$n',
  title: 'Everdark',
  seriesTitle: 'Everdark',
  volumeNumber: '$n',
  isbn13: '97828116000$n',
  publisher: 'Pika édition',
);

void main() {
  test('completes, creates, never duplicates nor overwrites', () {
    final existing = [
      volume('1', publisher: 'Pika (typed)'),
      volume('2', isbn: '9782811637699'),
    ];
    final plan = planCompletion(
      existing: existing,
      chosen: {
        1: (record: record(1), choice: VolumeChoice.owned),
        2: (record: record(2), choice: VolumeChoice.owned),
        3: (record: record(3), choice: VolumeChoice.wish),
        4: (record: record(4), choice: VolumeChoice.skip),
      },
      seriesTitle: 'Everdark',
      newItem: (n) => volume('$n').copyWith(id: 'new$n', title: ''),
    );

    // Volume 1 gets its ISBN; the typed publisher is kept.
    expect(plan.updates.single.id, 'v1');
    expect(plan.updates.single.isbn13, '978281160001');
    expect(plan.updates.single.publisher, 'Pika (typed)');
    // Volume 2 already has an ISBN; 4 is skipped; 3 is a new wish.
    final created = plan.creates.single;
    expect(
      (created.id, created.volumeNumber, created.ownership, created.isbn13),
      ('new3', '3', Ownership.envie, '978281160003'),
    );
  });

  test('volume states', () {
    final existing = [volume('1'), volume('2', isbn: 'x')];
    expect([1, 2, 3].map((n) => volumeState(existing, n)), [
      VolumeState.missingIsbn,
      VolumeState.complete,
      VolumeState.absent,
    ]);
  });
}
