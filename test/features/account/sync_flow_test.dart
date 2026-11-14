import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/sync/sync_engine.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_sync_auth.dart';
import '../../helpers/fake_sync_remote.dart';
import '../../helpers/scan_helpers.dart';

ProviderContainer containerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

Future<void> openSettings(WidgetTester tester) async {
  containerOf(tester).read(appRouterProvider).go(AppRoutes.settings);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sign in with a code: the local collection is uploaded', (
    tester,
  ) async {
    final remote = FakeSyncRemote();
    final auth = FakeSyncAuth();
    await pumpApp(
      tester,
      overrides: [
        syncAuthProvider.overrideWithValue(auth),
        syncRemoteProvider.overrideWithValue(remote),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo.newItem(CollectionType.livre).copyWith(title: 'Dune'),
        );
      },
    );
    await openSettings(tester);

    await tester.tap(find.byKey(const Key('signInTile')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'moi@exemple.be',
    );
    await tester.tap(find.byKey(const Key('sendCodeButton')));
    await tester.pumpAndSettle();
    expect(auth.sentTo, ['moi@exemple.be']);

    await tester.enterText(find.byKey(const Key('codeField')), '000000');
    await tester.tap(find.byKey(const Key('verifyCodeButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signInError')), findsOneWidget);

    // The default Supabase email only has a link: it is pasted.
    await tester.enterText(
      find.byKey(const Key('codeField')),
      'https://x.supabase.co/auth/v1/verify'
      '?token=${FakeSyncAuth.validLinkToken}&type=signup&redirect_to=x',
    );
    await tester.tap(find.byKey(const Key('verifyCodeButton')));
    await tester.pumpAndSettle();

    expect(find.text('Connecté : moi@exemple.be'), findsOneWidget);
    expect(find.textContaining('Synchronisé à'), findsOneWidget);
    expect(remote.tables['items']!.values.single['title'], 'Dune');
    // Discreet status in the search bar of the tabs.
    containerOf(tester)
        .read(appRouterProvider)
        .go(AppRoutes.base(CollectionType.manga));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('syncStatus')), findsOneWidget);
  });

  testWidgets('a local change is pushed a few seconds later; a change from '
      'the other device shows up within a minute', (tester) async {
    final remote = FakeSyncRemote();
    final db = await pumpApp(
      tester,
      overrides: [
        syncAuthProvider.overrideWithValue(
          FakeSyncAuth(signedInAs: 'moi@exemple.be'),
        ),
        syncRemoteProvider.overrideWithValue(remote),
      ],
    );
    await tester.pumpAndSettle();

    // Local change: pushed after the debounce delay.
    final repo = containerOf(tester).read(collectionRepositoryProvider);
    await tester.runAsync(
      () => repo.saveItem(
        repo.newItem(CollectionType.livre).copyWith(title: 'Dune'),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(remote.tables['items']!.values.map((r) => r['title']), ['Dune']);

    // The other device (phone) adds a book.
    await tester.runAsync(() async {
      final phone = AppDatabase.memory();
      final phoneRepo = CollectionRepository(
        phone,
        now: DateTime.now,
        newId: const Uuid().v7,
      );
      await phoneRepo.saveItem(
        phoneRepo.newItem(CollectionType.livre).copyWith(title: 'Fondation'),
      );
      await SyncEngine(
        phone,
        remote,
        AppSettingsStore(phone),
      ).sync(FakeSyncAuth.id);
      await phone.close();
    });
    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();

    final titles = await tester.runAsync(
      () async => (await db.select(db.itemsTable).get()).map((i) => i.title),
    );
    expect(titles, containsAll(['Dune', 'Fondation']));
    containerOf(tester)
        .read(appRouterProvider)
        .go(AppRoutes.base(CollectionType.livre));
    await tester.pumpAndSettle();
    expect(find.text('Fondation'), findsOneWidget);
  });
}
