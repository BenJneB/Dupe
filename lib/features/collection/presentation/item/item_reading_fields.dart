import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// "Lecture" section: status, read date, rating.
class ItemReadingFields extends StatelessWidget {
  const new(this.c, {required this.onChanged, required this.today, super.key});

  final ItemFormControllers c;

  /// Read date given when the status becomes "lu" (like the reading bar).
  final DateTime Function() today;

  /// Called after a value of [c] changed, to rebuild the form.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        FormSection(l10n.sectionReading),
        FormDropdown<ReadingStatus>(
          label: l10n.fieldReadingStatus,
          value: c.readingStatus,
          items: {for (final s in ReadingStatus.values) s: s.label(l10n)},
          onChanged: (s) {
            c.readingStatus = s;
            if (s == ReadingStatus.lu) c.readDate ??= today();
            onChanged();
          },
        ),
        formGap,
        FormDate(
          label: l10n.fieldReadDate,
          value: c.readDate,
          format: (d) => Formatters.date(d, l10n.localeName),
          onChanged: (d) {
            c.readDate = d;
            onChanged();
          },
        ),
        formGap,
        FormDropdown<int?>(
          label: l10n.fieldRating,
          value: c.rating,
          items: {null: l10n.none, for (var r = 0; r <= 5; r++) r: '$r/5'},
          onChanged: (r) {
            c.rating = r;
            onChanged();
          },
        ),
      ],
    );
  }
}
