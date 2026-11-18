import 'dart:io';

import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/scan_helpers.dart';
import '../../../../helpers/screen_helpers.dart';

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signed volume: form, sheet, photo, filter, mark, stats', (
    tester,
  ) async {
    final dir = (await tester.runAsync(
      () => Directory.systemTemp.createTemp('dupe_signed'),
    ))!;
    addTearDown(() => tester.runAsync(() => dir.delete(recursive: true)));
    late String id;
    final db = await pumpApp(
      tester,
      overrides: [
        coverPhotosProvider.overrideWithValue(CoverPhotos(() async => dir)),
        pickImageProvider.overrideWithValue(
          ({required camera}) async => (
            bytes: img.encodeJpg(img.Image(width: 80, height: 60)),
            extension: '.jpg',
          ),
        ),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        final blast = repo
            .newItem(CollectionType.bd)
            .copyWith(title: 'Blast', authors: ['Manu Larcenet']);
        id = blast.id;
        await repo.saveItem(blast);
        await repo.saveItem(
          repo.newItem(CollectionType.bd).copyWith(title: 'Unsigned'),
        );
      },
    );

    // Form: the box prefills the signer with the authors.
    await goTo(tester, AppRoutes.itemEdit(CollectionType.bd, id));
    await _scrollTo(tester, find.byKey(const Key('signedSwitch')));
    await tester.tap(find.byKey(const Key('signedSwitch')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Manu Larcenet'), findsWidgets);
    await _scrollTo(tester, find.widgetWithText(TextFormField, 'Lieu'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Lieu'),
      'Angoulême',
    );
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(
      () =>
          (db.select(db.itemsTable)..where((t) => t.id.equals(id))).getSingle(),
    );
    expect(
      (saved!.isSigned, saved.signedBy, saved.signedPlace),
      (true, 'Manu Larcenet', 'Angoulême'),
    );

    // Sheet: the signature and a photo of it.
    await goTo(tester, AppRoutes.item(CollectionType.bd, id));
    await _scrollTo(tester, find.byKey(const Key('signingSection')));
    expect(find.textContaining('Angoulême'), findsOneWidget);
    await tester.runAsync(() async {
      tester
          .widget<OutlinedButton>(find.byKey(const Key('addItemPhoto')))
          .onPressed!();
      await Future<void>.delayed(const Duration(seconds: 2));
    });
    await tester.pumpAndSettle();
    final photos = await tester.runAsync(
      () => db.select(db.itemPhotosTable).get(),
    );
    expect(photos!.single.itemId, id);
    expect(CoverPhotos.isUserCover(photos.single.url), isTrue);
    await _scrollTo(tester, find.byKey(const ValueKey('itemPhoto-0')));
    await tester.tap(find.byKey(const ValueKey('itemPhoto-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('photoViewer')), findsOneWidget);

    // Tab: pen on the signed book, "Dédicacés" filter.
    await goTo(tester, '/bd');
    expect(find.byKey(const Key('signedMark')), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Dédicacés'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Dédicacés'));
    await tester.pumpAndSettle();
    expect(find.text('Blast'), findsOneWidget);
    expect(find.text('Unsigned'), findsNothing);

    await goTo(tester, AppRoutes.stats);
    expect(find.byKey(const Key('statSigned')), findsOneWidget);
  });
}
