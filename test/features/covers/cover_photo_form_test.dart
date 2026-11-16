import 'dart:io';
import 'dart:typed_data';

import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/features/covers/data/cover_scanner.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_covers.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

/// A small real photo, with EXIF (like a phone camera).
Uint8List _photo() {
  final image = img.Image(width: 300, height: 400);
  img.fill(image, color: img.ColorRgb8(200, 30, 30));
  image.exif.imageIfd.make = 'PhoneMaker';
  return img.encodeJpg(image);
}

/// Presses [key] directly (the button may sit below the viewport, in the
/// lazily built part of the form), then lets the isolates and the disk
/// work in real time.
Future<void> _press(WidgetTester tester, Key key) async {
  await tester.runAsync(() async {
    tester.widget<IconButton>(find.byKey(key)).onPressed!();
    await Future<void>.delayed(const Duration(milliseconds: 800));
  });
  await tester.pumpAndSettle();
}

Future<Directory> _tempDir(WidgetTester tester) async {
  final dir = (await tester.runAsync(
    () => Directory.systemTemp.createTemp('dupe_covers'),
  ))!;
  addTearDown(() => tester.runAsync(() => dir.delete(recursive: true)));
  return dir;
}

Future<AppDatabase> _pump(
  WidgetTester tester,
  Directory dir, {
  CoverScanner? scanner,
  void Function()? onPick,
  Future<void> Function(AppDatabase)? seed,
}) => pumpApp(
  tester,
  seed: seed,
  coverScanner: scanner,
  overrides: <Override>[
    coverPhotosProvider.overrideWithValue(CoverPhotos(() async => dir)),
    pickImageProvider.overrideWithValue(({required camera}) async {
      expect(camera, isTrue, reason: 'flutter_test simulates Android');
      onPick?.call();
      return (bytes: _photo(), extension: '.jpg');
    }),
  ],
);

Future<String?> _savedCover(WidgetTester tester, AppDatabase db) async {
  await tester.tap(find.byKey(const Key('saveButton')));
  await tester.pumpAndSettle();
  final item = await tester.runAsync(
    () => db.select(db.itemsTable).getSingle(),
  );
  return item!.coverUrl;
}

void main() {
  testWidgets('no scanner: the photo goes through the crop editor', (
    tester,
  ) async {
    final dir = await _tempDir(tester);
    var picks = 0;
    final db = await _pump(tester, dir, onPick: () => picks++);
    await goTo(tester, AppRoutes.newItem(CollectionType.livre));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre'),
      'Livre introuvable',
    );

    await _press(tester, const Key('coverPhotoButton'));
    expect(picks, 1);
    expect(find.text('Recadrer'), findsOneWidget);
    expect(find.byKey(const ValueKey('cropCorner-0')), findsOneWidget);
    await _press(tester, const Key('cropDone'));
    expect(find.text('Recadrer'), findsNothing);

    final url = await _savedCover(tester, db);
    expect(CoverPhotos.isUserCover(url), isTrue);
    final saved = File('${dir.path}/${CoverPhotos.nameOf(url)}');
    final cover = img.decodeJpg(saved.readAsBytesSync())!;
    // Default frame: the photo minus 10 % on each side, no EXIF.
    expect((cover.width, cover.height), (240, 320));
    expect(cover.exif.isEmpty, isTrue);
    // The uncropped original stays on this device.
    expect(Directory('${dir.path}/originals').listSync(), hasLength(1));
  });

  testWidgets('the document scanner gives the cover directly', (tester) async {
    final dir = await _tempDir(tester);
    final scanner = FakeCoverScanner(available: true, result: _photo());
    var picks = 0;
    final db = await _pump(
      tester,
      dir,
      scanner: scanner,
      onPick: () => picks++,
    );
    await goTo(tester, AppRoutes.newItem(CollectionType.livre));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre'),
      'Livre scanné',
    );

    await _press(tester, const Key('coverPhotoButton'));
    expect((scanner.scans, picks), (1, 0));
    expect(find.text('Recadrer'), findsNothing);

    final url = await _savedCover(tester, db);
    final saved = File('${dir.path}/${CoverPhotos.nameOf(url)}');
    expect(img.decodeJpg(saved.readAsBytesSync())!.exif.isEmpty, isTrue);
  });

  testWidgets('an existing photo can be cropped again', (tester) async {
    final dir = await _tempDir(tester);
    await tester.runAsync(
      () => File('${dir.path}/old.jpg').writeAsBytes(_photo()),
    );
    late String id;
    final db = await _pump(
      tester,
      dir,
      seed: (db) async {
        final repo = repoOf(db);
        final item = repo
            .newItem(CollectionType.livre)
            .copyWith(title: 'Photo', coverUrl: 'dupe-cover:old.jpg');
        id = item.id;
        await repo.saveItem(item);
      },
    );
    await goTo(tester, AppRoutes.itemEdit(CollectionType.livre, id));

    await _press(tester, const Key('coverRecropButton'));
    expect(find.text('Recadrer'), findsOneWidget);
    await _press(tester, const Key('cropRotate'));
    await _press(tester, const Key('cropDone'));

    final url = await _savedCover(tester, db);
    expect(url, isNot('dupe-cover:old.jpg'));
    final cover = img.decodeJpg(
      File('${dir.path}/${CoverPhotos.nameOf(url)}').readAsBytesSync(),
    )!;
    // Turned a quarter: landscape now.
    expect((cover.width, cover.height), (320, 240));
  });
}
