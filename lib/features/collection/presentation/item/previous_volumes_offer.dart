import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// After adding owned volume N of a series: offers to add the volumes
/// missing before it (1 to N-1) as owned, in one tap.
Future<void> offerPreviousVolumes(
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
  CollectionRepository repo,
  Item item,
) async {
  final number = VolumeNumber.asInt(item.volumeNumber);
  final seriesId = item.seriesId;
  if (number == null ||
      number < 2 ||
      seriesId == null ||
      item.ownership != Ownership.possede) {
    return;
  }
  final series = await repo.getSeries(seriesId);
  if (series == null) return;
  final taken = {
    for (final i in await repo.listSeriesItems(seriesId))
      ?VolumeNumber.asInt(i.volumeNumber),
  };
  final missing = [
    for (var n = 1; n < number; n++)
      if (!taken.contains(n)) n,
  ];
  if (missing.isEmpty) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.previousVolumesOffer(missing.length, number)),
        duration: const Duration(seconds: 10),
        // material_ui keeps snackbars with an action until dismissed.
        persist: false,
        action: SnackBarAction(
          key: const Key('addPreviousVolumes'),
          label: l10n.add,
          onPressed: () => unawaited(() async {
            String message;
            try {
              final created = await repo.addVolumeRange(
                series,
                from: 1,
                to: number - 1,
              );
              message = l10n.volumesAdded(created);
            } on Object catch (e, stack) {
              message = reportError(l10n, 'collection', e, stack);
            }
            messenger.showSnackBar(SnackBar(content: Text(message)));
          }()),
        ),
      ),
    );
}
