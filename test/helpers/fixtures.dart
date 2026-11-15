import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';

final _epoch = DateTime.utc(2026);

Item testItem(
  String id, {
  String? volume,
  Ownership ownership = Ownership.possede,
  String? seriesId = 's1',
}) => Item(
  id: id,
  createdAt: _epoch,
  updatedAt: _epoch,
  type: CollectionType.manga,
  title: 'One Piece',
  seriesId: seriesId,
  volumeNumber: volume,
  ownership: ownership,
);
