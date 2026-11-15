import 'dart:io';
import 'dart:typed_data';

import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/screen_helpers.dart';

void main() {
  testWidgets('the camera button puts the photo on the item', (tester) async {
    final dir = (await tester.runAsync(
      () => Directory.systemTemp.createTemp('dupe_covers'),
    ))!;
    addTearDown(() => tester.runAsync(() => dir.delete(recursive: true)));
    bool? usedCamera;
    final db = await pumpApp(
      tester,
      overrides: [
        coverPhotosProvider.overrideWithValue(CoverPhotos(() async => dir)),
        pickImageProvider.overrideWithValue(({required camera}) async {
          usedCamera = camera;
          return (
            bytes: Uint8List.fromList([0xff, 0xd8, 0xff]),
            extension: '.jpg',
          );
        }),
      ],
    );
    await goTo(tester, AppRoutes.newItem(CollectionType.livre));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre'),
      'Livre introuvable',
    );
    // Pressed directly: the button sits in the lazily built part of the
    // form list, below the phone viewport.
    // Real async zone: the photo is written to disk.
    await tester.runAsync(() async {
      tester
          .widget<IconButton>(find.byKey(const Key('coverPhotoButton')))
          .onPressed!();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    // flutter_test simulates Android: the camera is used.
    expect(usedCamera, isTrue);
    final item = await tester.runAsync(
      () => db.select(db.itemsTable).getSingle(),
    );
    expect(CoverPhotos.isUserCover(item!.coverUrl), isTrue);
    final name = CoverPhotos.nameOf(item.coverUrl)!;
    expect(File('${dir.path}/$name').existsSync(), isTrue);
  });
}
