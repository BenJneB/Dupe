import 'package:material_ui/material_ui.dart';

/// The Dupe logo: three book spines on a shelf and a green "owned" check
/// (the store-mode verdict). Drawn in code; `tool/render_icons.dart` renders
/// it to the launcher icon PNGs.
class DupeLogo extends StatelessWidget {
  const new({
    this.size = 64,
    this.background = true,
    this.scale = 1,
    super.key,
  });

  final double size;

  /// Rounded indigo square behind the drawing (false: transparent, for the
  /// Android adaptive icon foreground).
  final bool background;

  /// Size of the drawing relative to [size] (adaptive icon safe zone).
  final double scale;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _LogoPainter(background, scale)),
  );
}

class _LogoPainter extends CustomPainter {
  const new(this.background, this.scale);

  final bool background;
  final double scale;

  static const indigo = Color(0xFF3F51B5);
  static const green = Color(0xFF1B7A3A);
  static const spines = [
    Color(0xFFFFD666),
    Color(0xFFFFFFFF),
    Color(0xFF81C7FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 1024;
    if (background) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(220 * unit),
        ),
        Paint()..color = indigo,
      );
    }
    canvas
      ..save()
      ..translate(size.width * (1 - scale) / 2, size.height * (1 - scale) / 2)
      ..scale(unit * scale);
    final fill = Paint();
    // Shelf.
    canvas.drawRRect(
      RRect.fromLTRBR(200, 760, 824, 800, const Radius.circular(20)),
      fill..color = const Color(0xE6FFFFFF),
    );
    // Spines with two bands each.
    const bounds = [
      (230.0, 380.0, 300.0),
      (400.0, 540.0, 250.0),
      (560.0, 690.0, 330.0),
    ];
    for (final (i, (x0, x1, top)) in bounds.indexed) {
      canvas.drawRRect(
        RRect.fromLTRBR(x0, top, x1, 750, const Radius.circular(28)),
        fill..color = spines[i],
      );
      for (final y in [top + 70, 650.0]) {
        canvas.drawRect(
          Rect.fromLTRB(x0, y, x1, y + 26),
          fill..color = indigo.withValues(alpha: 0.45),
        );
      }
    }
    // Check badge, ringed with the background colour.
    const center = Offset(700, 330);
    canvas
      ..drawCircle(center, 168, fill..color = indigo)
      ..drawCircle(center, 150, fill..color = green)
      ..drawPath(
        Path()
          ..moveTo(center.dx - 70, center.dy + 5)
          ..lineTo(center.dx - 15, center.dy + 60)
          ..lineTo(center.dx + 80, center.dy - 55),
        Paint()
          ..color = const Color(0xFFFFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 44
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.background != background || old.scale != scale;
}
