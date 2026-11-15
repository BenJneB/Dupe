import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_http.dart';
import '../../../helpers/screen_helpers.dart';

void main() {
  testWidgets('a Comic Vine key is tested, saved, and turns the source on', (
    tester,
  ) async {
    final http = FakeHttpAdapter()
      ..on(
        (u) => u.queryParameters['api_key'] == 'wrong-key-000',
        fixture('comic_vine/invalid_key.json'),
        status: 401,
      )
      ..on((_) => true, fixture('comic_vine/search_volume_batman.json'));
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [httpClientProvider.overrideWithValue(fakeDio(http))],
    );
    await openSettings(tester);
    final source = find.byKey(const Key('source_comicVine'));
    await tester.scrollUntilVisible(
      source,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(tester.widget<SwitchListTile>(source).onChanged, isNull);
    expect(
      find.descendant(
        of: source,
        matching: find.text('Clé requise : saisis-la ci-dessous'),
      ),
      findsOneWidget,
    );

    await tapTile(tester, 'apiKey_comicVine');
    final field = find.descendant(
      of: find.byKey(const Key('apiKeyField')),
      matching: find.byType(TextField),
    );
    Future<void> test(String key) async {
      await tester.enterText(field, key);
      await tester.pump();
      await tester.tap(find.byKey(const Key('apiKeyTest')));
      // The request runs in simulated time (dio's own timers).
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await test('wrong-key-000');
    expect(find.textContaining('Clé refusée'), findsOneWidget);
    await test('good-key-123456');
    expect(find.text('Clé valide'), findsOneWidget);

    await tester.tap(find.byKey(const Key('apiKeySave')));
    await tester.pumpAndSettle();
    expect(find.text('Clé enregistrée'), findsOneWidget);
    expect(find.text('Clé saisie dans l’appli'), findsOneWidget);
    expect(tester.widget<SwitchListTile>(source).value, isTrue);
  });
}
