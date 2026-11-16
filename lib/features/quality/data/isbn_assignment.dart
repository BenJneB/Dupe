import 'dart:async';

import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// What checking a scanned ISBN for an item found (phase 22).
typedef IsbnCheck = ({
  /// Another live item already carries this ISBN.
  Item? duplicate,

  /// The online record, when the sources answered.
  MetadataResult? found,

  /// The record's titles fit the item (or nothing to compare).
  bool coherent,
});

/// The record [found] is plausibly [item]: one of its titles (title, series)
/// equals or contains one of the item's (title, own title, series title).
bool titlesFit(Item item, String? seriesTitle, MetadataResult found) {
  final mine = {
    item.title,
    ?item.volumeTitle,
    ?seriesTitle,
  }.map(normalizeTitle).where((t) => t.length >= 3);
  final theirs = {
    found.title,
    ?found.seriesTitle,
  }.map(normalizeTitle).where((t) => t.length >= 3);
  return mine.any(
    (a) => theirs.any((b) => a == b || a.contains(b) || b.contains(a)),
  );
}

/// Gives a scanned ISBN to an item that has none (the "ISBN mémorisé" of the
/// store mode, for a chosen item), with the checks of "Compléter par scan".
class IsbnAssignment {
  const new(this._repo, this._sources);

  final CollectionRepository _repo;
  final MetadataAggregator _sources;

  Future<IsbnCheck> check(
    Item item,
    String isbn13, {
    String? seriesTitle,
  }) async {
    final other = await _repo.findItemByIsbn(isbn13);
    final duplicate = other != null && other.id != item.id ? other : null;
    MetadataResult? found;
    try {
      found =
          (await _sources
                  .lookupIsbn(isbn13, item.type)
                  .timeout(const Duration(seconds: 8)))
              .merged;
    } on Object {
      found = null; // Offline or slow: no title check, the ISBN still counts.
    }
    return (
      duplicate: duplicate,
      found: found,
      coherent: found == null || titlesFit(item, seriesTitle, found),
    );
  }

  /// Saves [isbn13] on [item]; with [complete], also fills its empty fields
  /// from [found] (never what was typed).
  Future<Item> assign(
    Item item,
    String isbn13, {
    MetadataResult? found,
    bool complete = true,
    String? seriesTitle,
  }) async {
    final fresh = await _repo.getItem(item.id) ?? item;
    var updated = fresh.copyWith(isbn13: isbn13);
    if (complete && found != null) {
      updated = fillBlanks(
        updated,
        found,
        seriesTitle: seriesTitle ?? fresh.title,
      );
    }
    await _repo.saveItem(updated);
    return updated;
  }
}
