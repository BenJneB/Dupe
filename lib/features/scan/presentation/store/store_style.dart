import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Banner colours: readable at a glance in a shop, same in light and dark
/// themes (except "unknown", which follows the theme).
({Color background, Color foreground, IconData icon, String title}) storeStyle(
  StoreVerdict verdict,
  ColorScheme scheme,
  AppLocalizations l10n,
) => switch (verdict) {
  StoreVerdict.owned => (
    background: const Color(0xFF1B7A3A),
    foreground: Colors.white,
    icon: Icons.check_circle,
    title: l10n.storeOwned,
  ),
  StoreVerdict.wished => (
    background: const Color(0xFFF2B705),
    foreground: const Color(0xFF221B00),
    icon: Icons.favorite,
    title: l10n.storeWished,
  ),
  StoreVerdict.seriesNotOwned => (
    background: const Color(0xFF1D5FBF),
    foreground: Colors.white,
    icon: Icons.collections_bookmark,
    title: l10n.storeSeriesNotOwned,
  ),
  StoreVerdict.unknown => (
    background: scheme.surfaceContainerHighest,
    foreground: scheme.onSurface,
    icon: Icons.help_outline,
    title: l10n.storeUnknown,
  ),
};
