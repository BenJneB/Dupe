import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:dupe/features/search/presentation/online_search/result_summary.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

/// Headline of the banner: what was scanned.
String? storeHeadline(StoreCheck c, AppLocalizations l10n) {
  final item = c.item;
  final metadata = c.metadata;
  final series = c.series;
  if (item != null) {
    final volume = item.volumeNumber;
    return volume == null ? item.title : l10n.volumeTitle(item.title, volume);
  }
  if (series != null && metadata != null) {
    // No volume number (BnF record without one): its own title, not "Tome ?".
    return switch (metadata.volumeNumber) {
      final volume? => l10n.storeVolumeOf(volume, series.title),
      null => l10n.storeInSeries(resultTitle(l10n, metadata), series.title),
    };
  }
  return metadata == null ? null : resultTitle(l10n, metadata);
}

/// Detail lines: purchase, location, max price, owned volumes…
List<String> storeDetails(StoreCheck c, AppLocalizations l10n) {
  final locale = l10n.localeName;
  final item = c.item;
  final metadata = c.metadata;
  String ownedVolumes() => c.ownedNumbers.isEmpty
      ? l10n.storeYouHaveNone
      : l10n.storeYouHave(
          Formatters.numberList(c.ownedNumbers, l10n.rangeWord),
        );

  return switch (c.verdict) {
    StoreVerdict.owned => [
      if (item?.purchaseDate case final date?)
        l10n.storePurchasedOn(Formatters.date(date, locale)),
      if (item?.location case final location? when location.isNotEmpty)
        l10n.storeLocation(location),
      if (c.isbnRemembered) l10n.storeIsbnRemembered,
      if (c.otherEdition && c.series == null)
        l10n.storeOtherEditionBook
      else if (c.otherEdition)
        l10n.storeOtherEdition,
    ],
    StoreVerdict.wished => [
      if (item?.wishlistMaxPrice case final price?)
        l10n.storeMaxPrice(Formatters.price(price, item!.currency, locale)),
      if (c.series != null) ownedVolumes(),
      if (c.isbnRemembered) l10n.storeIsbnRemembered,
    ],
    StoreVerdict.seriesNotOwned => [ownedVolumes()],
    StoreVerdict.unknown => [
      if (metadata != null) resultSubtitle(metadata, withSource: false),
      if (c.offline) l10n.storeOffline,
    ],
  };
}
