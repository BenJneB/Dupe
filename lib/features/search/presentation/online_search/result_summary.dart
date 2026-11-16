import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/search/presentation/online_search/source_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

/// "Title – tome 3".
String resultTitle(AppLocalizations l10n, MetadataResult r) =>
    r.volumeNumber == null
    ? r.title
    : l10n.volumeTitle(r.title, r.volumeNumber!);

/// "Authors · Publisher · 2022 · BnF".
String resultSubtitle(
  MetadataResult r, {
  bool withSource = true,
  bool withIsbn = false,
}) => [
  if (r.authors.isNotEmpty) r.authors.join(', '),
  ?r.publisher,
  ?r.publishDate,
  // Tells two editions of the same title apart (text search results).
  if (withIsbn) ?r.isbn13,
  if (withSource) r.source.label,
].join(' · ');
