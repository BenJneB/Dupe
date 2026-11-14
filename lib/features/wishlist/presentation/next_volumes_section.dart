import 'package:dupe/app/router.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/wishlist/data/wishlist_repository.dart';
import 'package:dupe/features/wishlist/domain/next_volumes.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Missing volumes of followed series, with a one-tap "add to wishlist".
class NextVolumesSection extends ConsumerWidget {
  const new({super.key});

  Future<void> _wish(
    BuildContext context,
    WidgetRef ref,
    NextVolumes next,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(wishlistRepositoryProvider).wish(next.series, next.numbers);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.missingAddedToWishlist(next.numbers.length))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final next = ref.watch(nextVolumesProvider).value ?? const [];
    if (next.isEmpty) return ListTile(title: Text(l10n.noNextVolumes));
    return Column(
      children: [
        for (final n in next)
          ListTile(
            key: ValueKey('next-${n.series.id}'),
            title: Text(n.series.title),
            subtitle: Text(
              l10n.missingVolumes(
                Formatters.numberList(n.numbers, l10n.rangeWord),
              ),
            ),
            trailing: TextButton(
              key: ValueKey('wishMissing-${n.series.id}'),
              onPressed: () => _wish(context, ref, n),
              child: Text(l10n.addMissingToWishlist),
            ),
            onTap: () =>
                context.push(AppRoutes.series(n.series.type, n.series.id)),
          ),
      ],
    );
  }
}
