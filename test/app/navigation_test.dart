import 'package:dupe/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> pumpApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const ProviderScope(child: DupeApp()));
  await tester.pumpAndSettle();
}

void main() {
  group('mobile layout', () {
    const phone = Size(400, 800);

    testWidgets('shows bottom navigation with the five tabs', (tester) async {
      await pumpApp(tester, phone);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      for (final label in ['Mangas', 'BD', 'Comics', 'Livres', 'Plus']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('collectionTab-manga')), findsOneWidget);
    });

    testWidgets('switches between tabs', (tester) async {
      await pumpApp(tester, phone);

      await tester.tap(find.text('Comics'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('collectionTab-comic')), findsOneWidget);

      await tester.tap(find.text('Livres'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('collectionTab-livre')), findsOneWidget);
    });

    testWidgets('opens a "Plus" sub-screen', (tester) async {
      await pumpApp(tester, phone);

      await tester.tap(find.text('Plus'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Prêts'));
      await tester.pumpAndSettle();

      expect(find.text('Bientôt disponible'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('scan button opens the scan screen', (tester) async {
      await pumpApp(tester, phone);

      await tester.tap(find.byKey(const Key('scanFab')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Scanner'), findsOneWidget);
      // Scan screen is full screen, above the navigation shell.
      expect(find.byType(NavigationBar), findsNothing);
    });
  });

  group('desktop layout', () {
    testWidgets('uses a navigation rail on wide screens', (tester) async {
      await pumpApp(tester, const Size(1280, 800));

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byKey(const Key('scanFab')), findsOneWidget);

      await tester.tap(find.text('BD'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('collectionTab-bd')), findsOneWidget);
    });
  });
}
