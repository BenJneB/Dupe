import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

void main() {
  group('mobile layout', () {
    testWidgets('shows bottom navigation with the five tabs', (tester) async {
      await pumpApp(tester);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      for (final label in ['Mangas', 'BD', 'Comics', 'Livres', 'Plus']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('collectionTab-manga')), findsOneWidget);
    });

    testWidgets('switches between tabs', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Comics'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('collectionTab-comic')), findsOneWidget);

      await tester.tap(find.text('Livres'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('collectionTab-livre')), findsOneWidget);
    });

    testWidgets('opens a "Plus" sub-screen', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Plus'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Prêts'));
      await tester.pumpAndSettle();

      expect(find.text('Aucun prêt en cours'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('scan button opens the scan screen', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byKey(const Key('scanFab')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Scanner'), findsOneWidget);
      // Scan screen is full screen, above the navigation shell.
      expect(find.byType(NavigationBar), findsNothing);
    });
  });

  group('desktop layout', () {
    testWidgets('uses a navigation rail on wide screens', (tester) async {
      await pumpApp(tester, size: desktopSize);

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byKey(const Key('scanFab')), findsOneWidget);

      await tester.tap(find.text('BD'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('collectionTab-bd')), findsOneWidget);
    });
  });
}
