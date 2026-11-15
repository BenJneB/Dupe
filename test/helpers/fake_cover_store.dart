import 'dart:typed_data';

import 'package:dupe/features/covers/data/cover_photos.dart';

class FakeCoverStore implements CoverStore {
  final files = <String, Uint8List>{};
  int uploads = 0;

  @override
  Future<void> upload(String name, Uint8List bytes) async {
    uploads++;
    files[name] = bytes;
  }

  @override
  Future<Uint8List?> download(String name) async => files[name];
}
