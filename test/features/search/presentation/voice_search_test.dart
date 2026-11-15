import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_voice_input.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

/// One Piece, volumes 1 and 2 owned.
Future<void> seedOnePiece(AppDatabase db) async {
  final repo = repoOf(db);
  final series = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'One Piece');
  await repo.saveSeries(series);
  await repo.addVolumeRange(series, from: 1, to: 2);
}

Future<void> dictate(WidgetTester tester, {bool explain = true}) async {
  await tester.tap(find.byKey(const Key('voiceSearchBar')));
  await tester.pumpAndSettle();
  if (explain) {
    expect(find.text('Recherche vocale'), findsOneWidget);
    await tester.tap(find.byKey(const Key('voiceExplainOk')));
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('« One Piece tome deux » opens that volume; the microphone is '
      'explained only once', (tester) async {
    final voice = FakeVoiceInput(
      phrases: ['One Piece tome deux', 'one piece tome 107'],
    );
    await pumpApp(tester, voice: voice, seed: seedOnePiece);

    await dictate(tester);
    // Item screen of volume 2.
    expect(find.text('One Piece – tome 2'), findsWidgets);
    expect(find.byKey(const Key('lendButton')), findsOneWidget);

    await goTo(tester, AppRoutes.base(CollectionType.manga));
    await dictate(tester, explain: false);
    expect(
      find.text('Tome 107 de One Piece : absent de ta collection'),
      findsOneWidget,
    );
    expect(voice.listens, 2);
  });

  testWidgets('a phrase without a known volume is a normal search', (
    tester,
  ) async {
    await pumpApp(
      tester,
      voice: FakeVoiceInput(phrases: ['One Piece']),
      seed: seedOnePiece,
    );
    await dictate(tester);
    final field = tester.widget<TextField>(
      find.byKey(const Key('searchField')),
    );
    expect(field.controller!.text, 'One Piece');
    expect(find.text('Séries'), findsOneWidget);
  });

  testWidgets('cancelling the explanation does not listen; nothing heard is '
      'said', (tester) async {
    final voice = FakeVoiceInput(phrases: [null]);
    await pumpApp(tester, voice: voice);
    await tester.tap(find.byKey(const Key('voiceSearchBar')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(voice.listens, 0);

    await tester.tap(find.byKey(const Key('voiceSearch')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('voiceExplainOk')));
    await tester.pumpAndSettle();
    expect(find.textContaining('rien entendu'), findsOneWidget);
  });

  testWidgets('no microphone button where dictation is not available', (
    tester,
  ) async {
    await pumpApp(tester, voice: FakeVoiceInput(supported: false));
    expect(find.byKey(const Key('voiceSearchBar')), findsNothing);
  });
}
