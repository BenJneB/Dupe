import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

typedef LendRequest = ({String borrower, DateTime? dueAt});

/// Asks who borrows [title] and the optional return date. [knownNames]
/// (previous borrowers) are suggested while typing.
Future<LendRequest?> askLend(
  BuildContext context, {
  required String title,
  required List<String> knownNames,
  required DateTime today,
}) => showDialog<LendRequest>(
  context: context,
  builder: (context) =>
      _LendDialog(title: title, knownNames: knownNames, today: today),
);

class _LendDialog extends StatefulWidget {
  const new({
    required this.title,
    required this.knownNames,
    required this.today,
  });

  final String title;
  final List<String> knownNames;
  final DateTime today;

  @override
  State<_LendDialog> createState() => _LendDialogState();
}

class _LendDialogState extends State<_LendDialog> {
  var _borrower = '';
  DateTime? _dueAt;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? widget.today.add(const Duration(days: 30)),
      firstDate: widget.today,
      lastDate: widget.today.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _dueAt = picked);
  }

  void _submit() {
    final name = _borrower.trim();
    if (name.isNotEmpty) {
      Navigator.pop(context, (borrower: name, dueAt: _dueAt));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final due = _dueAt;
    return AlertDialog(
      title: Text(l10n.lendTitle(widget.title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<String>(
            optionsBuilder: (value) {
              final typed = value.text.trim().toLowerCase();
              return typed.isEmpty
                  ? widget.knownNames
                  : widget.knownNames.where(
                      (n) => n.toLowerCase().contains(typed),
                    );
            },
            onSelected: (name) => setState(() => _borrower = name),
            fieldViewBuilder: (context, controller, focus, onSubmit) =>
                TextField(
                  key: const Key('borrowerField'),
                  controller: controller,
                  focusNode: focus,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.borrowerLabel,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _borrower = v),
                  onSubmitted: (_) => onSubmit(),
                ),
          ),
          const SizedBox(height: 12),
          ListTile(
            key: const Key('dueDateTile'),
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.dueDateOptional),
            subtitle: Text(
              due == null
                  ? l10n.noDueDate
                  : Formatters.date(due, l10n.localeName),
            ),
            trailing: due == null
                ? null
                : IconButton(
                    tooltip: l10n.noDueDate,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _dueAt = null),
                  ),
            onTap: _pickDate,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('confirmLend'),
          onPressed: _borrower.trim().isEmpty ? null : _submit,
          child: Text(l10n.lend),
        ),
      ],
    );
  }
}
