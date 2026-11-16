import 'package:dupe/features/stats/presentation/chart_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Headline figure with its label and an explanatory caption.
class StatTile extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.caption,
    this.width = 200,
    super.key,
  });

  final double width;
  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.labelLarge?.copyWith(color: muted)),
              const SizedBox(height: 4),
              Text(value, style: text.headlineMedium),
              if (caption case final c?)
                Text(c, style: text.bodySmall?.copyWith(color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}

/// One named row: label, bar and figure; used for meters
/// (against a whole) and ranked bars (against the largest row);
/// `fraction` is the bar length.
class BarRow extends StatelessWidget {
  const new({
    required this.label,
    required this.figure,
    required this.fraction,
    super.key,
  });

  final String label;
  final String figure;

  /// 0..1 length of the bar.
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final colors = chartColors(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: text.bodyMedium)),
              Text(figure, style: text.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              // 0 / 0 (every price paid at 0): an empty bar, not a full one.
              value: fraction.isFinite ? fraction.clamp(0, 1).toDouble() : 0,
              minHeight: 8,
              color: colors.series,
              backgroundColor: colors.track,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title of the statistics screen.
class StatSection extends StatelessWidget {
  const new(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    ),
  );
}
