import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';

/// Series catalog answering from memory (nothing by default).
class FakeSeriesCatalogSource implements SeriesCatalogSource {
  new({this.byTitle = const {}, this.available = true});

  final Map<String, List<MetadataResult>> byTitle;
  @override
  final bool available;
  final calls = <String>[];

  @override
  Future<List<MetadataResult>> volumesOf(String seriesTitle) async {
    calls.add(seriesTitle);
    return byTitle[seriesTitle] ?? const [];
  }
}
