// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MetadataResult _$MetadataResultFromJson(Map<String, dynamic> json) =>
    _MetadataResult(
      source: $enumDecode(_$MetadataSourceEnumMap, json['source']),
      sourceId: json['sourceId'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      publisher: json['publisher'] as String?,
      publishDate: json['publishDate'] as String?,
      pageCount: (json['pageCount'] as num?)?.toInt(),
      language: json['language'] as String?,
      isbn13: json['isbn13'] as String?,
      coverUrl: json['coverUrl'] as String?,
      description: json['description'] as String?,
      seriesTitle: json['seriesTitle'] as String?,
      volumeNumber: json['volumeNumber'] as String?,
      coverPrice: (json['coverPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$MetadataResultToJson(_MetadataResult instance) =>
    <String, dynamic>{
      'source': _$MetadataSourceEnumMap[instance.source]!,
      'sourceId': instance.sourceId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'authors': instance.authors,
      'publisher': instance.publisher,
      'publishDate': instance.publishDate,
      'pageCount': instance.pageCount,
      'language': instance.language,
      'isbn13': instance.isbn13,
      'coverUrl': instance.coverUrl,
      'description': instance.description,
      'seriesTitle': instance.seriesTitle,
      'volumeNumber': instance.volumeNumber,
      'coverPrice': instance.coverPrice,
      'currency': instance.currency,
    };

const _$MetadataSourceEnumMap = {
  MetadataSource.bnf: 'bnf',
  MetadataSource.googleBooks: 'googleBooks',
  MetadataSource.openLibrary: 'openLibrary',
  MetadataSource.comicVine: 'comicVine',
};
