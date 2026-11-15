import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

/// Display helpers shared by the list and grid views.
String entryRoute(CollectionType type, CollectionEntry entry) =>
    switch (entry) {
      SeriesEntry(:final series) => AppRoutes.series(type, series.id),
      ItemEntry(:final item) => AppRoutes.item(type, item.id),
    };

String entrySubtitle(AppLocalizations l10n, CollectionEntry entry) =>
    switch (entry) {
      SeriesEntry(:final series, :final ownedCount, :final unreadCount) => [
        if (series.totalVolumes case final total?)
          l10n.volumesOwnedOfTotal(ownedCount, total)
        else
          l10n.volumesOwned(ownedCount),
        if (ownedCount > 0 && unreadCount == 0) l10n.allRead,
      ].join(' · '),
      ItemEntry(:final item) =>
        item.ownership == Ownership.envie
            ? l10n.ownershipWished
            : [
                if (item.authors.isNotEmpty) item.authors.join(', '),
                if (item.readingStatus == ReadingStatus.lu)
                  ReadingStatus.lu.label(l10n),
              ].join(' · '),
    };

String? entryCover(CollectionEntry entry) => switch (entry) {
  SeriesEntry(:final series, :final firstVolumeCover) =>
    (series.coverUrl ?? '').isEmpty ? firstVolumeCover : series.coverUrl,
  ItemEntry(:final item) => item.coverUrl,
};
