import 'package:dupe/core/utils/db_enum.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_alert.freezed.dart';

/// What an alert is about (PLAN_V4 phase 33).
enum AlertKind implements DbEnum {
  /// A volume after the last one known of a followed series.
  serie('serie'),

  /// A new book of a followed author.
  auteur('auteur');

  new(this.dbValue);

  @override
  final String dbValue;
}

/// Handled on one device, gone on the others (synced).
enum AlertStatus implements DbEnum {
  nouveau('nouveau'),
  vu('vu'),
  ignore('ignore'),
  ajoute('ajoute');

  new(this.dbValue);

  @override
  final String dbValue;
}

/// A new release found in a source. Its id derives from [key], so the same
/// release found on two devices is one alert after sync.
@freezed
abstract class ReleaseAlert with _$ReleaseAlert {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// `series:<series id>:<number>` or `isbn:<isbn>`.
    required String key,
    required AlertKind kind,
    required CollectionType type,
    required String title,
    @Default(AlertStatus.nouveau) AlertStatus status,
    String? seriesId,
    String? volumeNumber,
    String? authorName,
    @Default(<String>[]) List<String> authors,
    String? isbn13,
    String? publisher,
    String? publishDate,
    String? coverUrl,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
  }) = _ReleaseAlert;
}

/// An author followed for new releases (from the author view), synced.
@freezed
abstract class FollowedAuthor with _$FollowedAuthor {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String name,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
  }) = _FollowedAuthor;
}
