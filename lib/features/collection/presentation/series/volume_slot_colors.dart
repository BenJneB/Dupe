import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:material_ui/material_ui.dart';

/// Background/foreground colors of a volume pastille, consistent with the
/// store mode colors (green owned, amber wished, blue loaned).
({Color background, Color foreground, Color? border}) volumeSlotColors(
  VolumeSlotStatus status,
  ColorScheme scheme,
) => switch (status) {
  VolumeSlotStatus.owned => (
    background: const Color(0xFF2E7D32),
    foreground: Colors.white,
    border: null,
  ),
  VolumeSlotStatus.loaned => (
    background: const Color(0xFF1565C0),
    foreground: Colors.white,
    border: null,
  ),
  VolumeSlotStatus.wished => (
    background: const Color(0xFFFFB300),
    foreground: Colors.black,
    border: null,
  ),
  VolumeSlotStatus.missing => (
    background: scheme.surface,
    foreground: scheme.onSurfaceVariant,
    border: scheme.outline,
  ),
};
