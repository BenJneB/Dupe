import 'package:xml/xml.dart';

/// Read-only view over a marcXchange (UNIMARC) record.
class UnimarcRecord {
  new(this._element);

  final XmlElement _element;

  String? get id => _element.getAttribute('id');

  Iterable<XmlElement> fields(String tag) => _element.childElements.where(
    (e) => e.localName == 'datafield' && e.getAttribute('tag') == tag,
  );

  /// Values of subfield [code] in [field].
  static Iterable<String> subfields(XmlElement field, String code) => field
      .childElements
      .where((e) => e.localName == 'subfield' && e.getAttribute('code') == code)
      .map((e) => e.innerText.trim())
      .where((v) => v.isNotEmpty);

  /// First value of `tag$code` across the record.
  String? first(String tag, String code) {
    for (final field in fields(tag)) {
      final value = subfields(field, code).firstOrNull;
      if (value != null) return value;
    }
    return null;
  }

  String? control(String tag) => _element.childElements
      .where(
        (e) => e.localName == 'controlfield' && e.getAttribute('tag') == tag,
      )
      .map((e) => e.innerText.trim())
      .firstOrNull;
}
