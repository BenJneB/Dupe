import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
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
  final _title = TextEditingController();
  final _originalTitle = TextEditingController();
  final _authors = TextEditingController();
  final _publisher = TextEditingController();
  final _collection = TextEditingController();
  final _total = TextEditingController();
  final _ownedUpTo = TextEditingController();
  final _coverUrl = TextEditingController();
  final _description = TextEditingController();
  final _notes = TextEditingController();
  PublicationStatus _status = PublicationStatus.inconnue;
  var _followed = true;
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
    _title.text = s.title;
    _originalTitle.text = s.originalTitle ?? '';
    _authors.text = s.authors.join(', ');
    _publisher.text = s.publisher ?? '';
    _collection.text = s.collection ?? '';
    _total.text = s.totalVolumes?.toString() ?? '';
    _coverUrl.text = s.coverUrl ?? '';
    _description.text = s.description ?? '';
    _notes.text = s.notes ?? '';
    _status = s.statusPublication;
    _followed = s.followed;
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _originalTitle,
      _authors,
      _publisher,
      _collection,
      _total,
      _ownedUpTo,
      _coverUrl,
      _description,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final original = _original;
    if (original == null || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(collectionRepositoryProvider);
    final series = original.copyWith(
      title: _title.text.trim(),
      originalTitle: textOrNull(_originalTitle),
      authors: Formatters.splitList(_authors.text),
      publisher: textOrNull(_publisher),
      collection: textOrNull(_collection),
      statusPublication: _status,
      totalVolumes: int.tryParse(_total.text),
      followed: _followed,
      coverUrl: textOrNull(_coverUrl),
      description: textOrNull(_description),
      notes: textOrNull(_notes),
    );
    await repo.saveSeries(series);
    final ownedUpTo = int.tryParse(_ownedUpTo.text);
    if (_isNew && ownedUpTo != null && ownedUpTo > 0) {
      await repo.addVolumeRange(series, from: 1, to: ownedUpTo);
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
                  FormText(
                    fieldKey: const Key('titleField'),
                    controller: _title,
                    label: l10n.fieldTitle,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.requiredField
                        : null,
                  ),
                  formGap,
                  FormText(
                    controller: _originalTitle,
                    label: l10n.fieldOriginalTitle,
                  ),
                  formGap,
                  FormText(
                    controller: _authors,
                    label: l10n.fieldAuthors,
                    helper: l10n.commaSeparated,
                  ),
                  formGap,
                  FormText(controller: _publisher, label: l10n.fieldPublisher),
                  formGap,
                  FormText(
                    controller: _collection,
                    label: l10n.fieldCollection,
                  ),
                  formGap,
                  DropdownButtonFormField<PublicationStatus>(
                    isExpanded: true,
                    initialValue: _status,
                    decoration: InputDecoration(
                      labelText: l10n.fieldPublicationStatus,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      for (final s in PublicationStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label(l10n))),
                    ],
                    onChanged: (s) => setState(() => _status = s ?? _status),
                  ),
                  formGap,
                  FormText(
                    fieldKey: const Key('totalField'),
                    controller: _total,
                    label: l10n.fieldTotalVolumes,
                    digitsOnly: true,
                    validator: positive,
                  ),
                  if (_isNew) ...[
                    formGap,
                    FormText(
                      fieldKey: const Key('ownedUpToField'),
                      controller: _ownedUpTo,
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
                    value: _followed,
                    onChanged: (v) => setState(() => _followed = v),
                  ),
                  FormText(
                    controller: _coverUrl,
                    label: l10n.fieldCoverUrl,
                    keyboardType: TextInputType.url,
                  ),
                  formGap,
                  FormText(
                    controller: _description,
                    label: l10n.fieldDescription,
                    maxLines: 5,
                  ),
                  formGap,
                  FormText(
                    controller: _notes,
                    label: l10n.fieldNotes,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
    );
  }
}
