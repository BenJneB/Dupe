import 'package:dupe/features/backup/data/csv_import.dart';
import 'package:dupe/features/backup/domain/import_field.dart';
import 'package:dupe/features/backup/presentation/import_field_labels.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

typedef CsvFile = ({String name, List<List<String>> rows});

/// Column mapping (guessed from the headers, editable), defaults, preview,
/// then import.
class CsvImportScreen extends ConsumerStatefulWidget {
  const new({required this.file, super.key});

  final CsvFile file;

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  late final List<String> _headers = widget.file.rows.first;
  late final List<List<String>> _rows = widget.file.rows.skip(1).toList();
  late final Map<ImportField, int?> _mapping = guessMapping(_headers);
  CollectionType _type = CollectionType.manga;
  Ownership _ownership = Ownership.possede;
  var _busy = false;

  bool get _hasTitle =>
      _mapping[ImportField.title] != null ||
      _mapping[ImportField.series] != null;

  String? _cell(List<String> row, ImportField f) {
    final i = _mapping[f];
    return i == null || i >= row.length || row[i].trim().isEmpty
        ? null
        : row[i].trim();
  }

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final report = await importCsvRows(
      ref.read(collectionRepositoryProvider),
      _rows,
      _mapping,
      (type: _type, ownership: _ownership),
    );
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        content: Text(
          [
            l10n.csvImportDone(
              report.created,
              report.seriesCreated,
              report.duplicates,
            ),
            if (report.invalidLines.isNotEmpty)
              l10n.csvInvalidLines(report.invalidLines.take(10).join(', ')),
          ].join('\n'),
        ),
      ),
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget header(String title) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: text.titleSmall),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.csvImportTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(l10n.csvRows(widget.file.name, _rows.length)),
          header(l10n.csvDefaults),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in CollectionType.values)
                ChoiceChip(
                  key: Key('defaultType-${t.dbValue}'),
                  label: Text(t.label(l10n)),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final o in Ownership.values)
                ChoiceChip(
                  label: Text(o.label(l10n)),
                  selected: _ownership == o,
                  onSelected: (_) => setState(() => _ownership = o),
                ),
            ],
          ),
          header(l10n.csvMapping),
          for (final field in ImportField.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: DropdownButtonFormField<int?>(
                key: Key('mapping-${field.name}'),
                isExpanded: true,
                initialValue: _mapping[field],
                decoration: InputDecoration(
                  labelText: field.label(l10n),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(child: Text(l10n.csvIgnored)),
                  for (final (i, h) in _headers.indexed)
                    DropdownMenuItem(
                      value: i,
                      child: Text(h.isEmpty ? '#${i + 1}' : h),
                    ),
                ],
                onChanged: (i) => setState(() => _mapping[field] = i),
              ),
            ),
          header(l10n.csvPreview),
          for (final row in _rows.take(3))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                [
                  _cell(row, ImportField.series),
                  _cell(row, ImportField.volume),
                  _cell(row, ImportField.title),
                ].nonNulls.join(' · '),
              ),
              subtitle: Text(
                [
                  _cell(row, ImportField.authors),
                  _cell(row, ImportField.publisher),
                  _cell(row, ImportField.isbn),
                ].nonNulls.join(' · '),
              ),
            ),
          if (!_hasTitle)
            Text(
              l10n.csvTitleRequired,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            key: const Key('csvImportButton'),
            icon: const Icon(Icons.upload),
            label: Text(l10n.csvImportButton(_rows.length)),
            onPressed: _busy || !_hasTitle ? null : _import,
          ),
        ),
      ),
    );
  }
}
