import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// A cover photo taken by the user (`dupe-cover:` URL).
class UserCoverImage extends ConsumerWidget {
  const new({required this.name, required this.placeholder, super.key});

  final String name;
  final Widget placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(userCoverFileProvider(name)).value) {
        final file? => Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder,
        ),
        null => placeholder,
      };
}
