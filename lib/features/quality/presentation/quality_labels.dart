import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

extension QualityIssueLabel on QualityIssue {
  String label(AppLocalizations l10n) => switch (this) {
    QualityIssue.noIsbn => l10n.qualityNoIsbn,
    QualityIssue.noCover => l10n.qualityNoCover,
    QualityIssue.noVolumeNumber => l10n.qualityNoVolumeNumber,
    QualityIssue.looksLikeVolume => l10n.qualityLooksLikeVolume,
    QualityIssue.seriesWithoutTotal => l10n.qualitySeriesWithoutTotal,
  };

  IconData get icon => switch (this) {
    QualityIssue.noIsbn => Icons.qr_code_2,
    QualityIssue.noCover => Icons.image_not_supported_outlined,
    QualityIssue.noVolumeNumber => Icons.format_list_numbered,
    QualityIssue.looksLikeVolume => Icons.collections_bookmark_outlined,
    QualityIssue.seriesWithoutTotal => Icons.functions,
  };
}
