import 'package:cached_network_image/cached_network_image.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/presentation/user_cover_image.dart';
import 'package:material_ui/material_ui.dart';

/// Cover thumbnail with a placeholder when missing or failing to load.
/// Downloaded covers are kept on disk ([coverCacheManager]: shown offline,
/// in shops).
class CoverImage extends StatelessWidget {
  const new({
    required this.url,
    this.width = 48,
    this.height = 72,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? url;
  final double width;
  final double height;

  /// Contain for a full screen photo.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.menu_book_outlined,
          color: scheme.outline,
          size: width / 2,
        ),
      ),
    );
    final value = url;
    // Decoded at the displayed size, not the full resolution.
    final cacheHeight = height.isFinite
        ? (height * MediaQuery.devicePixelRatioOf(context)).round()
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: width,
        height: height,
        child: value == null || value.isEmpty
            ? placeholder
            : CoverPhotos.isUserCover(value)
            ? UserCoverImage(
                name: CoverPhotos.nameOf(value)!,
                placeholder: placeholder,
                fit: fit,
                cacheHeight: cacheHeight,
              )
            : CachedNetworkImage(
                imageUrl: value,
                cacheManager: coverCacheManager,
                memCacheHeight: cacheHeight,
                fit: fit,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
