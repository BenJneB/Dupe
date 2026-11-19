import 'dart:async';
import 'dart:math' as math;

import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/collection/domain/series_completion.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/presentation/series_completion/catalog_controls.dart';
import 'package:dupe/features/collection/presentation/series_completion/catalog_volume_row.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Adds or completes a whole series from the BnF (PLAN_V4 phase 37): every
/// volume with its ISBN, without scanning them one by one.
class SeriesCompletionScreen extends ConsumerStatefulWidget {
  const new({required this.type, this.title, this.seriesId, super.key});

  final CollectionType type;
  final String? title;

  /// Series of the collection to complete (its menu).
  final String? seriesId;

  @override
  ConsumerState<SeriesCompletionScreen> createState() => _State();
}

class _State extends ConsumerState<SeriesCompletionScreen> {
  final _query = TextEditingController();
  final _upTo = TextEditingController();
  var _loading = false;
  var _searched = false;
  List<CatalogEdition> _editions = const [];
  var _edition = 0;
  Series? _series;
  List<Item> _existing = const [];
  final _choices = <int, VolumeChoice>{};
  final _records = <int, MetadataResult>{};

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final repo = ref.read(collectionRepositoryProvider);
    final id = widget.seriesId;
    _series = id == null ? null : await repo.getSeries(id);
    if (!mounted) return;
    _query.text = _series?.title ?? widget.title ?? '';
    if (_query.text.isNotEmpty) await _search();
  }

  @override
  void dispose() {
    _query.dispose();
    _upTo.dispose();
    super.dispose();
  }

  CatalogEdition? get _current =>
      _editions.isEmpty ? null : _editions[_edition];

  Future<void> _search() async {
    final title = _query.text.trim();
    if (title.isEmpty) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(collectionRepositoryProvider);
      final records = await ref
          .read(seriesCatalogSourceProvider)
          .volumesOf(title);
      // Opened from a series: its field is locked, the series stays. From
      // the tab: the series of this title, or none (never the previous one).
      if (widget.seriesId == null) {
        _series = await repo.findSeries(widget.type, title);
      }
      final series = _series;
      _existing = series == null
          ? const []
          : await repo.listSeriesItems(series.id);
      _editions = buildCatalog(title, records);
      // The edition of the series' publisher first.
      final publisher = series?.publisher;
      _edition = publisher == null
          ? 0
          : math.max(
              0,
              _editions.indexWhere(
                (e) => publishersMatch(publisher, e.publisher),
              ),
            );
      _reset();
    } on Object catch (e, stack) {
      if (mounted) showError(context, 'series', e, stack);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _searched = true;
        });
      }
    }
  }

  /// Volumes already there are completed; the others are left out until
  /// the user picks them.
  void _reset() {
    _choices.clear();
    _records.clear();
    for (final v in _current?.volumes ?? const <CatalogVolume>[]) {
      _records[v.number] = v.preferred;
      _choices[v.number] =
          volumeState(_existing, v.number) == VolumeState.absent
          ? VolumeChoice.skip
          : VolumeChoice.owned;
    }
  }

  void _ownUpTo(int? last) => setState(() {
    for (final v in _current?.volumes ?? const <CatalogVolume>[]) {
      if (last == null || v.number <= last) {
        _choices[v.number] = VolumeChoice.owned;
      }
    }
  });

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // One save at a time: a double tap would create the series twice.
    setState(() => _loading = true);
    final ({Series series, int updated, int created}) result;
    try {
      result = await completeSeries(
        ref.read(collectionRepositoryProvider),
        type: widget.type,
        title: _series?.title ?? _query.text.trim(),
        series: _series,
        chosen: {
          for (final MapEntry(key: n, value: choice) in _choices.entries)
            n: (record: _records[n]!, choice: choice),
        },
      );
    } on Object catch (e, stack) {
      if (mounted) {
        showError(context, 'series', e, stack);
        setState(() => _loading = false);
      }
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.catalogSaved(result.created, result.updated)),
      ),
    );
    if (!mounted) return;
    if (result.created + result.updated > 0 || _series != null) {
      context.go(AppRoutes.series(widget.type, result.series.id));
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final edition = _current;
    final pending = _choices.entries.where(
      (e) =>
          e.value != VolumeChoice.skip &&
          volumeState(_existing, e.key) != VolumeState.complete,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
        actions: [
          TextButton(
            key: const Key('catalogSave'),
            onPressed: pending.isEmpty || _loading ? null : _save,
            child: Text(l10n.catalogSave(pending.length)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              key: const Key('catalogQuery'),
              controller: _query,
              enabled: widget.seriesId == null,
              decoration: InputDecoration(
                labelText: l10n.catalogQuery,
                helperText: l10n.catalogHelp,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => unawaited(_search()),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => unawaited(_search()),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          if (!ref.read(seriesCatalogSourceProvider).available)
            ListTile(title: Text(l10n.catalogBnfOff)),
          if (_searched && !_loading && edition == null)
            ListTile(title: Text(l10n.catalogNone)),
          if (_editions.length > 1)
            CatalogEditionChips(
              editions: _editions,
              selected: _edition,
              onSelected: (i) => setState(() {
                _edition = i;
                _reset();
              }),
            ),
          if (edition != null)
            CatalogUpToRow(controller: _upTo, onOwnUpTo: _ownUpTo),
          for (final v in edition?.volumes ?? const <CatalogVolume>[])
            CatalogVolumeRow(
              volume: v,
              record: _records[v.number] ?? v.preferred,
              state: volumeState(_existing, v.number),
              choice: _choices[v.number] ?? VolumeChoice.skip,
              onChoice: (c) => setState(() => _choices[v.number] = c),
              onRecord: (r) => setState(() => _records[v.number] = r),
            ),
        ],
      ),
    );
  }
}
