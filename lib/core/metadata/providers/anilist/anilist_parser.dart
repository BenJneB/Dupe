import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/enums.dart';

/// Staff roles kept as authors; assistants and translators are ignored.
final _authorRole = RegExp('story|art|original creator', caseSensitive: false);

List<SeriesMetadata> parseAniListSearch(Map<String, dynamic> json) {
  final page =
      (json['data'] as Map<String, dynamic>?)?['Page'] as Map<String, dynamic>?;
  final media = (page?['media'] as List<dynamic>? ?? [])
      .cast<Map<String, dynamic>>();
  return [for (final m in media) ?_parseMedia(m)];
}

SeriesMetadata? _parseMedia(Map<String, dynamic> m) {
  final titles = m['title'] as Map<String, dynamic>? ?? const {};
  final title = (titles['english'] ?? titles['romaji']) as String?;
  if (title == null) return null;
  final native = titles['native'] as String?;
  final romaji = titles['romaji'] as String?;

  final edges =
      ((m['staff'] as Map<String, dynamic>?)?['edges'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
  final authors = <String>[];
  for (final edge in edges) {
    final role = edge['role'] as String? ?? '';
    if (role.contains('Former') || !_authorRole.hasMatch(role)) continue;
    final name =
        (((edge['node'] as Map<String, dynamic>)['name']
                    as Map<String, dynamic>)['full']
                as String?)
            ?.trim();
    if (name != null && !authors.contains(name)) authors.add(name);
  }

  return SeriesMetadata(
    source: SeriesSource.anilist,
    sourceId: '${m['id']}',
    title: title,
    originalTitle: native != title ? native : (romaji != title ? romaji : null),
    authors: authors,
    totalVolumes: m['volumes'] as int?,
    status: switch (m['status']) {
      'RELEASING' ||
      'HIATUS' ||
      'NOT_YET_RELEASED' => PublicationStatus.enCours,
      'FINISHED' || 'CANCELLED' => PublicationStatus.terminee,
      _ => PublicationStatus.inconnue,
    },
    startYear: (m['startDate'] as Map<String, dynamic>?)?['year'] as int?,
    coverUrl: (m['coverImage'] as Map<String, dynamic>?)?['large'] as String?,
    description: plainText(m['description'] as String?),
    siteUrl: m['siteUrl'] as String?,
  );
}
