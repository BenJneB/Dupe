import 'package:dupe/app/router.dart';
import 'package:dupe/features/account/presentation/sync_status_icon.dart';
import 'package:dupe/features/search/data/voice_input.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Entry point to the global local search, shown at the top of each tab.
class GlobalSearchBar extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Material(
        key: const Key('globalSearchBar'),
        color: theme.colorScheme.surfaceContainerHigh,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => context.push(AppRoutes.search),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).searchHint,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (ref.watch(voiceInputProvider).supported)
                  IconButton(
                    key: const Key('voiceSearchBar'),
                    tooltip: AppLocalizations.of(context).voiceSearchTitle,
                    icon: const Icon(Icons.mic_none),
                    onPressed: () => context.push(AppRoutes.voiceSearch),
                  ),
                const SyncStatusIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
