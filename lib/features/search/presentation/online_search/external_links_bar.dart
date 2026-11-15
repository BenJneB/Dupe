import 'dart:async';

import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/search/domain/external_links.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Ouvrir sur Bédéthèque / Manga-News / Comic Vine" buttons.
class ExternalLinksBar extends StatelessWidget {
  const new({required this.type, this.isbn13, this.query, super.key});

  final CollectionType type;
  final String? isbn13;
  final String? query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final links = externalLinks(type, isbn13: isbn13, query: query);
    if (links.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: [
          for (final link in links)
            TextButton.icon(
              key: ValueKey('external-${link.name}'),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.openOn(link.name)),
              onPressed: () => unawaited(
                launchUrl(link.uri, mode: LaunchMode.externalApplication),
              ),
            ),
        ],
      ),
    );
  }
}
