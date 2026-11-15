import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_metadata.dart';

const duneIsbn = '9782266320481';

const duneResult = MetadataResult(
  source: MetadataSource.bnf,
  sourceId: 'ark:/12148/cb47180638m',
  title: 'Dune',
  authors: ['Frank Herbert'],
  publisher: 'Pocket',
  publishDate: '2022',
  isbn13: duneIsbn,
  coverPrice: 11.95,
  currency: 'EUR',
);

const onePieceT3Isbn = '9782723428774';

/// BnF-like record of a numbered manga volume.
const onePieceT3 = MetadataResult(
  source: MetadataSource.bnf,
  sourceId: 'ark:/op3',
  title: 'One Piece',
  volumeNumber: '3',
  authors: ['Eiichirō Oda'],
  publisher: 'Glénat',
  isbn13: onePieceT3Isbn,
);

const onePieceT4Isbn = '9782723428781';
final MetadataResult onePieceT4 = onePieceT3.copyWith(
  sourceId: 'ark:/op4',
  volumeNumber: '4',
  isbn13: onePieceT4Isbn,
);

/// Replaces the real sources by a BnF fake answering [result] to any ISBN
/// (or [byIsbn] when given: other ISBNs are then unknown), or failing with
/// [error] (offline).
Override fakeMetadataSources({
  MetadataResult result = duneResult,
  Map<String, MetadataResult>? byIsbn,
  Exception? error,
}) => metadataAggregatorProvider.overrideWithValue(
  MetadataAggregator(
    providers: [
      FakeProvider(
        MetadataSource.bnf,
        isbnResult: byIsbn == null ? result : null,
        byIsbn: byIsbn ?? const {},
        textResults: [result],
        error: error,
      ),
    ],
  ),
);
