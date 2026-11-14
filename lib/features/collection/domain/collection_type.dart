import 'package:dupe/core/utils/db_enum.dart';

/// Kind of work in the collection; drives tabs, metadata providers and UI.
enum CollectionType implements DbEnum {
  manga('manga'),
  bd('bd'),
  comic('comic'),
  livre('livre');

  new(this.dbValue);

  @override
  final String dbValue;
}
