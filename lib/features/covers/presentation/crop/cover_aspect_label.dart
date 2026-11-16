import 'package:dupe/features/covers/domain/perspective.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

extension CoverAspectLabel on CoverAspect {
  String label(AppLocalizations l10n) => switch (this) {
    CoverAspect.free => l10n.cropAspectFree,
    CoverAspect.pocket => l10n.cropAspectPocket,
    CoverAspect.album => l10n.cropAspectAlbum,
    CoverAspect.comics => l10n.cropAspectComics,
  };
}
