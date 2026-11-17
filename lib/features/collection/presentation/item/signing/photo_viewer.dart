import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/item_photo.dart';
import 'package:material_ui/material_ui.dart';

/// Full screen photos, swipe between them, pinch to zoom.
Future<void> showPhotos(
  BuildContext context,
  List<ItemPhoto> photos,
  int initial,
) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => _PhotoViewer(photos: photos, initial: initial),
  ),
);

class _PhotoViewer extends StatelessWidget {
  const new({required this.photos, required this.initial});

  final List<ItemPhoto> photos;
  final int initial;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: const Key('photoViewer'),
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    body: PageView(
      controller: PageController(initialPage: initial),
      children: [
        for (final p in photos)
          InteractiveViewer(
            maxScale: 6,
            child: LayoutBuilder(
              builder: (context, box) => Center(
                child: CoverImage(
                  url: p.url,
                  width: box.maxWidth,
                  height: box.maxHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
