// Renders the logo to the launcher icon sources:
//   flutter test tool/render_icons_test.dart --update-goldens
//   dart run flutter_launcher_icons
import 'package:dupe/app/widgets/dupe_logo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> render(WidgetTester tester, Widget logo, String file) async {
  await tester.pumpWidget(Center(child: RepaintBoundary(child: logo)));
  await expectLater(
    find.byType(RepaintBoundary).first,
    matchesGoldenFile('../assets/icon/$file'),
  );
}

void main() {
  setUp(() {});

  testWidgets('render launcher icons', (tester) async {
    tester.view
      ..physicalSize = const Size(1024, 1024)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await render(tester, const DupeLogo(size: 1024), 'dupe_icon.png');
    // Android adaptive icon: drawing inside the 66 % safe zone.
    await render(
      tester,
      const DupeLogo(size: 1024, background: false, scale: 0.62),
      'dupe_foreground.png',
    );
  });
}
