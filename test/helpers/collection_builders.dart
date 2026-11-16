import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// Items and series built in memory for the suggestion tests.
final _at = DateTime.utc(2026, 11, 16);

Item item(
  String title, {
  List<String> authors = const [],
  String? seriesId,
  Ownership ownership = Ownership.possede,
  ReadingStatus reading = ReadingStatus.nonLu,
  int? rating,
  CollectionType type = CollectionType.bd,
}) => Item(
  id: '$title-${seriesId ?? ''}-${authors.join()}',
  createdAt: _at,
  updatedAt: _at,
  type: type,
  title: title,
  authors: authors,
  seriesId: seriesId,
  ownership: ownership,
  readingStatus: reading,
  rating: rating,
);

Series series(String id, String title, {CollectionType? type}) => Series(
  id: id,
  createdAt: _at,
  updatedAt: _at,
  type: type ?? CollectionType.manga,
  title: title,
);
