import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Create or edit an item (volume, issue, book).
class ItemFormScreen extends ConsumerStatefulWidget {
  const new({
    required this.type,
    this.itemId,
    this.seriesId,
    this.volumeNumber,
    super.key,
  });

  final CollectionType type;

  /// Null to create a new item.
  final String? itemId;

  /// For a new item: series to attach it to, and prefilled volume number.
  final String? seriesId;
  final String? volumeNumber;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _c = ItemFormControllers();
  Ownership _ownership = Ownership.possede;
  ReadingStatus _readingStatus = ReadingStatus.nonLu;
  int? _rating;
  int? _priority;
  var _firstEdition = false;
  var _variant = false;
  DateTime? _readDate;
  DateTime? _purchaseDate;
  Item? _original;
  var _saving = false;

  bool get _isNew => widget.itemId == null;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final repo = ref.read(collectionRepositoryProvider);
    final itemId = widget.itemId;
    final seriesId = widget.seriesId;
    final Item? item;
    if (itemId != null) {
      item = await repo.getItem(itemId);
    } else {
      final series = seriesId == null ? null : await repo.getSeries(seriesId);
      item = repo.newItem(
        widget.type,
        series: series,
        volumeNumber: widget.volumeNumber,
      );
    }
    if (!mounted || item == null) return;
    setState(() => _fill(item!));
  }

  void _fill(Item i) {
    _original = i;
    _c.fill(i);
    _ownership = i.ownership;
    _readingStatus = i.readingStatus;
    _rating = i.rating;
    _priority = i.wishlistPriority;
    _firstEdition = i.isFirstEdition;
    _variant = i.isVariant;
    _readDate = i.readDate;
    _purchaseDate = i.purchaseDate;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final original = _original;
    if (original == null || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final item = _c
        .applyTo(original)
        .copyWith(
          ownership: _ownership,
          readingStatus: _readingStatus,
          readDate: _readDate,
          rating: _rating,
          isFirstEdition: _firstEdition,
          isVariant: _variant,
          purchaseDate: _purchaseDate,
          wishlistPriority: _priority,
        );
    await ref.read(collectionRepositoryProvider).saveItem(item);
    if (!mounted) return;
    if (_isNew && item.seriesId == null) {
      context.pushReplacement(AppRoutes.item(item.type, item.id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final loaded = _original != null;
    String? decimal(String? v) =>
        (v == null || v.trim().isEmpty || Formatters.parseDecimal(v) != null)
        ? null
        : l10n.invalidNumber;
    Widget text(
      ItemTextField f,
      String label, {
      bool digits = false,
      int lines = 1,
      FormFieldValidator<String>? validator,
      String? helper,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FormText(
        fieldKey: Key('field-${f.name}'),
        controller: _c[f],
        label: label,
        digitsOnly: digits,
        maxLines: lines,
        validator: validator,
        helper: helper,
        keyboardType: validator == decimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.newItemTitle : l10n.editItem),
        actions: [
          TextButton(
            key: const Key('saveButton'),
            onPressed: loaded && !_saving ? _save : null,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: !loaded
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SegmentedButton<Ownership>(
                    segments: [
                      for (final o in Ownership.values)
                        ButtonSegment(value: o, label: Text(o.label(l10n))),
                    ],
                    selected: {_ownership},
                    onSelectionChanged: (s) =>
                        setState(() => _ownership = s.first),
                  ),
                  FormSection(l10n.sectionGeneral),
                  text(
                    ItemTextField.title,
                    l10n.fieldTitle,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.requiredField
                        : null,
                  ),
                  text(
                    ItemTextField.volume,
                    l10n.fieldVolumeNumber,
                    helper: l10n.fieldVolumeNumberHelper,
                  ),
                  text(
                    ItemTextField.authors,
                    l10n.fieldAuthors,
                    helper: l10n.commaSeparated,
                  ),
                  text(ItemTextField.publisher, l10n.fieldPublisher),
                  text(ItemTextField.edition, l10n.fieldEdition),
                  text(ItemTextField.format, l10n.fieldFormat),
                  text(ItemTextField.publishDate, l10n.fieldPublishDate),
                  text(
                    ItemTextField.pageCount,
                    l10n.fieldPageCount,
                    digits: true,
                  ),
                  text(ItemTextField.language, l10n.fieldLanguage),
                  text(ItemTextField.isbn, l10n.fieldIsbn),
                  text(ItemTextField.upc, l10n.fieldUpc),
                  text(ItemTextField.coverUrl, l10n.fieldCoverUrl),
                  text(
                    ItemTextField.description,
                    l10n.fieldDescription,
                    lines: 5,
                  ),
                  FormSection(l10n.sectionReading),
                  DropdownButtonFormField<ReadingStatus>(
                    isExpanded: true,
                    initialValue: _readingStatus,
                    decoration: InputDecoration(
                      labelText: l10n.fieldReadingStatus,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      for (final s in ReadingStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label(l10n))),
                    ],
                    onChanged: (s) =>
                        setState(() => _readingStatus = s ?? _readingStatus),
                  ),
                  formGap,
                  FormDate(
                    label: l10n.fieldReadDate,
                    value: _readDate,
                    format: (d) => Formatters.date(d, locale),
                    onChanged: (d) => setState(() => _readDate = d),
                  ),
                  formGap,
                  DropdownButtonFormField<int?>(
                    isExpanded: true,
                    initialValue: _rating,
                    decoration: InputDecoration(
                      labelText: l10n.fieldRating,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(child: Text(l10n.none)),
                      for (var r = 0; r <= 5; r++)
                        DropdownMenuItem(value: r, child: Text('$r/5')),
                    ],
                    onChanged: (r) => setState(() => _rating = r),
                  ),
                  FormSection(l10n.sectionCopy),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldFirstEdition),
                    value: _firstEdition,
                    onChanged: (v) => setState(() => _firstEdition = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldVariant),
                    value: _variant,
                    onChanged: (v) => setState(() => _variant = v),
                  ),
                  text(ItemTextField.condition, l10n.fieldCondition),
                  text(
                    ItemTextField.location,
                    l10n.fieldLocation,
                    helper: l10n.fieldLocationHelper,
                  ),
                  FormSection(l10n.sectionPrice),
                  text(
                    ItemTextField.purchasePrice,
                    l10n.fieldPurchasePrice,
                    validator: decimal,
                  ),
                  FormDate(
                    label: l10n.fieldPurchaseDate,
                    value: _purchaseDate,
                    format: (d) => Formatters.date(d, locale),
                    onChanged: (d) => setState(() => _purchaseDate = d),
                  ),
                  formGap,
                  text(
                    ItemTextField.coverPrice,
                    l10n.fieldCoverPrice,
                    validator: decimal,
                  ),
                  text(
                    ItemTextField.estimatedValue,
                    l10n.fieldEstimatedValue,
                    validator: decimal,
                  ),
                  text(ItemTextField.currency, l10n.fieldCurrency),
                  if (_ownership == Ownership.envie) ...[
                    FormSection(l10n.sectionWishlist),
                    DropdownButtonFormField<int?>(
                      isExpanded: true,
                      initialValue: _priority,
                      decoration: InputDecoration(
                        labelText: l10n.fieldWishlistPriority,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(child: Text(l10n.none)),
                        for (var p = 1; p <= 3; p++)
                          DropdownMenuItem(value: p, child: Text('$p')),
                      ],
                      onChanged: (p) => setState(() => _priority = p),
                    ),
                    formGap,
                    text(
                      ItemTextField.maxPrice,
                      l10n.fieldWishlistMaxPrice,
                      validator: decimal,
                    ),
                  ],
                  FormSection(l10n.fieldNotes),
                  text(ItemTextField.notes, l10n.fieldNotes, lines: 3),
                ],
              ),
            ),
    );
  }
}
