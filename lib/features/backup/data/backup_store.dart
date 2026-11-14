import 'dart:io';

import 'package:path/path.dart' as p;

/// Where automatic backups are kept (a folder of the app; memory in tests).
abstract interface class BackupStore {
  Future<List<String>> names();
  Future<String> read(String name);
  Future<void> write(String name, String content);
  Future<void> delete(String name);
}

class DirectoryBackupStore implements BackupStore {
  const new(this._directory);

  final Future<Directory> Function() _directory;

  Future<File> _file(String name) async =>
      File(p.join((await _directory()).path, name));

  @override
  Future<List<String>> names() async {
    final dir = await _directory();
    if (!dir.existsSync()) return const [];
    return [
      await for (final f in dir.list())
        if (f is File) p.basename(f.path),
    ];
  }

  @override
  Future<String> read(String name) async =>
      await (await _file(name)).readAsString();

  @override
  Future<void> write(String name, String content) async {
    final file = await _file(name);
    await file.parent.create(recursive: true);
    // Written then renamed: a crash never leaves a truncated backup.
    final partial = File('${file.path}.part');
    await partial.writeAsString(content, flush: true);
    await partial.rename(file.path);
  }

  @override
  Future<void> delete(String name) async {
    final file = await _file(name);
    if (file.existsSync()) await file.delete();
  }
}
