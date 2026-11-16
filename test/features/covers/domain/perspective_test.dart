import 'package:dupe/features/covers/domain/perspective.dart';
import 'package:flutter_test/flutter_test.dart';

const Quad skewed = (
  topLeft: (x: 120, y: 80),
  topRight: (x: 860, y: 140),
  bottomRight: (x: 800, y: 1300),
  bottomLeft: (x: 60, y: 1180),
);

void main() {
  test('the homography maps the output corners onto the quad', () {
    final h = Homography.rectToQuad(skewed, 600, 900);
    void at(double x, double y, Pt expected) {
      final p = h.map(x, y);
      expect(p.x, closeTo(expected.x, 1e-6));
      expect(p.y, closeTo(expected.y, 1e-6));
    }

    at(0, 0, skewed.topLeft);
    at(599, 0, skewed.topRight);
    at(599, 899, skewed.bottomRight);
    at(0, 899, skewed.bottomLeft);
  });

  test('straight lines stay straight (true perspective)', () {
    // Trapezoid: the middle of the output maps onto the crossing of the
    // diagonals, not onto the average of the corners.
    const trapezoid = (
      topLeft: (x: 40.0, y: 0.0),
      topRight: (x: 60.0, y: 0.0),
      bottomRight: (x: 100.0, y: 100.0),
      bottomLeft: (x: 0.0, y: 100.0),
    );
    final h = Homography.rectToQuad(trapezoid, 101, 101);
    final centre = h.map(50, 50);
    expect(centre.x, closeTo(50, 1e-6));
    // The diagonals (40,0)-(100,100) and (60,0)-(0,100) cross at y = 100/6:
    // the far, narrow side. A bilinear blend would give 50.
    expect(centre.y, closeTo(100 / 6, 1e-6));
  });

  test('output size: longest sides, ratio preset, 1200 px at most', () {
    expect(outputSize(skewed), (width: 750, height: 1162));
    expect(outputSize(skewed, maxSide: 581), (width: 375, height: 581));
    final pocket = outputSize(skewed, aspect: CoverAspect.pocket);
    expect(pocket.height, 1162);
    expect(pocket.width / pocket.height, closeTo(11.5 / 18, 0.002));
    // Small crops are never enlarged.
    expect(outputSize(defaultQuad(100, 200)), (width: 80, height: 160));
  });

  test('a quarter turn moves the corners with the picture', () {
    final q = defaultQuad(1000, 500);
    final turned = rotateQuadClockwise(q, 500);
    // (100, 450) bottom left -> top left of the turned 500 × 1000 image.
    expect(turned.topLeft, (x: 50.0, y: 100.0));
    expect(turned.bottomRight, (x: 450.0, y: 900.0));
  });
}
