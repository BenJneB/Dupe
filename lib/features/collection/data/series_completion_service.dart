import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/bnf_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_completion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'series_completion_service.g.dart';

/// Where the volumes of a whole series come from (the BnF). Faked in tests
/// (`pumpApp`).
abstract interface class SeriesCatalogSource {
  /// False when the BnF is turned off in the settings.
  bool get available;

  Future<List<MetadataResult>> volumesOf(String seriesTitle);
}

class BnfSeriesCatalogSource implements SeriesCatalogSource {
  const new(this._bnf);

  final BnfProvider? _bnf;

  @override
  bool get available => _bnf != null;

  @override
  Future<List<MetadataResult>> volumesOf(String seriesTitle) async =>
      await _bnf?.searchSeriesVolumes(seriesTitle) ?? const [];
}

@Riverpod(keepAlive: true)
SeriesCatalogSource seriesCatalogSource(Ref ref) =>
    BnfSeriesCatalogSource(ref.watch(bnfSourceProvider));

/// Applies [chosen] to [series] (created when null, titled [title]) in one
/// transaction; returns the series and the counts.
Future<({Series series, int updated, int created})> completeSeries(
  CollectionRepository repo, {
  required CollectionType type,
  required String title,
  required Series? series,
  required Map<int, ({MetadataResult record, VolumeChoice choice})> chosen,
}) => repo.inTransaction(() async {
  final first = chosen.values.firstOrNull?.record;
  final target =
      series ??
      repo
          .newSeries(type)
          .copyWith(
            title: title,
            publisher: first?.publisher,
            authors: first?.authors ?? const [],
          );
  final plan = planCompletion(
    existing: series == null ? const [] : await repo.listSeriesItems(series.id),
    chosen: chosen,
    seriesTitle: target.title,
    newItem: (n) => repo.newItem(type, series: target, volumeNumber: '$n'),
  );
  if (series == null && plan.creates.isNotEmpty) await repo.saveSeries(target);
  for (final item in [...plan.updates, ...plan.creates]) {
    await repo.saveItem(item);
  }
  return (
    series: target,
    updated: plan.updates.length,
    created: plan.creates.length,
  );
});
