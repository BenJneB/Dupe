import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Asks up to which volume the series has been read.
Future<int?> askReadUpTo(BuildContext context, {required int suggested}) =>
    showDialog<int>(
      context: context,
      builder: (context) => _MarkReadDialog(suggested: suggested),
    );

class _MarkReadDialog extends StatefulWidget {
  const new({required this.suggested});

  final int suggested;

  @override
  State<_MarkReadDialog> createState() => _MarkReadDialogState();
}

class _MarkReadDialogState extends State<_MarkReadDialog> {
  late final _upTo = TextEditingController(text: '${widget.suggested}');

  @override
  void dispose() {
    _upTo.dispose();
    super.dispose();
  }

  void _submit() {
    final n = int.tryParse(_upTo.text);
    if (n != null && n > 0) Navigator.pop(context, n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.markReadTitle),
      content: TextField(
        key: const Key('readUpToField'),
        controller: _upTo,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: l10n.markReadUpTo,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('confirmMarkRead'),
          onPressed: _submit,
          child: Text(l10n.markReadConfirm),
        ),
      ],
    );
  }
}
