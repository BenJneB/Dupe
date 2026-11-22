import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

void main() {
  testWidgets('adding the last volume: "Série complète !"', (tester) async {
    late Series naruto;
    await pumpApp(
      tester,
      seed: (db) async {
        final repo = repoOf(db);
        naruto = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Naruto', totalVolumes: 3);
        await repo.saveSeries(naruto);
        for (final n in ['1', '2']) {
          await repo.saveItem(
            repo.newItem(CollectionType.manga, series: naruto, volumeNumber: n),
          );
        }
      },
    );
    await goTo(tester, AppRoutes.series(CollectionType.manga, naruto.id));
    // Not complete at start-up: nothing said.
    expect(find.textContaining('Série complète'), findsNothing);

    await tester.longPress(find.byKey(const ValueKey('slot-3')));
    await tester.pumpAndSettle();
    // After the "volume owned" message, in the same queue.
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();

    expect(find.text('Série complète : Naruto ! 🎉'), findsOneWidget);
  });
}
