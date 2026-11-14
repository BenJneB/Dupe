/// Enum persisted with a stable textual value (shared by SQLite and Postgres).
abstract interface class DbEnum {
  String get dbValue;
}
