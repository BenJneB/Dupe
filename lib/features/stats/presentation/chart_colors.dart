import 'package:material_ui/material_ui.dart';

/// Single-series chart colours (dataviz reference palette, blue slot,
/// validated for both surfaces). Text never uses these: it keeps the
/// theme's ink colours.
({Color series, Color track}) chartColors(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? (series: const Color(0xFF3987E5), track: const Color(0xFF0D366B))
    : (series: const Color(0xFF2A78D6), track: const Color(0xFFCDE2FB));
