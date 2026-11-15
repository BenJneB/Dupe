import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

/// Display helpers shared by the list and grid views.
String entryRoute(CollectionType type, CollectionEntry entry) =>
    switch (entry) {
      SeriesEntry(:final series) => AppRoutes.series(type, series.id),
      ItemEntry(:final item) => AppRoutes.item(type, item.id),
    };

String entrySubtitle(AppLocalizations l10n, CollectionEntry entry) =>
    switch (entry) {
      SeriesEntry(:final series, :final ownedCount) =>
        series.totalVolumes == null
            ? l10n.volumesOwned(ownedCount)
            : l10n.volumesOwnedOfTotal(ownedCount, series.totalVolumes!),
      ItemEntry(:final item) =>
        item.ownership == Ownership.envie
            ? l10n.ownershipWished
            : item.authors.join(', '),
    };

String? entryCover(CollectionEntry entry) => switch (entry) {
  SeriesEntry(:final series) => series.coverUrl,
  ItemEntry(:final item) => item.coverUrl,
};
