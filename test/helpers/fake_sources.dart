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

/// Replaces the real sources by a BnF fake answering [result] to any ISBN.
Override fakeMetadataSources({MetadataResult result = duneResult}) =>
    metadataAggregatorProvider.overrideWithValue(
      MetadataAggregator(
        providers: [
          FakeProvider(
            MetadataSource.bnf,
            isbnResult: result,
            textResults: [result],
          ),
        ],
      ),
    );
