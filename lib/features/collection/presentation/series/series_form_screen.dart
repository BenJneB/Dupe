import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/providers/series_lookup_provider.dart';
import 'package:dupe/features/collection/presentation/series/series_form_controllers.dart';
import 'package:dupe/features/collection/presentation/series/series_lookup_sheet.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Create or edit a series (or a book cycle).
class SeriesFormScreen extends ConsumerStatefulWidget {
  const new({required this.type, this.seriesId, super.key});

  final CollectionType type;

  /// Null to create a new series.
  final String? seriesId;

  @override
  ConsumerState<SeriesFormScreen> createState() => _SeriesFormScreenState();
}

class _SeriesFormScreenState extends ConsumerState<SeriesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _c = SeriesFormControllers();
  Series? _original;
  var _saving = false;

  bool get _isNew => widget.seriesId == null;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(collectionRepositoryProvider);
    if (_isNew) {
      _original = repo.newSeries(widget.type);
    } else {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    final repo = ref.read(collectionRepositoryProvider);
    final s = await repo.getSeries(widget.seriesId!);
    if (!mounted || s == null) return;
    setState(() => _fill(s));
  }

  void _fill(Series s) {
    _original = s;
    _c.fill(s);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _completeFromOnline() async {
    final m = await showSeriesLookup(
      context,
      type: widget.type,
      initialQuery: _c.title.text,
    );
    if (m != null && mounted) setState(() => _c.complete(m));
  }

  Future<void> _save() async {
    final original = _original;
    if (original == null || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(collectionRepositoryProvider);
    final series = _c.applyTo(original);
    final ownedUpTo = int.tryParse(_c.ownedUpTo.text);
    try {
      await repo.inTransaction(() async {
        await repo.saveSeries(series);
        if (_isNew && ownedUpTo != null && ownedUpTo > 0) {
          await repo.addVolumeRange(series, from: 1, to: ownedUpTo);
        }
      });
    } on Object catch (e, stack) {
      if (!mounted) return;
      showError(context, 'collection', e, stack);
      setState(() => _saving = false);
      return;
    }
    if (!mounted) return;
    if (_isNew) {
      context.pushReplacement(AppRoutes.series(series.type, series.id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loaded = _original != null;
    final lookupSource = ref
        .watch(seriesLookupProvider)
        .providerFor(widget.type)
        ?.seriesSource;
    String? positive(String? v) {
      if (v == null || v.isEmpty) return null;
      final n = int.tryParse(v);
      return n == null || n < 1 ? l10n.invalidNumber : null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNew ? widget.type.newSeriesLabel(l10n) : l10n.editSeries,
        ),
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
                  if (lookupSource != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton.icon(
                        key: const Key('completeFromOnline'),
                        icon: const Icon(Icons.travel_explore),
                        label: Text(l10n.completeFrom(lookupSource.label)),
                        onPressed: _completeFromOnline,
                      ),
                    ),
                  FormText(
                    fieldKey: const Key('titleField'),
                    controller: _c.title,
                    label: l10n.fieldTitle,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.requiredField
                        : null,
                  ),
                  formGap,
                  FormText(
                    controller: _c.originalTitle,
                    label: l10n.fieldOriginalTitle,
                  ),
                  formGap,
                  FormText(
                    controller: _c.authors,
                    label: l10n.fieldAuthors,
                    helper: l10n.commaSeparated,
                  ),
                  formGap,
                  FormText(
                    controller: _c.publisher,
                    label: l10n.fieldPublisher,
                  ),
                  formGap,
                  FormText(
                    controller: _c.collection,
                    label: l10n.fieldCollection,
                  ),
                  formGap,
                  DropdownButtonFormField<PublicationStatus>(
                    isExpanded: true,
                    initialValue: _c.status,
                    decoration: InputDecoration(
                      labelText: l10n.fieldPublicationStatus,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      for (final s in PublicationStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label(l10n))),
                    ],
                    onChanged: (s) =>
                        setState(() => _c.status = s ?? _c.status),
                  ),
                  formGap,
                  FormText(
                    fieldKey: const Key('totalField'),
                    controller: _c.total,
                    label: l10n.fieldTotalVolumes,
                    digitsOnly: true,
                    validator: positive,
                  ),
                  if (_isNew) ...[
                    formGap,
                    FormText(
                      fieldKey: const Key('ownedUpToField'),
                      controller: _c.ownedUpTo,
                      label: l10n.fieldOwnedUpTo,
                      helper: l10n.fieldOwnedUpToHelper,
                      digitsOnly: true,
                      validator: positive,
                    ),
                  ],
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldFollowed),
                    subtitle: Text(l10n.fieldFollowedHelper),
                    value: _c.followed,
                    onChanged: (v) => setState(() => _c.followed = v),
                  ),
                  FormText(
                    controller: _c.coverUrl,
                    label: l10n.fieldCoverUrl,
                    keyboardType: TextInputType.url,
                  ),
                  formGap,
                  FormText(
                    controller: _c.description,
                    label: l10n.fieldDescription,
                    maxLines: 5,
                  ),
                  formGap,
                  FormText(
                    controller: _c.notes,
                    label: l10n.fieldNotes,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
    );
  }
}
