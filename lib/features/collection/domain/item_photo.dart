import 'package:dupe/features/collection/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_photo.freezed.dart';

/// A photo of an item besides its cover (a signature, a page…), synced; the
/// file goes through the cover photo pipeline (`dupe-cover:` url, private
/// bucket).
@freezed
abstract class ItemPhoto with _$ItemPhoto {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String itemId,
    required String url,
    @Default(PhotoKind.dedicace) PhotoKind kind,
    @Default(0) int position,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
  }) = _ItemPhoto;
}
