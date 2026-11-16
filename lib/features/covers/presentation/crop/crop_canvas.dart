import 'dart:typed_data';

import 'package:dupe/features/covers/domain/perspective.dart';
import 'package:material_ui/material_ui.dart';

/// The photo with its four movable corners (phase 29): pinch to zoom, drag a
/// corner to move it, a loupe under the finger for precision.
class CropCanvas extends StatefulWidget {
  const new({
    required this.photo,
    required this.width,
    required this.height,
    required this.corners,
    required this.onChanged,
    super.key,
  });

  final Uint8List photo;
  final int width;
  final int height;

  /// Top left, top right, bottom right, bottom left, in photo pixels.
  final List<Pt> corners;
  final ValueChanged<List<Pt>> onChanged;

  @override
  State<CropCanvas> createState() => _CropCanvasState();
}

class _CropCanvasState extends State<CropCanvas> {
  final _zoom = TransformationController();

  /// Finger position (in this widget) while a corner moves.
  Offset? _finger;

  @override
  void dispose() {
    _zoom.dispose();
    super.dispose();
  }

  void _move(int index, DragUpdateDetails d, double fit) {
    final scale = fit * _zoom.value.getMaxScaleOnAxis();
    final c = widget.corners[index];
    final moved = (
      x: (c.x + d.delta.dx / scale).clamp(0.0, widget.width - 1.0),
      y: (c.y + d.delta.dy / scale).clamp(0.0, widget.height - 1.0),
    );
    widget.onChanged([...widget.corners]..[index] = moved);
    _showLoupe(d.globalPosition);
  }

  void _showLoupe(Offset? global) {
    final box = context.findRenderObject() as RenderBox?;
    setState(
      () => _finger = global == null ? null : box?.globalToLocal(global),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fit = [
          constraints.maxWidth / widget.width,
          constraints.maxHeight / widget.height,
        ].reduce((a, b) => a < b ? a : b);
        final size = Size(widget.width * fit, widget.height * fit);
        return Stack(
          children: [
            Center(
              child: InteractiveViewer(
                transformationController: _zoom,
                maxScale: 6,
                child: SizedBox.fromSize(
                  size: size,
                  child: ListenableBuilder(
                    listenable: _zoom,
                    builder: (context, _) => _picture(size, fit, scheme),
                  ),
                ),
              ),
            ),
            if (_finger case final f?) _loupe(f, scheme),
          ],
        );
      },
    );
  }

  Widget _picture(Size size, double fit, ColorScheme scheme) {
    // Handles keep the same size on screen whatever the zoom.
    final r = 24 / _zoom.value.getMaxScaleOnAxis();
    final points = [
      for (final c in widget.corners) Offset(c.x * fit, c.y * fit),
    ];
    return Stack(
      children: [
        Positioned.fill(
          child: Image.memory(
            widget.photo,
            fit: BoxFit.fill,
            gaplessPlayback: true,
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _QuadPainter(points, scheme.primary, r / 12),
          ),
        ),
        for (final (i, p) in points.indexed)
          Positioned(
            left: p.dx - r,
            top: p.dy - r,
            width: 2 * r,
            height: 2 * r,
            child: GestureDetector(
              key: ValueKey('cropCorner-$i'),
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => _showLoupe(d.globalPosition),
              onPanUpdate: (d) => _move(i, d, fit),
              onPanEnd: (_) => _showLoupe(null),
              onPanCancel: () => _showLoupe(null),
              child: Center(
                child: Container(
                  width: r,
                  height: r,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.primary, width: r / 8),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _loupe(Offset finger, ColorScheme scheme) {
    const side = 110.0;
    const gap = 90.0;
    // Above the finger, below it near the top of the screen.
    final above = finger.dy > side + gap;
    final dy = above ? -gap : gap;
    return Positioned(
      left: finger.dx - side / 2,
      top: finger.dy + dy - side / 2,
      child: IgnorePointer(
        child: RawMagnifier(
          size: const Size.square(side),
          magnificationScale: 2.5,
          focalPointOffset: Offset(0, -dy),
          decoration: MagnifierDecoration(
            shape: CircleBorder(
              side: BorderSide(color: scheme.primary, width: 2),
            ),
          ),
          child: Center(
            child: Icon(Icons.add, size: 18, color: scheme.primary),
          ),
        ),
      ),
    );
  }
}

/// Dims the photo outside the cover and outlines it.
class _QuadPainter extends CustomPainter {
  const new(this.points, this.color, this.stroke);

  final List<Offset> points;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final quad = Path()..addPolygon(points, true);
    final outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addPath(quad, Offset.zero);
    canvas
      ..drawPath(outside, Paint()..color = const Color(0x88000000))
      ..drawPath(
        quad,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke * 2,
      );
  }

  @override
  bool shouldRepaint(_QuadPainter old) =>
      old.points != points || old.color != color || old.stroke != stroke;
}
