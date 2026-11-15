import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';

/// flutter_test defaults to Android, which shows the camera instead.
final linux = TargetPlatformVariant.only(TargetPlatform.linux);

void main() {
  testWidgets('desktop: typed or USB-scanned ISBN opens the lookup', (
    tester,
  ) async {
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources()],
    );

    await tester.tap(find.byKey(const Key('scanFab')));
    await tester.pumpAndSettle();
    // A USB reader types the digits then Enter.
    await tester.enterText(find.byKey(const Key('codeEntryField')), duneIsbn);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isbnResultTitle')), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
  }, variant: linux);

  testWidgets('a non-ISBN code shows an error and stays on the scan screen', (
    tester,
  ) async {
    await pumpApp(tester, size: desktopSize);

    await tester.tap(find.byKey(const Key('scanFab')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('codeEntryField')), '1234');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Code « 1234 » non reconnu comme ISBN'), findsOneWidget);
    expect(find.byKey(const Key('codeEntryField')), findsOneWidget);
  }, variant: linux);
}
