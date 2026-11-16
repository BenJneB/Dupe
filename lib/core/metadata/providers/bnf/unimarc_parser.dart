import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_record.dart';
import 'package:dupe/core/utils/isbn.dart';
import 'package:xml/xml.dart';

const _languages = {
  'fre': 'fr',
  'eng': 'en',
  'jpn': 'ja',
  'ger': 'de',
  'spa': 'es',
  'ita': 'it',
  'kor': 'ko',
  'chi': 'zh',
  'dut': 'nl',
  'por': 'pt',
};

/// Roles kept as authors ($4 relator codes): author, illustrator.
/// Translators (730), prefacers… are ignored.
const _authorRoles = {'070', '440'};

/// Parses an SRU response in `unimarcXchange` into results.
List<MetadataResult> parseUnimarcResponse(String xml) {
  final doc = XmlDocument.parse(xml);
  return doc.descendants
      .whereType<XmlElement>()
      .where((e) => e.localName == 'record' && e.getAttribute('format') != null)
      .map((e) => parseUnimarcRecord(UnimarcRecord(e)))
      .whereType<MetadataResult>()
      .toList();
}

MetadataResult? parseUnimarcRecord(UnimarcRecord r) {
  final title = r.first('200', 'a');
  if (title == null) return null;

  final isbn = r.first('010', 'a') ?? r.first('073', 'a');
  final price = _parsePrice(r.first('010', 'd'));
  final linkedSeries = r.first('461', 't');
  final ownVolume = r.first('200', 'h');
  final numberedCollection = _seriesCollection(
    r,
    linkedSeries: linkedSeries,
    hasOwnVolume: ownVolume != null,
  );

  return MetadataResult(
    source: MetadataSource.bnf,
    sourceId: r.id ?? r.control('001') ?? title,
    title: title,
    subtitle: r.first('200', 'e') ?? r.first('200', 'i'),
    authors: _authors(r),
    publisher: r.first('214', 'c') ?? r.first('210', 'c'),
    publishDate: _year(r.first('214', 'd') ?? r.first('210', 'd')),
    pageCount: _pages(r.first('215', 'a')),
    language: _languages[r.first('101', 'a')],
    isbn13: isbn == null ? null : Isbn.toIsbn13(isbn),
    description: r.first('330', 'a'),
    seriesTitle: linkedSeries ?? numberedCollection?.title,
    volumeNumber: cleanVolumeNumber(
      ownVolume ?? r.first('461', 'v') ?? numberedCollection?.number,
    ),
    coverPrice: price?.amount,
    currency: price?.currency,
  );
}

/// The 225 field that names the series, if any. 225 is often a publisher's
/// collection instead ("Folio junior" n° 1987, "Tracts Gallimard" n° 50,
/// "Poches Jouvence" n° 1). In the BnF records, a real series always comes
/// with its 461 link; a numbered 225 alone is a collection (recette
/// 2026-11-16). So only the 225 of the linked series counts, and only when
/// the record has no own volume number (200 $h); numbers from 1000 are
/// collection numbers whatever the title.
({String title, String number})? _seriesCollection(
  UnimarcRecord r, {
  required String? linkedSeries,
  required bool hasOwnVolume,
}) {
  if (linkedSeries == null || hasOwnVolume) return null;
  for (final f in r.fields('225')) {
    final title = UnimarcRecord.subfields(f, 'a').firstOrNull;
    final number = UnimarcRecord.subfields(f, 'v').firstOrNull;
    if (title == null || number == null) continue;
    if (_fold(title) != _fold(linkedSeries)) continue;
    if ((int.tryParse(number.trim()) ?? 0) >= 1000) continue;
    return (title: title, number: number);
  }
  return null;
}

String _fold(String s) => s.toLowerCase().replaceAll(RegExp(r'\W+'), '');

List<String> _authors(UnimarcRecord r) {
  final names = <String>[];
  for (final tag in ['700', '701', '702']) {
    for (final field in r.fields(tag)) {
      final role = UnimarcRecord.subfields(field, '4').firstOrNull;
      // 702 without a relator code is commonly the author too.
      if (role != null && !_authorRoles.contains(role)) continue;
      final last = UnimarcRecord.subfields(field, 'a').firstOrNull;
      if (last == null) continue;
      final first = UnimarcRecord.subfields(field, 'b').firstOrNull;
      final name = first == null ? last : '$first $last';
      if (!names.contains(name)) names.add(name);
    }
  }
  return names;
}

final _volumePrefix = RegExp(
  r'^(tome|t\.|vol\.?|volume|livre|n°|no\.?|numéro)\s*',
  caseSensitive: false,
);

/// Square brackets: information added by the cataloguer ("[Livre 1]").
final _brackets = RegExp(r'^\[(.*)\]$');

/// "Tome 2" / "T. 2" / "Vol. 2" / "[Livre 2]" -> "2"; other labels
/// ("Saison 1", "HS 2") are kept as is.
String? cleanVolumeNumber(String? raw) {
  final trimmed = raw?.trim();
  final value = trimmed
      ?.replaceFirstMapped(_brackets, (m) => m[1]!)
      .trim()
      .replaceFirst(_volumePrefix, '')
      .trim();
  return value == null || value.isEmpty ? null : value;
}

String? _year(String? raw) =>
    raw == null ? null : RegExp(r'\d{4}').firstMatch(raw)?.group(0);

int? _pages(String? raw) {
  final match = raw == null ? null : RegExp(r'(\d+) p\.').firstMatch(raw);
  return match == null ? null : int.parse(match.group(1)!);
}

({double amount, String currency})? _parsePrice(String? raw) {
  final match = raw == null
      ? null
      : RegExp(r'(\d+(?:[.,]\d+)?)\s*([A-Z]{3})').firstMatch(raw);
  if (match == null) return null;
  return (
    amount: double.parse(match.group(1)!.replaceAll(',', '.')),
    currency: match.group(2)!,
  );
}
