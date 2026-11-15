import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/stats/data/stats_providers.dart';
import 'package:dupe/features/stats/domain/collection_stats.dart';
import 'package:dupe/features/stats/presentation/monthly_chart.dart';
import 'package:dupe/features/stats/presentation/reading_stats_section.dart';
import 'package:dupe/features/stats/presentation/stat_widgets.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Spending, value, reading and completion statistics.
class StatsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(collectionStatsProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreStats)),
      body: switch (stats) {
        null => const Center(child: CircularProgressIndicator()),
        CollectionStats(ownedCopies: 0) => PlaceholderBody(
          icon: Icons.bar_chart,
          title: l10n.statsEmpty,
        ),
        final s => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: _StatsBody(stats: s),
          ),
        ),
      },
    );
  }
}

class _StatsBody extends StatefulWidget {
  const new({required this.stats});

  final CollectionStats stats;

  @override
  State<_StatsBody> createState() => _StatsBodyState();
}

class _StatsBodyState extends State<_StatsBody> {
  var _table = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = widget.stats;
    final locale = l10n.localeName;
    String money(double v) => Formatters.price(v, s.currency, locale);
    String percent(double v) => '${(v * 100).round()} %';
    final hasSpending = s.spentByMonth.any((m) => m.amount > 0);
    final spending = [
      for (final m in s.spentByMonth) (month: m.month, value: m.amount),
    ];
    final byCount = s.volumesByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final bySpent = s.spentByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = byCount.isEmpty ? 1 : byCount.first.value;
    final maxSpent = bySpent.isEmpty ? 1.0 : bySpent.first.value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        LayoutBuilder(
          builder: (context, box) {
            // Two tiles per row on phones, three in a row on wider screens.
            final width = box.maxWidth < 600
                ? (box.maxWidth - 12) / 2
                : (box.maxWidth - 24) / 3;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                StatTile(
                  key: const Key('statSpent'),
                  width: width,
                  label: l10n.statsSpent,
                  value: money(s.spent),
                  caption: l10n.statsSpentCaption(
                    s.pricedCopies,
                    s.ownedCopies,
                  ),
                ),
                StatTile(
                  key: const Key('statValue'),
                  width: width,
                  label: l10n.statsValue,
                  value: money(s.value),
                  caption: l10n.statsValueCaption,
                ),
                StatTile(
                  key: const Key('statVolumes'),
                  width: width,
                  label: l10n.statsVolumes,
                  value: '${s.ownedVolumes}',
                  caption: l10n.statsVolumesCaption(s.ownedCopies),
                ),
              ],
            );
          },
        ),
        if (s.otherCurrencies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.statsOtherCurrencies(
                [
                  for (final MapEntry(:key, :value)
                      in s.otherCurrencies.entries)
                    Formatters.price(value, key, locale),
                ].join(', '),
              ),
            ),
          ),
        const SizedBox(height: 16),
        BarRow(
          key: const Key('statRead'),
          label: [
            l10n.statsRead,
            l10n.statsRatio(s.readVolumes, s.ownedVolumes),
          ].join(' · '),
          figure: percent(s.readShare),
          fraction: s.readShare,
        ),
        if (s.seriesWithTotal > 0) ...[
          BarRow(
            key: const Key('statComplete'),
            label:
                '${l10n.statsComplete} · '
                '${l10n.statsRatio(s.completeSeries, s.seriesWithTotal)}',
            figure: percent(s.completeSeries / s.seriesWithTotal),
            fraction: s.completeSeries / s.seriesWithTotal,
          ),
          Text(
            l10n.statsCompleteCaption,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        StatSection(
          l10n.statsSpendingByMonth,
          trailing: hasSpending
              ? TextButton(
                  key: const Key('toggleTable'),
                  onPressed: () => setState(() => _table = !_table),
                  child: Text(
                    _table ? l10n.statsShowChart : l10n.statsShowTable,
                  ),
                )
              : null,
        ),
        if (!hasSpending)
          Text(l10n.statsNoSpending)
        else if (_table)
          MonthlyTable(
            months: spending,
            format: money,
            header: l10n.statsAmount,
          )
        else
          MonthlyChart(months: spending, format: money),
        StatSection(l10n.statsVolumesByType),
        for (final MapEntry(:key, :value) in byCount)
          BarRow(
            label: key.label(l10n),
            figure: '$value',
            fraction: value / maxCount,
          ),
        if (bySpent.isNotEmpty) ...[
          StatSection(l10n.statsSpendingByType),
          for (final MapEntry(:key, :value) in bySpent)
            BarRow(
              label: key.label(l10n),
              figure: money(value),
              fraction: value / maxSpent,
            ),
        ],
        const ReadingStatsSection(),
      ],
    );
  }
}
