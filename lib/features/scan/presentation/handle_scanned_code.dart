import 'package:dupe/app/router.dart';
import 'package:dupe/core/utils/isbn.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Routes a scanned or typed code: ISBNs open the online lookup, other codes
/// show an error. Returns whether the code was accepted.
bool handleScannedCode(
  BuildContext context,
  String raw, {
  CollectionType? type,
}) {
  final l10n = AppLocalizations.of(context);
  final isbn = Isbn.toIsbn13(raw);
  if (isbn != null) {
    context.pushReplacement(AppRoutes.onlineSearch(query: isbn, type: type));
    return true;
  }
  final message = switch (Isbn.classify(raw)) {
    CodeKind.upc => l10n.upcNotSupported,
    _ => l10n.invalidCode(Isbn.normalize(raw)),
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  return false;
}
