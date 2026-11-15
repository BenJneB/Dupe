import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_file_io.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

/// Dune (book, priority 1) and One Piece 3 (manga, priority 2, max 6.50).
Future<void> seedShare(AppDatabase db) async {
  final repo = repoOf(db);
  final onePiece = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'One Piece');
  await repo.saveSeries(onePiece);
  await repo.saveItem(
    repo
        .newItem(CollectionType.manga, series: onePiece, volumeNumber: '3')
        .copyWith(
          ownership: Ownership.envie,
          wishlistPriority: 2,
          wishlistMaxPrice: 6.5,
        ),
  );
  await repo.saveItem(
    repo
        .newItem(CollectionType.livre)
        .copyWith(
          title: 'Dune',
          ownership: Ownership.envie,
          wishlistPriority: 1,
        ),
  );
}

void main() {
  testWidgets('filters, then shares the text and the picture', (tester) async {
    final files = FakeFileIo();
    await pumpApp(
      tester,
      seed: seedShare,
      overrides: [fileIoProvider.overrideWithValue(files)],
    );
    await goTo(tester, AppRoutes.wishlist);
    await tester.tap(find.byKey(const Key('shareWishlist')));
    await tester.pumpAndSettle();
    expect(find.textContaining('2 envies'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sharePriority_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shareText')));
    await tester.pumpAndSettle();
    expect(files.sharedTexts.last, 'Ma liste d’envies (1)\n\nLivres\n• Dune');

    await tester.tap(find.byKey(const Key('sharePriority_null')));
    await tester.tap(find.byKey(const Key('shareType_manga')));
    await tester.tap(find.byKey(const Key('sharePriceSwitch')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Prix max : 6,50'), findsOneWidget);
    await tester.tap(find.byKey(const Key('shareText')));
    await tester.pumpAndSettle();
    expect(
      files.sharedTexts.last,
      'Ma liste d’envies (1)\n\nMangas\n'
      '• One Piece – tome 3 (Prix max : 6,50\u00a0€)',
    );

    await tester.tap(find.byKey(const Key('shareImage')));
    await tester.runAsync(() async {
      for (var i = 0; i < 100 && files.saved.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();
    final png = files.saved['envies.png'];
    expect(png, isNotNull);
    expect(png!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
  });

  testWidgets('no matching wish: nothing to share', (tester) async {
    await pumpApp(tester, seed: seedShare);
    await goTo(tester, AppRoutes.wishlistShare);
    await tester.tap(find.byKey(const Key('sharePriority_1')));
    await tester.tap(find.byKey(const Key('shareType_manga')));
    await tester.pumpAndSettle();
    expect(
      find.text('Aucune envie ne correspond aux filtres.'),
      findsOneWidget,
    );
  });
}
