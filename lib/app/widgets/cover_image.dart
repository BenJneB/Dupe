import 'package:cached_network_image/cached_network_image.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/presentation/user_cover_image.dart';
import 'package:material_ui/material_ui.dart';

/// Cover thumbnail with a placeholder when missing or failing to load.
/// Downloaded covers are kept on disk (shown offline, in shops).
class CoverImage extends StatelessWidget {
  const new({required this.url, this.width = 48, this.height = 72, super.key});

  final String? url;
  final double width;
  final double height;

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
              )
            : CachedNetworkImage(
                imageUrl: value,
                fit: BoxFit.cover,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
