import 'package:dupe/features/collection/domain/series.dart';

/// How a new item from an online result relates to a series.
class SeriesAttachment {
  const new({this.series, this.newSeriesTitle, this.createNew = true});

  /// No series involved (standalone book, manual entry).
  static const none = SeriesAttachment(createNew: false);

  /// Existing series the volume was matched to.
  final Series? series;

  /// Series to create when none matched (numbered volume).
  final String? newSeriesTitle;

  /// Whether to create [newSeriesTitle] on save (user can opt out).
  final bool createNew;

  SeriesAttachment withCreateNew(bool value) => SeriesAttachment(
    series: series,
    newSeriesTitle: newSeriesTitle,
    createNew: value,
  );
}
