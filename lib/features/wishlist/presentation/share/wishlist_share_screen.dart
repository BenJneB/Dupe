import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/wishlist/data/wishlist_repository.dart';
import 'package:dupe/features/wishlist/domain/wish_filter.dart';
import 'package:dupe/features/wishlist/presentation/share/share_covers.dart';
import 'package:dupe/features/wishlist/presentation/share/wishlist_image.dart';
import 'package:dupe/features/wishlist/presentation/share/wishlist_text.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Shares the wishlist as a picture (covers, titles) or as text, after
/// choosing types and priorities (PLAN_V3 phase 20).
class WishlistShareScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<WishlistShareScreen> createState() => _State();
}

class _State extends ConsumerState<WishlistShareScreen> {
  final GlobalKey _picture = GlobalKey();
  var _filter = const WishFilter();
  var _showPrice = false;
  Map<String, ImageProvider>? _covers;
  var _coversRequested = false;

  /// The longest side of the picture, in pixels (messaging apps shrink or
  /// refuse larger ones).
  static const _maxPixels = 8000.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(wishesProvider).value;
    if (all != null && !_coversRequested) {
      _coversRequested = true;
      unawaited(_loadCovers(all));
    }
    final wishes = _filter.apply(all ?? const []);
    final types = [
      for (final t in CollectionType.values)
        if (all?.any((w) => w.type == t) ?? false) t,
    ];
    final ready = _covers != null && wishes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shareWishlist)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final t in types)
                FilterChip(
                  key: Key('shareType_${t.name}'),
                  label: Text(t.label(l10n)),
                  selected: _filter.types.contains(t),
                  onSelected: (on) => setState(
                    () => _filter = WishFilter(
                      types: on
                          ? {..._filter.types, t}
                          : ({..._filter.types}..remove(t)),
                      maxPriority: _filter.maxPriority,
                    ),
                  ),
                ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final max in const [null, 1, 2, 3])
                ChoiceChip(
                  key: Key('sharePriority_$max'),
                  label: Text(
                    max == null
                        ? l10n.sharePriorityAll
                        : l10n.sharePriorityUpTo(max),
                  ),
                  selected: _filter.maxPriority == max,
                  onSelected: (_) => setState(
                    () => _filter = WishFilter(
                      types: _filter.types,
                      maxPriority: max,
                    ),
                  ),
                ),
            ],
          ),
          SwitchListTile(
            key: const Key('sharePriceSwitch'),
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.shareShowPrice),
            value: _showPrice,
            onChanged: (on) => setState(() => _showPrice = on),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                key: const Key('shareImage'),
                icon: const Icon(Icons.image_outlined),
                label: Text(l10n.shareAsImage),
                onPressed: ready ? _shareImage : null,
              ),
              OutlinedButton.icon(
                key: const Key('shareText'),
                icon: const Icon(Icons.notes),
                label: Text(l10n.shareAsText),
                onPressed: wishes.isEmpty ? null : () => _shareText(wishes),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (wishes.isEmpty)
            Text(l10n.shareNoWish)
          else if (_covers == null)
            const Center(child: CircularProgressIndicator())
          else
            // The preview is the picture itself, scaled to the screen.
            FittedBox(
              child: RepaintBoundary(
                key: _picture,
                child: WishlistImage(
                  wishes: wishes,
                  covers: _covers!,
                  showPrice: _showPrice,
                  date: ref.read(clockProvider)(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadCovers(List<Item> all) async {
    final covers = await loadShareCovers(context, ref, all);
    if (mounted) setState(() => _covers = covers);
  }

  Future<void> _shareImage() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final boundary =
        _picture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ratio = math.min(3, _maxPixels / boundary.size.height).toDouble();
    final image = await boundary.toImage(pixelRatio: ratio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (data == null) return;
    final saved = await ref
        .read(fileIoProvider)
        .save(
          l10n.shareFileName,
          data.buffer.asUint8List(),
          mimeType: 'image/png',
        );
    if (saved && defaultTargetPlatform != TargetPlatform.android) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.shareImageSaved)));
    }
  }

  Future<void> _shareText(List<Item> wishes) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final text = wishlistText(l10n, wishes, showPrice: _showPrice);
    final result = await ref
        .read(fileIoProvider)
        .shareText(text, subject: l10n.moreWishlist);
    if (result == TextShare.copied) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.shareTextCopied)));
    }
  }
}
