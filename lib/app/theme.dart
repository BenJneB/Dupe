import 'package:material_ui/material_ui.dart';

/// Light and dark themes derived from a single seed color.
abstract final class AppTheme {
  static const _seed = Color(0xFF3F51B5);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  );
}
