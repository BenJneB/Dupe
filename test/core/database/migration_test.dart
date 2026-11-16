import 'package:drift_dev/api/migrations_native.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  const series =
      'INSERT INTO series (id, created_at, updated_at, type, title) '
      "VALUES ('s1', '2026-01-01T00:00:00.000Z', '2026-01-01T00:00:00.000Z', "
      "'manga', 'One Piece')";

  test('v1 -> v3 creates the local tables and keeps the collection', () async {
    final schema = await verifier.schemaAt(1);
    schema.rawDatabase.execute(series);
    final db = AppDatabase(schema.newConnection());

    await verifier.migrateAndValidate(db, 3);

    final rows = await db.select(db.seriesTable).getSingle();
    expect(rows.title, 'One Piece');
    expect(await db.select(db.scanQueueTable).get(), isEmpty);
    await db.close();
  });

  test('v2 -> v3 adds the volume title, items kept without one', () async {
    final schema = await verifier.schemaAt(2);
    schema.rawDatabase
      ..execute(series)
      ..execute(
        'INSERT INTO items (id, created_at, updated_at, series_id, type, '
        "title, volume_number) VALUES ('i1', '2026-01-01T00:00:00.000Z', "
        "'2026-01-01T00:00:00.000Z', 's1', 'manga', 'One Piece', '3')",
      );
    final db = AppDatabase(schema.newConnection());

    await verifier.migrateAndValidate(db, 3);

    final item = await db.select(db.itemsTable).getSingle();
    expect(
      (item.title, item.volumeNumber, item.volumeTitle),
      ('One Piece', '3', null),
    );
    await db.close();
  });
}
