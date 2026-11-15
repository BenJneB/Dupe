import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// flutter_test defaults to Android, which shows the camera instead of the
/// code field.
final linux = TargetPlatformVariant.only(TargetPlatform.linux);

var _id = 0;

/// Repository for seeding a test database.
CollectionRepository repoOf(AppDatabase db) =>
    CollectionRepository(db, now: DateTime.now, newId: () => 'seed-${_id++}');

Future<void> openScan(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('scanFab')));
  await tester.pumpAndSettle();
}

/// Types [code] then Enter, as a USB barcode reader does.
Future<void> typeCode(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const Key('codeEntryField')), code);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}
