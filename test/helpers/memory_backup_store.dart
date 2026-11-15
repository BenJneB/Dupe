import 'package:dupe/features/backup/data/backup_store.dart';

/// Automatic backups kept in memory.
class MemoryBackupStore implements BackupStore {
  final files = <String, String>{};

  @override
  Future<List<String>> names() async => files.keys.toList();
  @override
  Future<String> read(String name) async => files[name]!;
  @override
  Future<void> write(String name, String content) async =>
      files[name] = content;
  @override
  Future<void> delete(String name) async => files.remove(name);
}
