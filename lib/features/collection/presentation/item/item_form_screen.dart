import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/features/collection/presentation/item/item_text_input.dart';
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
    this.prefill,
    super.key,
  });

  final CollectionType type;

  /// Null to create a new item.
  final String? itemId;

  /// For a new item: series to attach it to, and prefilled volume number.
  final String? seriesId;
  final String? volumeNumber;

  /// For a new item: metadata from an online result.
  final ItemPrefill? prefill;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _c = ItemFormControllers();
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
      final draft = repo.newItem(
        widget.type,
        series: series,
        volumeNumber: widget.volumeNumber,
      );
      final prefill = widget.prefill;
      item = prefill == null ? draft : applyMetadata(draft, prefill);
    }
    if (!mounted || item == null) return;
    setState(() => _fill(item!));
  }

  void _fill(Item i) {
    _original = i;
    _c.fill(i);
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
    final item = _c.applyTo(original);
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
                    selected: {_c.ownership},
                    onSelectionChanged: (s) =>
                        setState(() => _c.ownership = s.first),
                  ),
                  FormSection(l10n.sectionGeneral),
                  ItemGeneralFields(_c),
                  FormSection(l10n.sectionReading),
                  FormDropdown<ReadingStatus>(
                    label: l10n.fieldReadingStatus,
                    value: _c.readingStatus,
                    items: {
                      for (final s in ReadingStatus.values) s: s.label(l10n),
                    },
                    onChanged: (s) => setState(() => _c.readingStatus = s),
                  ),
                  formGap,
                  FormDate(
                    label: l10n.fieldReadDate,
                    value: _c.readDate,
                    format: (d) => Formatters.date(d, locale),
                    onChanged: (d) => setState(() => _c.readDate = d),
                  ),
                  formGap,
                  FormDropdown<int?>(
                    label: l10n.fieldRating,
                    value: _c.rating,
                    items: {
                      null: l10n.none,
                      for (var r = 0; r <= 5; r++) r: '$r/5',
                    },
                    onChanged: (r) => setState(() => _c.rating = r),
                  ),
                  FormSection(l10n.sectionCopy),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldFirstEdition),
                    value: _c.firstEdition,
                    onChanged: (v) => setState(() => _c.firstEdition = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldVariant),
                    value: _c.variant,
                    onChanged: (v) => setState(() => _c.variant = v),
                  ),
                  ItemTextInput(
                    _c,
                    ItemTextField.condition,
                    l10n.fieldCondition,
                  ),
                  ItemTextInput(
                    _c,
                    ItemTextField.location,
                    l10n.fieldLocation,
                    helper: l10n.fieldLocationHelper,
                  ),
                  FormSection(l10n.sectionPrice),
                  ItemTextInput(
                    _c,
                    ItemTextField.purchasePrice,
                    l10n.fieldPurchasePrice,
                    decimal: true,
                  ),
                  FormDate(
                    label: l10n.fieldPurchaseDate,
                    value: _c.purchaseDate,
                    format: (d) => Formatters.date(d, locale),
                    onChanged: (d) => setState(() => _c.purchaseDate = d),
                  ),
                  formGap,
                  ItemTextInput(
                    _c,
                    ItemTextField.coverPrice,
                    l10n.fieldCoverPrice,
                    decimal: true,
                  ),
                  ItemTextInput(
                    _c,
                    ItemTextField.estimatedValue,
                    l10n.fieldEstimatedValue,
                    decimal: true,
                  ),
                  ItemTextInput(_c, ItemTextField.currency, l10n.fieldCurrency),
                  if (_c.ownership == Ownership.envie) ...[
                    FormSection(l10n.sectionWishlist),
                    FormDropdown<int?>(
                      label: l10n.fieldWishlistPriority,
                      value: _c.priority,
                      items: {
                        null: l10n.none,
                        for (var p = 1; p <= 3; p++) p: '$p',
                      },
                      onChanged: (p) => setState(() => _c.priority = p),
                    ),
                    formGap,
                    ItemTextInput(
                      _c,
                      ItemTextField.maxPrice,
                      l10n.fieldWishlistMaxPrice,
                      decimal: true,
                    ),
                  ],
                  FormSection(l10n.fieldNotes),
                  ItemTextInput(
                    _c,
                    ItemTextField.notes,
                    l10n.fieldNotes,
                    lines: 3,
                  ),
                ],
              ),
            ),
    );
  }
}
