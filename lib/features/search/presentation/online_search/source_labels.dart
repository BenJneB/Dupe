import 'package:dupe/core/metadata/metadata_result.dart';

/// Source names are proper nouns, not translated.
extension MetadataSourceLabel on MetadataSource {
  String get label => switch (this) {
    MetadataSource.bnf => 'BnF',
    MetadataSource.googleBooks => 'Google Books',
    MetadataSource.openLibrary => 'Open Library',
    MetadataSource.comicVine => 'Comic Vine',
  };
}
