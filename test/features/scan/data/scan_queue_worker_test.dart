import 'dart:io';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/data/scan_queue_worker.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_metadata.dart';

const _isbn = '9782811646745';

MetadataResult _google({String? volume}) => MetadataResult(
  source: MetadataSource.googleBooks,
  sourceId: 'g',
  title: 'Everdark',
  volumeNumber: volume,
);

Future<ScanStatus> _statusAfterLookup({
  required MetadataResult google,
  required bool bnfFails,
}) async {
  final db = AppDatabase.memory();
  addTearDown(db.close);
  var id = 0;
  final queue = ScanQueueRepository(
    db,
    now: DateTime.now,
    newId: () => '${id++}',
  );
  final worker = ScanQueueWorker(
    queue,
    MetadataAggregator(
      providers: [
        FakeProvider(
          MetadataSource.bnf,
          error: bnfFails ? const SocketException('timeout') : null,
        ),
        FakeProvider(MetadataSource.googleBooks, isbnResult: google),
      ],
    ),
  );
  await queue.enqueue(_isbn, CollectionType.manga);
  await worker.run();
  return (await queue.watchQueue().first).single.status;
}

void main() {
  test('BnF failed and no series nor number: retried, not imported '
      'outside the series (Everdark)', () async {
    expect(
      await _statusAfterLookup(google: _google(), bnfFails: true),
      ScanStatus.failed,
    );
  });

  test('BnF failed but the volume number is known: found', () async {
    expect(
      await _statusAfterLookup(google: _google(volume: '3'), bnfFails: true),
      ScanStatus.found,
    );
  });

  test('every source answered: a standalone book is found', () async {
    expect(
      await _statusAfterLookup(google: _google(), bnfFails: false),
      ScanStatus.found,
    );
  });
}
