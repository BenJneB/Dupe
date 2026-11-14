import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:material_ui/material_ui.dart';

/// Text fields of the item form.
enum ItemTextField {
  title,
  volume,
  isbn,
  upc,
  authors,
  publisher,
  edition,
  format,
  publishDate,
  pageCount,
  language,
  coverUrl,
  description,
  condition,
  purchasePrice,
  coverPrice,
  estimatedValue,
  currency,
  maxPrice,
  location,
  notes,
}

/// Text controllers of the item form and their mapping to/from [Item].
class ItemFormControllers {
  final Map<ItemTextField, TextEditingController> _c = {
    for (final f in ItemTextField.values) f: TextEditingController(),
  };

  TextEditingController operator [](ItemTextField field) => _c[field]!;

  static String _price(double? v) => v?.toString().replaceAll('.', ',') ?? '';

  void fill(Item i) {
    final values = <ItemTextField, String>{
      ItemTextField.title: i.title,
      ItemTextField.volume: i.volumeNumber ?? '',
      ItemTextField.isbn: i.isbn13 ?? '',
      ItemTextField.upc: i.upc ?? '',
      ItemTextField.authors: i.authors.join(', '),
      ItemTextField.publisher: i.publisher ?? '',
      ItemTextField.edition: i.edition ?? '',
      ItemTextField.format: i.format ?? '',
      ItemTextField.publishDate: i.publishDate ?? '',
      ItemTextField.pageCount: i.pageCount?.toString() ?? '',
      ItemTextField.language: i.language ?? '',
      ItemTextField.coverUrl: i.coverUrl ?? '',
      ItemTextField.description: i.description ?? '',
      ItemTextField.condition: i.condition ?? '',
      ItemTextField.purchasePrice: _price(i.purchasePrice),
      ItemTextField.coverPrice: _price(i.coverPrice),
      ItemTextField.estimatedValue: _price(i.estimatedValue),
      ItemTextField.currency: i.currency,
      ItemTextField.maxPrice: _price(i.wishlistMaxPrice),
      ItemTextField.location: i.location ?? '',
      ItemTextField.notes: i.notes ?? '',
    };
    for (final MapEntry(:key, :value) in values.entries) {
      _c[key]!.text = value;
    }
  }

  String? _t(ItemTextField f) => textOrNull(_c[f]!);

  double? _d(ItemTextField f) => Formatters.parseDecimal(_c[f]!.text);

  /// Copies the text fields into [item].
  Item applyTo(Item item) => item.copyWith(
    title: _c[ItemTextField.title]!.text.trim(),
    volumeNumber: _t(ItemTextField.volume),
    isbn13: _t(ItemTextField.isbn)?.replaceAll(RegExp(r'[\s-]'), ''),
    upc: _t(ItemTextField.upc),
    authors: Formatters.splitList(_c[ItemTextField.authors]!.text),
    publisher: _t(ItemTextField.publisher),
    edition: _t(ItemTextField.edition),
    format: _t(ItemTextField.format),
    publishDate: _t(ItemTextField.publishDate),
    pageCount: int.tryParse(_c[ItemTextField.pageCount]!.text),
    language: _t(ItemTextField.language),
    coverUrl: _t(ItemTextField.coverUrl),
    description: _t(ItemTextField.description),
    condition: _t(ItemTextField.condition),
    purchasePrice: _d(ItemTextField.purchasePrice),
    coverPrice: _d(ItemTextField.coverPrice),
    estimatedValue: _d(ItemTextField.estimatedValue),
    currency: _t(ItemTextField.currency)?.toUpperCase() ?? 'EUR',
    wishlistMaxPrice: _d(ItemTextField.maxPrice),
    location: _t(ItemTextField.location),
    notes: _t(ItemTextField.notes),
  );

  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
  }
}
