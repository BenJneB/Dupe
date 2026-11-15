import 'package:dupe/features/stats/presentation/chart_colors.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

typedef MonthValue = ({DateTime month, double value});

/// Column chart of a figure per month (spending, volumes read); touch a
/// column for its value. Single series: no legend, the section title names
/// it.
class MonthlyChart extends StatelessWidget {
  const new({
    required this.months,
    required this.format,
    this.wholeNumbers = false,
    super.key,
  });

  final List<MonthValue> months;
  final String Function(double) format;

  /// Counts: no fractional axis labels.
  final bool wholeNumbers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final colors = chartColors(context);
    final maxValue = months.fold<double>(
      0,
      (m, e) => e.value > m ? e.value : m,
    );
    final short = DateFormat.MMM(locale);
    final long = DateFormat.yMMMM(locale);
    final axisStyle = text.labelSmall?.copyWith(color: scheme.onSurfaceVariant);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Narrow screens: one month label out of two.
        final labelEvery = constraints.maxWidth < 480 ? 2 : 1;
        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: maxValue == 0 ? 1 : maxValue * 1.15,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: scheme.outlineVariant, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (value, meta) =>
                        value == meta.max ||
                            (wholeNumbers && value != value.roundToDouble())
                        ? const SizedBox.shrink()
                        : Text(
                            NumberFormat.compact(locale: locale).format(value),
                            style: axisStyle,
                          ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if ((months.length - 1 - i) % labelEvery != 0) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          short.format(months[i].month),
                          style: axisStyle,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipColor: (_) => scheme.inverseSurface,
                  getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                    '${long.format(months[group.x].month)}\n'
                    '${format(rod.toY)}',
                    TextStyle(color: scheme.onInverseSurface),
                  ),
                ),
              ),
              barGroups: [
                for (final (i, m) in months.indexed)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: m.value,
                        width: 14,
                        color: colors.series,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Accessible alternative to the chart.
class MonthlyTable extends StatelessWidget {
  const new({
    required this.months,
    required this.format,
    required this.header,
    super.key,
  });

  final List<MonthValue> months;
  final String Function(double) format;

  /// Title of the value column.
  final String header;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final long = DateFormat.yMMMM(locale);
    return Table(
      columnWidths: const {1: IntrinsicColumnWidth()},
      children: [
        TableRow(
          children: [
            Text(
              l10n.statsMonth,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(header, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        for (final m in months.reversed)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(long.format(m.month)),
              ),
              Text(format(m.value), textAlign: TextAlign.right),
            ],
          ),
      ],
    );
  }
}
