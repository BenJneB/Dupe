import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

/// A volume, an issue or a standalone book.
@freezed
abstract class Item with _$Item {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required CollectionType type,
    required String title,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
    String? seriesId,
    String? volumeNumber,

    /// The volume's own title (« Les renforts maléfiques »), when the sources
    /// give one besides the series title (PLAN_V4 phase 24).
    String? volumeTitle,
    String? isbn13,
    String? upc,
    @Default(<String>[]) List<String> authors,
    String? publisher,
    String? edition,
    String? format,
    String? publishDate,
    int? pageCount,
    String? language,
    String? coverUrl,
    String? description,
    @Default(Ownership.possede) Ownership ownership,
    @Default(ReadingStatus.nonLu) ReadingStatus readingStatus,
    DateTime? readDate,
    int? rating,
    @Default(false) bool isFirstEdition,
    @Default(false) bool isVariant,
    String? condition,
    double? purchasePrice,
    DateTime? purchaseDate,
    double? coverPrice,
    double? estimatedValue,
    @Default('EUR') String currency,
    int? wishlistPriority,
    double? wishlistMaxPrice,
    String? location,
    String? notes,
    String? source,
    String? sourceId,

    /// Signed copy (PLAN_V4 phase 31): who, when, where, what was written.
    @Default(false) bool isSigned,
    String? signedBy,
    DateTime? signedOn,
    String? signedPlace,
    String? signingNote,
  }) = _Item;
}
