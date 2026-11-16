import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_riverpod/misc.dart';

/// Repository whose item (and optionally series) writes fail, like SQLite
/// running out of disk midway.
class FailingRepository extends CollectionRepository {
  new(
    super._db, {
    required super.now,
    required super.newId,
    this.failSeries = false,
  });

  final bool failSeries;

  @override
  Future<void> saveItem(Item item) async => throw StateError('disk full');

  @override
  Future<void> saveSeries(Series series) async {
    if (failSeries) throw StateError('disk full');
    await super.saveSeries(series);
  }
}

/// [collectionRepositoryProvider] replaced by a [FailingRepository].
Override failingRepository({bool failSeries = false}) =>
    collectionRepositoryProvider.overrideWith(
      (ref) => FailingRepository(
        ref.watch(appDatabaseProvider),
        now: ref.watch(clockProvider),
        newId: ref.watch(idGeneratorProvider),
        failSeries: failSeries,
      ),
    );
