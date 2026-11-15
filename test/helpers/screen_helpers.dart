import 'package:dupe/app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Navigation and form helpers shared by the widget tests.

ProviderContainer containerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

/// Goes to [route] (an `AppRoutes` path) and waits for the screen.
Future<void> goTo(WidgetTester tester, String route) async {
  containerOf(tester).read(appRouterProvider).go(route);
  await tester.pumpAndSettle();
}

Future<void> openSettings(WidgetTester tester) =>
    goTo(tester, AppRoutes.settings);

/// Taps the tile [key] of a long list (settings). A tile may be built in the
/// list cache yet still off screen: scroll to it, then make it visible.
Future<void> tapTile(WidgetTester tester, String key) async {
  final tile = find.byKey(Key(key));
  await tester.scrollUntilVisible(
    tile,
    200,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
}

/// Fills the sign-in / sign-up form and submits it.
Future<void> fillSignIn(
  WidgetTester tester,
  String email,
  String password, {
  String? confirm,
}) async {
  Finder field(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(TextField),
  );
  await tester.enterText(find.byKey(const Key('emailField')), email);
  await tester.enterText(field('passwordField'), password);
  if (confirm != null) {
    await tester.enterText(field('passwordConfirmField'), confirm);
  }
  await tester.pump();
  await tester.tap(find.byKey(const Key('submitButton')));
  await tester.pumpAndSettle();
}
