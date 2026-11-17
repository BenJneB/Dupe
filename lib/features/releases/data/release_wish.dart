import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/item_drafts.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';

enum WishOutcome { added, alreadyThere, failed }

/// Adds the release of [alert] to the wishlist (in its series when it has
/// one, created or matched otherwise) and marks it added. Nothing is created
/// when its ISBN is already in the collection.
Future<WishOutcome> addAlertToWishes(
  CollectionRepository repo,
  ReleasesRepository alerts,
  ReleaseAlert alert,
) async {
  final isbn = alert.isbn13;
  if (isbn != null && await repo.findItemByIsbn(isbn) != null) {
    await alerts.setStatus(alert, AlertStatus.ajoute);
    return WishOutcome.alreadyThere;
  }
  final metadata = MetadataResult(
    source: MetadataSource.bnf,
    sourceId: alert.key,
    title: alert.title,
    seriesTitle: alert.volumeNumber == null ? null : alert.title,
    volumeNumber: alert.volumeNumber,
    authors: alert.authors,
    isbn13: alert.isbn13,
    publisher: alert.publisher,
    publishDate: alert.publishDate,
    coverUrl: alert.coverUrl,
  );
  final draft = await loadItemDraft(
    repo,
    type: alert.type,
    seriesId: alert.seriesId,
    volumeNumber: alert.volumeNumber,
    prefill: (metadata: metadata, ownership: Ownership.envie),
  );
  // Its series was deleted meanwhile.
  if (draft == null) return WishOutcome.failed;
  final item = await applyAttachment(repo, draft.item, draft.attachment);
  await repo.saveItem(item);
  await alerts.setStatus(alert, AlertStatus.ajoute);
  return WishOutcome.added;
}
