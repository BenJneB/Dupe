import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/utils/db_enum.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_queue_entry.freezed.dart';

enum ScanStatus implements DbEnum {
  /// Waiting for the background lookup.
  pending('pending'),

  /// Metadata found ([ScanQueueEntry.result]).
  found('found'),

  /// Every source answered, none knows the ISBN.
  notFound('not_found'),

  /// Sources unreachable (offline…): to retry.
  failed('failed');

  new(this.dbValue);

  @override
  final String dbValue;
}

/// One ISBN scanned in burst mode.
@freezed
abstract class ScanQueueEntry with _$ScanQueueEntry {
  const factory({
    required String id,
    required String isbn13,
    required CollectionType type,
    required DateTime scannedAt,
    @Default(ScanStatus.pending) ScanStatus status,
    MetadataResult? result,
  }) = _ScanQueueEntry;
}
