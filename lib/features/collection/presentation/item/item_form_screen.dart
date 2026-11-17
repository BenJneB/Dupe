import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/item_drafts.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/features/collection/presentation/item/item_reading_fields.dart';
import 'package:dupe/features/collection/presentation/item/item_signing_fields.dart';
import 'package:dupe/features/collection/presentation/item/item_text_input.dart';
import 'package:dupe/features/collection/presentation/item/previous_volumes_offer.dart';
import 'package:dupe/features/collection/presentation/item/series_attachment_tile.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/series/series_total_actions.dart';
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
    this.copyOf,
    this.popOnSave = false,
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

  /// For a new item: id of a copy of the same volume (another edition).
  final String? copyOf;

  /// Return to the previous screen on save (burst review) instead of
  /// opening the series or the new item.
  final bool popOnSave;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _c = ItemFormControllers();
  Item? _original;
  SeriesAttachment _attachment = SeriesAttachment.none;
  var _saving = false;

  bool get _isNew => widget.itemId == null;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final draft = await loadItemDraft(
      ref.read(collectionRepositoryProvider),
      type: widget.type,
      itemId: widget.itemId,
      seriesId: widget.seriesId,
      volumeNumber: widget.volumeNumber,
      prefill: widget.prefill,
      copyOf: widget.copyOf,
    );
    if (!mounted || draft == null) return;
    setState(() {
      _attachment = draft.attachment;
      _fill(draft.item);
    });
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
    final repo = ref.read(collectionRepositoryProvider);
    final Item item;
    try {
      item = await applyAttachment(repo, _c.applyTo(original), _attachment);
      await repo.saveItem(item);
    } on Object catch (e, stack) {
      if (!mounted) return;
      showError(context, 'collection', e, stack);
      setState(() => _saving = false);
      return;
    }
    if (!mounted) return;
    // First volume of a series without total: how many volumes? (not in
    // the burst review, which saves many volumes in a row).
    if (_isNew && !widget.popOnSave) {
      await offerSeriesTotal(context, ref, item);
      if (!mounted) return;
    }
    if (_isNew) {
      unawaited(
        offerPreviousVolumes(
          ScaffoldMessenger.of(context),
          AppLocalizations.of(context),
          repo,
          item,
        ),
      );
    }
    final seriesId = item.seriesId;
    if (widget.popOnSave) {
      context.pop();
    } else if (widget.prefill != null && seriesId != null) {
      // Scanned volume: show it in its series grid.
      context.pushReplacement(AppRoutes.series(item.type, seriesId));
    } else if (_isNew && seriesId == null) {
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
                  SeriesAttachmentTile(
                    attachment: _attachment,
                    onChanged: (a) => setState(() => _attachment = a),
                  ),
                  ItemGeneralFields(_c, itemId: _original!.id),
                  ItemReadingFields(
                    _c,
                    onChanged: () => setState(() {}),
                    today: ref.read(clockProvider),
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
                  ItemSigningFields(_c, onChanged: () => setState(() {})),
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
