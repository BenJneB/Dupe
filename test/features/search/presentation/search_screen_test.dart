import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';

Future<void> seedDune(AppDatabase db) async {
  final repo = repoOf(db);
  await repo.saveItem(
    repo
        .newItem(CollectionType.livre)
        .copyWith(title: 'Dune', isbn13: '9782266320481'),
  );
}

void main() {
  testWidgets('a book found by part of its ISBN shows the ISBN', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedDune);
    await tester.tap(find.byKey(const Key('globalSearchBar')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('searchField')), '32048');
    await tester.pumpAndSettle();

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Livres · Possédé · 9782266320481'), findsOneWidget);
  });
}
