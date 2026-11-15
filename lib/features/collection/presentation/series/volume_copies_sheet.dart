import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Lists the copies (editions) of a volume; tap one to open it.
Future<void> showVolumeCopies(
  BuildContext context,
  CollectionType type,
  VolumeSlot slot,
) => showModalBottomSheet<void>(
  context: context,
  builder: (sheetContext) {
    final l10n = AppLocalizations.of(sheetContext);
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.volumeCopiesTitle(slot.label, slot.copies.length),
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
          ),
          for (final (i, copy) in slot.copies.indexed)
            ListTile(
              key: ValueKey('copy-${copy.id}'),
              leading: Icon(
                copy.ownership == Ownership.possede
                    ? Icons.check_circle_outline
                    : Icons.favorite_border,
              ),
              title: Text(copy.edition ?? l10n.copyNumber(i + 1)),
              subtitle: copy.isbn13 == null
                  ? null
                  : Text('ISBN ${copy.isbn13}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(sheetContext);
                unawaited(context.push(AppRoutes.item(type, copy.id)));
              },
            ),
        ],
      ),
    );
  },
);
