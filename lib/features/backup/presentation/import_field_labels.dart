import 'package:dupe/features/backup/domain/import_field.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

extension ImportFieldLabel on ImportField {
  String label(AppLocalizations l10n) => switch (this) {
    ImportField.title => l10n.importFieldTitle,
    ImportField.series => l10n.importFieldSeries,
    ImportField.volume => l10n.importFieldVolume,
    ImportField.volumeTitle => l10n.fieldVolumeTitle,
    ImportField.type => l10n.importFieldType,
    ImportField.authors => l10n.importFieldAuthors,
    ImportField.publisher => l10n.importFieldPublisher,
    ImportField.isbn => l10n.importFieldIsbn,
    ImportField.ownership => l10n.importFieldOwnership,
    ImportField.readingStatus => l10n.importFieldReading,
    ImportField.purchasePrice => l10n.importFieldPurchasePrice,
    ImportField.purchaseDate => l10n.importFieldPurchaseDate,
    ImportField.coverPrice => l10n.importFieldCoverPrice,
    ImportField.location => l10n.importFieldLocation,
    ImportField.notes => l10n.importFieldNotes,
    ImportField.signed => l10n.fieldSigned,
    ImportField.signedBy => l10n.fieldSignedBy,
    ImportField.signedOn => l10n.fieldSignedOn,
    ImportField.signedPlace => l10n.fieldSignedPlace,
    ImportField.signingNote => l10n.fieldSigningNote,
  };
}
