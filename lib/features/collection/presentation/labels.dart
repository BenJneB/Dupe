import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

/// French labels for domain enums.
extension CollectionTypeLabel on CollectionType {
  String label(AppLocalizations l10n) => switch (this) {
    CollectionType.manga => l10n.tabMangas,
    CollectionType.bd => l10n.tabBd,
    CollectionType.comic => l10n.tabComics,
    CollectionType.livre => l10n.tabBooks,
  };

  /// "Nouvelle série" or "Nouveau cycle" for books.
  String newSeriesLabel(AppLocalizations l10n) =>
      this == CollectionType.livre ? l10n.newCycle : l10n.newSeries;

  String newItemLabel(AppLocalizations l10n) =>
      this == CollectionType.livre ? l10n.newBook : l10n.newOneShot;
}

extension PublicationStatusLabel on PublicationStatus {
  String label(AppLocalizations l10n) => switch (this) {
    PublicationStatus.enCours => l10n.publicationOngoing,
    PublicationStatus.terminee => l10n.publicationFinished,
    PublicationStatus.inconnue => l10n.publicationUnknown,
  };
}

extension OwnershipLabel on Ownership {
  String label(AppLocalizations l10n) => switch (this) {
    Ownership.possede => l10n.ownershipOwned,
    Ownership.envie => l10n.ownershipWished,
  };
}

extension ReadingStatusLabel on ReadingStatus {
  String label(AppLocalizations l10n) => switch (this) {
    ReadingStatus.nonLu => l10n.readingUnread,
    ReadingStatus.enCours => l10n.readingInProgress,
    ReadingStatus.lu => l10n.readingRead,
    ReadingStatus.abandonne => l10n.readingAbandoned,
  };
}

extension VolumeSlotStatusLabel on VolumeSlotStatus {
  String label(AppLocalizations l10n) => switch (this) {
    VolumeSlotStatus.owned => l10n.slotOwned,
    VolumeSlotStatus.loaned => l10n.slotLoaned,
    VolumeSlotStatus.wished => l10n.slotWished,
    VolumeSlotStatus.missing => l10n.slotMissing,
  };
}

extension CollectionSortLabel on CollectionSort {
  String label(AppLocalizations l10n) => switch (this) {
    CollectionSort.title => l10n.sortTitle,
    CollectionSort.recent => l10n.sortRecent,
    CollectionSort.progress => l10n.sortProgress,
  };
}

extension CompletionFilterLabel on CompletionFilter {
  String label(AppLocalizations l10n) => switch (this) {
    CompletionFilter.all => l10n.filterAll,
    CompletionFilter.complete => l10n.filterComplete,
    CompletionFilter.incomplete => l10n.filterIncomplete,
  };
}
