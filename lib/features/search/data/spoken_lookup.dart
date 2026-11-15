import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:dupe/features/search/data/search_repository.dart';
import 'package:dupe/features/search/domain/spoken_query.dart';

/// What a dictated search points to (PLAN_V3 phase 19).
sealed class SpokenLookup {
  const new();
}

/// The volume is in the collection (owned copy first, else wished).
final class SpokenVolumeFound extends SpokenLookup {
  const new(this.item);
  final Item item;
}

/// The series is in the collection, this volume is not.
final class SpokenVolumeMissing extends SpokenLookup {
  const new(this.series, this.volume);
  final Series series;
  final String volume;
}

/// No volume said, or no such series: an ordinary search for [text].
final class SpokenText extends SpokenLookup {
  const new(this.text);
  final String text;
}

/// Finds the series (exact title first, accents and case ignored) and the
/// volume of a [SpokenQuery].
Future<SpokenLookup> lookUpSpoken(
  SearchRepository search,
  CollectionRepository collection,
  SpokenQuery query,
) async {
  final volume = query.volume;
  if (volume == null) return SpokenText(query.text);
  final found = (await search.search(query.text)).series;
  final wanted = foldForSearch(query.text);
  final series =
      found.where((s) => foldForSearch(s.title) == wanted).firstOrNull ??
      found.firstOrNull;
  if (series == null) return SpokenText(query.text);
  final copies =
      (await collection.listSeriesItems(series.id))
          .where((i) => _sameVolume(i.volumeNumber, volume))
          .toList()
        ..sort(
          (a, b) => (a.ownership == Ownership.possede ? 0 : 1).compareTo(
            b.ownership == Ownership.possede ? 0 : 1,
          ),
        );
  return copies.isEmpty
      ? SpokenVolumeMissing(series, volume)
      : SpokenVolumeFound(copies.first);
}

bool _sameVolume(String? stored, String spoken) {
  final n = VolumeNumber.asInt(stored);
  return n != null ? '$n' == spoken : stored?.trim() == spoken;
}
