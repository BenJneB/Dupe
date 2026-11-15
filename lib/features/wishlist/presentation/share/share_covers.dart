import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Loads the covers of [wishes] before the picture is captured (a picture
/// never waits for its images). A cover that cannot be loaded (offline,
/// photo not uploaded) is left out: the picture shows a plain vignette.
Future<Map<String, ImageProvider>> loadShareCovers(
  BuildContext context,
  WidgetRef ref,
  Iterable<Item> wishes,
) async {
  final photos = ref.read(coverPhotosProvider);
  final store = ref.read(coverStoreProvider);
  final loaded = <String, ImageProvider>{};

  Future<void> load(Item wish) async {
    final url = wish.coverUrl;
    if (url == null || url.isEmpty) return;
    ImageProvider? image;
    if (CoverPhotos.nameOf(url) case final name?) {
      try {
        final file = await ensureUserCover(photos, store, name);
        if (file != null) image = FileImage(file);
      } on Object {
        return;
      }
    } else {
      image = CachedNetworkImageProvider(url, cacheManager: coverCacheManager);
    }
    if (image == null || !context.mounted) return;
    var ok = true;
    await precacheImage(
      image,
      context,
      onError: (_, _) => ok = false,
    ).timeout(const Duration(seconds: 8), onTimeout: () => ok = false);
    if (ok) loaded[wish.id] = image;
  }

  await Future.wait(wishes.map(load));
  return loaded;
}
