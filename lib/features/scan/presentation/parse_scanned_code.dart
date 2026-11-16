import 'package:dupe/core/utils/isbn.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// ISBN-13 of a scanned or typed code; other codes show an error and give
/// null.
String? parseScannedCode(BuildContext context, String raw) {
  final isbn = Isbn.toIsbn13(raw);
  if (isbn != null) return isbn;
  final l10n = AppLocalizations.of(context);
  final message = switch (Isbn.classify(raw)) {
    CodeKind.upc => l10n.upcNotSupported,
    _ => l10n.invalidCode(Isbn.normalize(raw)),
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  return null;
}

/// The code to use among those seen in one camera frame: an ISBN when there
/// is one (books often carry a second barcode, read as UPC: recette M-13),
/// otherwise the first code.
String? pickScannedCode(Iterable<String> raws) =>
    raws.where((r) => Isbn.toIsbn13(r) != null).firstOrNull ?? raws.firstOrNull;
