import 'package:dupe/app/widgets/global_search_bar.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Series/books list for one collection type (empty until phase 1).
class CollectionTabScreen extends StatelessWidget {
  const new({required this.type, super.key});

  final CollectionType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const GlobalSearchBar()),
      body: PlaceholderBody(
        key: ValueKey('collectionTab-${type.name}'),
        icon: Icons.collections_bookmark_outlined,
        title: l10n.emptyCollectionTitle,
        message: l10n.emptyCollectionBody,
      ),
    );
  }
}
