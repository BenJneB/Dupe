import 'package:dupe/features/collection/domain/series.dart';

/// Which series the item form files a book in.
sealed class SeriesAttachment {
  const new();

  /// The current link is kept: no series, or one not synced yet.
  static const SeriesAttachment none = KeepSeries();

  /// "Aucune série" chosen by the user: the book leaves its series.
  static const SeriesAttachment detached = DetachSeries();
}

/// Unchanged: the book stays where it is (in no series, or in a series
/// this device does not know yet).
final class KeepSeries extends SeriesAttachment {
  const new();
}

/// Matched, current or chosen existing series.
final class AttachToSeries extends SeriesAttachment {
  const new(this.series);

  final Series series;
}

/// New series named [title], created on save while [enabled]; switched
/// off, the book goes into no series.
final class CreateSeries extends SeriesAttachment {
  const new(this.title, {this.enabled = true});

  final String title;
  final bool enabled;
}

/// Out of any series.
final class DetachSeries extends SeriesAttachment {
  const new();
}
