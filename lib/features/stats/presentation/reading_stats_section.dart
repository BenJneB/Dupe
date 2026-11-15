import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/stats/data/stats_providers.dart';
import 'package:dupe/features/stats/presentation/monthly_chart.dart';
import 'package:dupe/features/stats/presentation/stat_widgets.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// "Lecture" part of the statistics screen.
class ReadingStatsSection extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ReadingStatsSection> createState() => _State();
}

class _State extends ConsumerState<ReadingStatsSection> {
  var _table = false;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(readingStatsProvider).value;
    if (s == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final muted = text.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    String count(double v) => '${v.round()}';
    final months = [
      for (final m in s.readByMonth) (month: m.month, value: m.count * 1.0),
    ];
    final types = s.byType.entries.toList()
      ..sort((a, b) => b.value.owned.compareTo(a.value.owned));

    return Column(
      key: const Key('readingStats'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatSection(
          l10n.statsReadByMonth,
          trailing: s.hasReadByMonth
              ? TextButton(
                  key: const Key('toggleReadTable'),
                  onPressed: () => setState(() => _table = !_table),
                  child: Text(
                    _table ? l10n.statsShowChart : l10n.statsShowTable,
                  ),
                )
              : null,
        ),
        if (!s.hasReadByMonth)
          Text(l10n.statsNoReadDates)
        else if (_table)
          MonthlyTable(
            months: months,
            format: count,
            header: l10n.statsReadCount,
          )
        else
          MonthlyChart(months: months, format: count, wholeNumbers: true),
        if (s.readWithoutDate > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.statsReadWithoutDate(s.readWithoutDate),
              style: muted,
            ),
          ),
        StatSection(l10n.statsReadByType),
        for (final MapEntry(:key, :value) in types)
          BarRow(
            label:
                '${key.label(l10n)} · '
                '${l10n.statsRatio(value.read, value.owned)}',
            figure: '${(value.read * 100 / value.owned).round()} %',
            fraction: value.read / value.owned,
          ),
        StatSection(l10n.statsPile),
        _Line(
          key: const Key('statPile'),
          title: l10n.statsPileCount(s.toRead),
          detail: switch ((s.oldestToRead, s.oldestToReadSince)) {
            (final item?, final since?) => l10n.statsPileOldest(
              item.volumeNumber == null
                  ? item.title
                  : l10n.volumeTitle(item.title, item.volumeNumber!),
              Formatters.date(since, l10n.localeName),
            ),
            _ => null,
          },
        ),
        _Line(
          key: const Key('statDelay'),
          title: switch (s.averageDaysToRead) {
            final days? => l10n.statsDelay(days.round()),
            null => l10n.statsDelayUnknown,
          },
          detail: s.delaySamples == 0
              ? l10n.statsDelayHelp
              : l10n.statsDelaySamples(s.delaySamples),
        ),
        _Line(
          key: const Key('statAbandoned'),
          title: l10n.statsAbandoned(s.abandonedSeries.length),
          detail: s.abandonedSeries.isEmpty
              ? null
              : s.abandonedSeries.join(', '),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const new({required this.title, this.detail, super.key});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    subtitle: detail == null ? null : Text(detail!),
  );
}
