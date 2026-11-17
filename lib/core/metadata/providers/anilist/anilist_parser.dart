import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/enums.dart';

/// Staff roles kept as authors; assistants and translators are ignored.
final _authorRole = RegExp('story|art|original creator', caseSensitive: false);

List<SeriesMetadata> parseAniListSearch(Map<String, dynamic> json) {
  final page =
      (json['data'] as Map<String, dynamic>?)?['Page'] as Map<String, dynamic>?;
  final media = (page?['media'] as List<dynamic>? ?? [])
      .cast<Map<String, dynamic>>();
  return [for (final m in media) ?parseAniListMedia(m)];
}

/// A manga next to one of the collection (phase 30): a community
/// recommendation (`votes`) or a related work (`relation`).
typedef AniListNeighbour = ({
  SeriesMetadata media,

  /// MANGA or ONE_SHOT (single volume).
  String format,
  List<String> synonyms,
  int votes,
  String? relation,
});

/// The AniList entry found for a series of the collection, with its
/// neighbours.
typedef AniListNeighbours = ({
  SeriesMetadata media,
  List<String> synonyms,
  List<AniListNeighbour> recommendations,
  List<AniListNeighbour> related,
});

/// Formats kept: printed manga (no anime, no light novel).
const _mangaFormats = {'MANGA', 'ONE_SHOT'};

AniListNeighbours? parseAniListNeighbours(Map<String, dynamic> json) {
  final m =
      (json['data'] as Map<String, dynamic>?)?['Media']
          as Map<String, dynamic>?;
  final media = m == null ? null : parseAniListMedia(m);
  if (m == null || media == null) return null;
  AniListNeighbour? neighbour(
    Map<String, dynamic>? node, {
    int votes = 0,
    String? relation,
  }) {
    if (node == null || node['type'] != 'MANGA') return null;
    final format = node['format'] as String?;
    if (!_mangaFormats.contains(format)) return null;
    final parsed = parseAniListMedia(node);
    if (parsed == null) return null;
    return (
      media: parsed,
      format: format!,
      synonyms: _synonyms(node),
      votes: votes,
      relation: relation,
    );
  }

  final recommendations =
      ((m['recommendations'] as Map<String, dynamic>?)?['nodes']
                  as List<dynamic>? ??
              [])
          .cast<Map<String, dynamic>>();
  final relations =
      ((m['relations'] as Map<String, dynamic>?)?['edges'] as List<dynamic>? ??
              [])
          .cast<Map<String, dynamic>>();
  return (
    media: media,
    synonyms: _synonyms(m),
    recommendations: [
      for (final r in recommendations)
        ?neighbour(
          r['mediaRecommendation'] as Map<String, dynamic>?,
          votes: r['rating'] as int? ?? 0,
        ),
    ],
    related: [
      for (final e in relations)
        ?neighbour(
          e['node'] as Map<String, dynamic>?,
          relation: e['relationType'] as String?,
        ),
    ],
  );
}

List<String> _synonyms(Map<String, dynamic> m) => [
  ...?(m['synonyms'] as List<dynamic>?)?.whereType<String>(),
  ...?((m['title'] as Map<String, dynamic>?)?.values.whereType<String>()),
];

SeriesMetadata? parseAniListMedia(Map<String, dynamic> m) {
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
