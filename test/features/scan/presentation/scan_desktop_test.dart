import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';

void main() {
  testWidgets('desktop: a typed or USB-scanned unknown ISBN shows the online '
      'result with add buttons', (tester) async {
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources()],
    );

    await openScan(tester);
    await typeCode(tester, duneIsbn);

    expect(find.byKey(const Key('store_unknown')), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
    expect(find.byKey(const Key('addOwned')), findsOneWidget);
  }, variant: linux);

  testWidgets('a non-ISBN code shows an error and stays on the scan screen', (
    tester,
  ) async {
    await pumpApp(tester, size: desktopSize);

    await openScan(tester);
    await typeCode(tester, '1234');

    expect(find.text('Code « 1234 » non reconnu comme ISBN'), findsOneWidget);
    expect(find.byKey(const Key('codeEntryField')), findsOneWidget);
  }, variant: linux);
}
