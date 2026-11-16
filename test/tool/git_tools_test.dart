@TestOn('linux || mac-os')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Phase 18 scripts: commit message check (lefthook) and release notes.
void main() {
  final root = Directory.current.path;

  Future<ProcessResult> checkMessage(
    String message, {
    Map<String, String>? environment,
  }) async {
    final dir = await Directory.systemTemp.createTemp('dupe_msg');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/COMMIT_EDITMSG')..writeAsStringSync(message);
    return await Process.run('$root/tool/check_commit_msg.sh', [
      file.path,
    ], environment: environment);
  }

  test('length in characters, even in the C locale (accents)', () async {
    final message = 'fix: ${'é' * 90}'; // 95 characters, 185 bytes.
    final result = await checkMessage(
      message,
      environment: {'LC_ALL': 'C', 'LANG': 'C'},
    );
    expect(result.exitCode, 0, reason: result.stderr as String);
  });

  test('conventional commit messages are accepted, others refused', () async {
    for (final ok in [
      'feat: lampe torche',
      'fix(sync): lignes commitées en retard',
      'chore(deps): bump dio from 5.11.1 to 5.12.0',
      'refactor!: nouveau format de sauvegarde',
      '# comment from git\n\ndocs: README\n\nbody',
      'Merge branch "dev"',
      'fixup! feat: lampe torche',
    ]) {
      expect((await checkMessage(ok)).exitCode, 0, reason: ok);
    }
    for (final bad in [
      'Phase 18',
      'feat:pas d’espace',
      'feature: type inconnu',
      'Feat: majuscule',
      'fix(Scan): portée en majuscule',
      'feat: ${'x' * 100}',
      '',
    ]) {
      final result = await checkMessage(bad);
      expect(result.exitCode, 1, reason: bad);
      expect(result.stderr as String, contains('refusé'));
    }
  });

  test(
    'release notes group the commits since the previous stable tag',
    () async {
      final repo = await Directory.systemTemp.createTemp('dupe_repo');
      addTearDown(() => repo.delete(recursive: true));
      Future<void> git(List<String> args) async {
        final r = await Process.run('git', args, workingDirectory: repo.path);
        if (r.exitCode != 0) throw StateError('git $args: ${r.stderr}');
      }

      Future<void> commit(String message) =>
          git(['commit', '--allow-empty', '-q', '-m', message]);

      await git(['init', '-q', '-b', 'main']);
      await git(['config', 'user.email', 'test@example.test']);
      await git(['config', 'user.name', 'Test']);
      await commit('feat: première fonction');
      await git(['tag', 'v0.1.0']);
      await commit('fix(sync): perte de lignes');
      await git(['tag', 'v0.1.1-test']); // pre-release: not a base
      await commit('feat(scan)!: nouveau scan');
      await commit('chore(deps): bump dio');
      await commit('Phase 18');
      await git(['tag', 'v0.2.0']);

      Future<String> notes(String tag) async {
        final r = await Process.run('$root/tool/ci/release_notes.sh', [
          tag,
        ], workingDirectory: repo.path);
        expect(r.exitCode, 0, reason: '${r.stderr}');
        return r.stdout as String;
      }

      expect(
        await notes('v0.2.0'),
        '## Changements depuis v0.1.0\n'
        '\n### Nouveautés\n\n- ⚠️ **scan** : nouveau scan\n'
        '\n### Corrections\n\n- **sync** : perte de lignes\n'
        '\n### Maintenance\n\n- **deps** : bump dio\n'
        '\n### Autres changements\n\n- Phase 18\n',
      );
      expect(
        await notes('v0.1.0'),
        '## Première version\n\n### Nouveautés\n\n- première fonction\n',
      );
    },
  );
}
