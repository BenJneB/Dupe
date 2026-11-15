import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:dupe/core/utils/db_enum.dart';

/// Stores a [DbEnum] as its stable text value.
class DbEnumConverter<T extends DbEnum> extends TypeConverter<T, String> {
  const new(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) => values.firstWhere((v) => v.dbValue == fromDb);

  @override
  String toSql(T value) => value.dbValue;
}

/// Stores a list of strings as a JSON array.
class StringListConverter extends TypeConverter<List<String>, String> {
  const new();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// Stores a string map as a JSON object.
class StringMapConverter extends TypeConverter<Map<String, String>, String> {
  const new();

  @override
  Map<String, String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as Map<String, dynamic>).cast<String, String>();

  @override
  String toSql(Map<String, String> value) => jsonEncode(value);
}
