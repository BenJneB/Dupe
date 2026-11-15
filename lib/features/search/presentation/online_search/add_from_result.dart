import 'package:dupe/app/router.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Opens the prefilled add form in the tab of [type].
void addFromResult(
  BuildContext context,
  MetadataResult result,
  CollectionType type, {
  Ownership ownership = Ownership.possede,
}) => context.go(
  AppRoutes.newItem(type),
  extra: (metadata: result, ownership: ownership),
);
