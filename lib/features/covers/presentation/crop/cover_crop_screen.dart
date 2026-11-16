import 'dart:typed_data';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/features/covers/data/cover_processing.dart';
import 'package:dupe/features/covers/domain/perspective.dart';
import 'package:dupe/features/covers/presentation/crop/cover_aspect_label.dart';
import 'package:dupe/features/covers/presentation/crop/crop_canvas.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The straightened cover and the photo it comes from (kept to crop again).
typedef CropResult = ({Uint8List cover, Uint8List original});

/// Opens the editor on [photo]; null when the user leaves without saving.
Future<CropResult?> cropCover(BuildContext context, EditablePhoto photo) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CoverCropScreen(photo: photo),
      ),
    );

/// Manual editor (all platforms): four corners, quarter turns, ratio presets.
class CoverCropScreen extends StatefulWidget {
  const new({required this.photo, super.key});

  final EditablePhoto photo;

  @override
  State<CoverCropScreen> createState() => _CoverCropScreenState();
}

class _CoverCropScreenState extends State<CoverCropScreen> {
  late EditablePhoto _photo = widget.photo;
  late Quad _quad = defaultQuad(_photo.width, _photo.height);
  CoverAspect _aspect = CoverAspect.free;
  bool _busy = false;

  List<Pt> get _corners => [
    _quad.topLeft,
    _quad.topRight,
    _quad.bottomRight,
    _quad.bottomLeft,
  ];

  set _corners(List<Pt> c) => _quad = (
    topLeft: c[0],
    topRight: c[1],
    bottomRight: c[2],
    bottomLeft: c[3],
  );

  Future<void> _run(Future<void> Function() work) async {
    setState(() => _busy = true);
    try {
      await work();
    } on Object catch (e, stack) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.coverPhotoError(reportError(l10n, 'crop', e, stack)),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _rotate() => _run(() async {
    final turned = await CoverProcessing.rotate(_photo.bytes);
    final quad = rotateQuadClockwise(_quad, _photo.height);
    setState(() {
      _photo = turned;
      _quad = quad;
    });
  });

  Future<void> _done() => _run(() async {
    final cover = await CoverProcessing.crop(
      _photo.bytes,
      _quad,
      aspect: _aspect,
    );
    if (mounted) {
      Navigator.of(context)
          .pop<CropResult>((cover: cover, original: _photo.bytes));
    }
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cropTitle),
        actions: [
          IconButton(
            key: const Key('cropRotate'),
            tooltip: l10n.cropRotate,
            icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
            onPressed: _busy ? null : _rotate,
          ),
          IconButton(
            key: const Key('cropReset'),
            tooltip: l10n.cropReset,
            icon: const Icon(Icons.crop_free),
            onPressed: _busy
                ? null
                : () => setState(
                    () => _quad = defaultQuad(_photo.width, _photo.height),
                  ),
          ),
          IconButton(
            key: const Key('cropDone'),
            tooltip: l10n.cropDone,
            icon: const Icon(Icons.check),
            onPressed: _busy ? null : _done,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_busy) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                l10n.cropHelp,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CropCanvas(
                  photo: _photo.bytes,
                  width: _photo.width,
                  height: _photo.height,
                  corners: _corners,
                  onChanged: (c) => setState(() => _corners = c),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final aspect in CoverAspect.values)
                    ChoiceChip(
                      key: ValueKey('cropAspect-${aspect.name}'),
                      label: Text(aspect.label(l10n)),
                      selected: _aspect == aspect,
                      onSelected: (_) => setState(() => _aspect = aspect),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
