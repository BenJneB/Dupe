import 'dart:math' as math;

/// A point in image pixels.
typedef Pt = ({double x, double y});

/// The four corners of the cover in the photo, clockwise from top left.
typedef Quad = ({Pt topLeft, Pt topRight, Pt bottomRight, Pt bottomLeft});

/// Width / height ratio presets of the cropped cover (phase 29).
enum CoverAspect {
  /// Ratio measured on the corners.
  free(null),

  /// Manga and paperback (about 11.5 × 18 cm).
  pocket(11.5 / 18),

  /// Franco-Belgian album (about 24 × 32 cm).
  album(24 / 32),

  /// American comics (about 17 × 26 cm).
  comics(17 / 26);

  new(this.ratio);

  final double? ratio;
}

/// Longest side of a saved cover.
const maxCoverSide = 1200;

/// Default frame: the photo minus a 10 % margin (the user moves the corners).
Quad defaultQuad(int width, int height) {
  final dx = width * 0.1;
  final dy = height * 0.1;
  return (
    topLeft: (x: dx, y: dy),
    topRight: (x: width - dx, y: dy),
    bottomRight: (x: width - dx, y: height - dy),
    bottomLeft: (x: dx, y: height - dy),
  );
}

double _dist(Pt a, Pt b) {
  final dx = a.x - b.x;
  final dy = a.y - b.y;
  return math.sqrt(dx * dx + dy * dy);
}

/// Size of the straightened cover: the longest opposite sides, the ratio of
/// [aspect] when set (the height kept), then at most [maxSide] on the longest
/// side (never enlarged).
({int width, int height}) outputSize(
  Quad q, {
  CoverAspect aspect = CoverAspect.free,
  int maxSide = maxCoverSide,
}) {
  var width = math.max(
    _dist(q.topLeft, q.topRight),
    _dist(q.bottomLeft, q.bottomRight),
  );
  final height = math.max(
    _dist(q.topLeft, q.bottomLeft),
    _dist(q.topRight, q.bottomRight),
  );
  if (aspect.ratio case final ratio?) width = height * ratio;
  final scale = math.min(1, maxSide / math.max(width, height));
  return (
    width: math.max(1, (width * scale).round()),
    height: math.max(1, (height * scale).round()),
  );
}

/// The corners after a quarter turn clockwise of an image [height] pixels
/// high: the picture turns, the corners follow it.
Quad rotateQuadClockwise(Quad q, int height) {
  Pt turn(Pt p) => (x: height - p.y, y: p.x);
  // The old bottom left becomes the new top left.
  return (
    topLeft: turn(q.bottomLeft),
    topRight: turn(q.topLeft),
    bottomRight: turn(q.topRight),
    bottomLeft: turn(q.bottomRight),
  );
}

/// Projective transform mapping the output rectangle onto [Quad] of the
/// photo: straight lines stay straight (true perspective correction).
class Homography {
  const new _(this._m);

  /// Maps (0,0)…(width-1,height-1) onto the corners of [q].
  factory rectToQuad(Quad q, int width, int height) {
    final w = math.max(1, width - 1).toDouble();
    final h = math.max(1, height - 1).toDouble();
    final pairs = <(Pt, Pt)>[
      ((x: 0, y: 0), q.topLeft),
      ((x: w, y: 0), q.topRight),
      ((x: w, y: h), q.bottomRight),
      ((x: 0, y: h), q.bottomLeft),
    ];
    // Classic 8 unknowns system (h33 = 1).
    final a = <List<double>>[];
    for (final (s, d) in pairs) {
      a
        ..add([s.x, s.y, 1, 0, 0, 0, -s.x * d.x, -s.y * d.x, d.x])
        ..add([0, 0, 0, s.x, s.y, 1, -s.x * d.y, -s.y * d.y, d.y]);
    }
    return Homography._([..._solve(a), 1]);
  }

  final List<double> _m;

  Pt map(double x, double y) {
    final m = _m;
    final z = m[6] * x + m[7] * y + m[8];
    return (
      x: (m[0] * x + m[1] * y + m[2]) / z,
      y: (m[3] * x + m[4] * y + m[5]) / z,
    );
  }

  /// Gaussian elimination with partial pivoting on an augmented matrix.
  static List<double> _solve(List<List<double>> a) {
    final n = a.length;
    for (var col = 0; col < n; col++) {
      var pivot = col;
      for (var r = col + 1; r < n; r++) {
        if (a[r][col].abs() > a[pivot][col].abs()) pivot = r;
      }
      if (a[pivot][col].abs() < 1e-12) {
        throw ArgumentError('Degenerate corners');
      }
      final row = a[col];
      a[col] = a[pivot];
      a[pivot] = row;
      for (var r = 0; r < n; r++) {
        if (r == col) continue;
        final f = a[r][col] / a[col][col];
        for (var c = col; c <= n; c++) {
          a[r][c] -= f * a[col][c];
        }
      }
    }
    return [for (var i = 0; i < n; i++) a[i][n] / a[i][i]];
  }
}
