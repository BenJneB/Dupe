// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SuggestionReason _$SuggestionReasonFromJson(Map<String, dynamic> json) =>
    _SuggestionReason(
      kind: $enumDecode(_$SuggestionKindEnumMap, json['kind']),
      key: json['key'] as String,
      label: json['label'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$SuggestionReasonToJson(_SuggestionReason instance) =>
    <String, dynamic>{
      'kind': _$SuggestionKindEnumMap[instance.kind]!,
      'key': instance.key,
      'label': instance.label,
      'count': instance.count,
    };

const _$SuggestionKindEnumMap = {
  SuggestionKind.sameAuthor: 'sameAuthor',
  SuggestionKind.community: 'community',
  SuggestionKind.related: 'related',
};

_Suggestion _$SuggestionFromJson(Map<String, dynamic> json) => _Suggestion(
  key: json['key'] as String,
  type: $enumDecode(_$CollectionTypeEnumMap, json['type']),
  title: json['title'] as String,
  reason: SuggestionReason.fromJson(json['reason'] as Map<String, dynamic>),
  seriesTitle: json['seriesTitle'] as String?,
  altTitles:
      (json['altTitles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  authors:
      (json['authors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  publisher: json['publisher'] as String?,
  isbn13: json['isbn13'] as String?,
  coverUrl: json['coverUrl'] as String?,
  siteUrl: json['siteUrl'] as String?,
  anilistId: json['anilistId'] as String?,
  votes: (json['votes'] as num?)?.toInt() ?? 0,
  score: (json['score'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$SuggestionToJson(_Suggestion instance) =>
    <String, dynamic>{
      'key': instance.key,
      'type': _$CollectionTypeEnumMap[instance.type]!,
      'title': instance.title,
      'reason': instance.reason,
      'seriesTitle': instance.seriesTitle,
      'altTitles': instance.altTitles,
      'authors': instance.authors,
      'publisher': instance.publisher,
      'isbn13': instance.isbn13,
      'coverUrl': instance.coverUrl,
      'siteUrl': instance.siteUrl,
      'anilistId': instance.anilistId,
      'votes': instance.votes,
      'score': instance.score,
    };

const _$CollectionTypeEnumMap = {
  CollectionType.manga: 'manga',
  CollectionType.bd: 'bd',
  CollectionType.comic: 'comic',
  CollectionType.livre: 'livre',
};
