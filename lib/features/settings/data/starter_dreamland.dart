import 'package:dupe/features/settings/data/starter_data.dart';

const _firstEdition = 'Première édition';
const _newEdition = 'Nouvelle édition (2022)';

/// Dreamland (Pika), ISBNs from the BnF catalogue (checked 2026-11-14).
/// The owner has the 24 volumes in the first edition, and volumes 1 to 10
/// also in the 2022 edition. Volumes 20+ only exist in one edition.
const _firstEditionIsbns = [
  '9782845995581', '9782845996489', '9782845997127', '9782845997745', //
  '9782845998773', '9782811600167', '9782811601355', '9782811601966', //
  '9782811603366', '9782811604509', '9782811606985', '9782811609283', //
  '9782811612740', '9782811615024', '9782811622756', '9782811623852', //
  '9782811634322', '9782811641290', '9782811646905', '9782811654603', //
  '9782811666729', '9782811681401', '9782811690441', '9791043305214', //
];

const _newEditionIsbns = [
  '9782811666644', '9782811666651', '9782811666668', '9782811666675', //
  '9782811666682', '9782811683399', '9782811684945', '9782811688264', //
  '9782811688271', '9782811688288', //
];

final List<StarterVolume> dreamlandVolumes = [
  for (final (i, isbn) in _firstEditionIsbns.indexed)
    (
      number: '${i + 1}',
      title: null,
      isbn13: isbn,
      edition: i < 19 ? _firstEdition : null,
    ),
  for (final (i, isbn) in _newEditionIsbns.indexed)
    (number: '${i + 1}', title: null, isbn13: isbn, edition: _newEdition),
];
