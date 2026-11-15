import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

typedef VolumeRange = ({int from, int to, Ownership ownership});

/// Asks for a range of volumes to add to a series.
Future<VolumeRange?> askVolumeRange(
  BuildContext context, {
  required int suggestedTo,
}) => showDialog<VolumeRange>(
  context: context,
  builder: (context) => _VolumeRangeDialog(suggestedTo: suggestedTo),
);

class _VolumeRangeDialog extends StatefulWidget {
  const new({required this.suggestedTo});

  final int suggestedTo;

  @override
  State<_VolumeRangeDialog> createState() => _VolumeRangeDialogState();
}

class _VolumeRangeDialogState extends State<_VolumeRangeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _from = TextEditingController(text: '1');
  late final _to = TextEditingController(text: '${widget.suggestedTo}');
  Ownership _ownership = Ownership.possede;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String? validate(String? v) {
      final n = int.tryParse(v ?? '');
      return n == null || n < 1 ? l10n.invalidNumber : null;
    }

    return AlertDialog(
      title: Text(l10n.addVolumes),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('rangeFrom'),
                    controller: _from,
                    decoration: InputDecoration(labelText: l10n.rangeFrom),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: validate,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    key: const Key('rangeTo'),
                    controller: _to,
                    decoration: InputDecoration(labelText: l10n.rangeTo),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: validate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<Ownership>(
              segments: [
                for (final o in Ownership.values)
                  ButtonSegment(value: o, label: Text(o.label(l10n))),
              ],
              selected: {_ownership},
              onSelectionChanged: (s) => setState(() => _ownership = s.first),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final from = int.parse(_from.text);
            final to = int.parse(_to.text);
            Navigator.pop(context, (
              from: from < to ? from : to,
              to: from < to ? to : from,
              ownership: _ownership,
            ));
          },
          child: Text(l10n.add),
        ),
      ],
    );
  }
}
