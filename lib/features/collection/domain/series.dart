import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'series.freezed.dart';

/// A series (manga, BD, comic) or a book cycle.
@freezed
abstract class Series with _$Series {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required CollectionType type,
    required String title,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
    String? originalTitle,
    @Default(<String>[]) List<String> authors,
    String? publisher,
    String? collection,
    @Default(PublicationStatus.inconnue) PublicationStatus statusPublication,
    int? totalVolumes,
    String? coverUrl,
    String? description,
    @Default(<String, String>{}) Map<String, String> externalIds,
    @Default(true) bool followed,
    String? notes,
  }) = _Series;
}
