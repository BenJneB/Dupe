import 'package:dupe/app/router.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';

void main() {
  testWidgets('sources can be turned off; keyless ones are greyed out', (
    tester,
  ) async {
    await pumpApp(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    container.read(appRouterProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();

    final bnf = find.byKey(const Key('source_bnf'));
    await tester.scrollUntilVisible(bnf, 100);
    // Built in the list cache, maybe below the screen: scroll it into view.
    await tester.ensureVisible(bnf);
    await tester.pumpAndSettle();
    await tester.tap(bnf);
    await tester.pumpAndSettle();
    expect(await container.read(disabledSourcesProvider.future), {
      SourceId.bnf,
    });

    // Tests run without env.json: no Comic Vine key.
    final comicVine = find.byKey(const Key('source_comicVine'));
    await tester.scrollUntilVisible(comicVine, 100);
    expect(tester.widget<SwitchListTile>(comicVine).onChanged, isNull);
    expect(find.text('Clé API absente de env.json'), findsWidgets);
  });
}
