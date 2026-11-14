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
    seriesTitle: r.first('461', 't') ?? r.first('225', 'a'),
    volumeNumber:
        r.first('200', 'h') ?? r.first('461', 'v') ?? r.first('225', 'v'),
    coverPrice: price?.amount,
    currency: price?.currency,
  );
}

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
