import 'package:dupe/features/search/domain/french_numbers.dart';
import 'package:flutter/foundation.dart';

/// A dictated search (PLAN_V3 phase 19): a series title and, when one was
/// said, a volume number.
@immutable
class SpokenQuery {
  const new(this.text, {this.volume});

  /// Series title, or the whole phrase when no volume was recognised.
  final String text;

  /// Volume number as digits ("107"), or null.
  final String? volume;

  @override
  bool operator ==(Object other) =>
      other is SpokenQuery && other.text == text && other.volume == volume;

  @override
  int get hashCode => Object.hash(text, volume);

  @override
  String toString() => 'SpokenQuery($text, volume: $volume)';
}

/// Words announcing a volume number.
const _volumeWord = r'(?:tome|num[ée]ro|n°|no\.?|volume|vol\.?)';

RegExp _pattern(String source) => RegExp(source, caseSensitive: false);

/// « One Piece tome 107 », « Astérix numéro 12 », « Naruto volume douze »,
/// « tome 3 de Blacksad », « Blacksad 3 ». Number words are accepted after a
/// volume word; a bare trailing number must be in digits (« Les Trois
/// Mousquetaires » is a title).
SpokenQuery parseSpokenQuery(String phrase) {
  final spoken = phrase.trim().replaceAll(RegExp(r'\s+'), ' ');
  final clean = spoken.replaceAll(RegExp(r'[.,;!?]+$'), '');

  // « tome 3 de Blacksad », « le tome trois d'Astérix »
  final before = _pattern(
    "^(?:le )?$_volumeWord (.+?) (?:de la |des |du |de |d['’])(.+)\$",
  ).firstMatch(clean);
  if (before != null) {
    final number = _number(before[1]!);
    if (number != null) return SpokenQuery(before[2]!.trim(), volume: number);
  }

  // « One Piece tome 107 », « Naruto volume douze »
  final after = _pattern('^(.+?) $_volumeWord (.+)\$').firstMatch(clean);
  if (after != null) {
    final number = _number(after[2]!);
    if (number != null) return SpokenQuery(after[1]!.trim(), volume: number);
  }

  // « Blacksad 3 »
  final trailing = RegExp(r'^(.+?) (\d+)$').firstMatch(clean);
  if (trailing != null) {
    return SpokenQuery(
      trailing[1]!.trim(),
      volume: '${int.parse(trailing[2]!)}',
    );
  }
  return SpokenQuery(clean);
}

/// Digits or number words → digits.
String? _number(String raw) {
  final text = raw.trim();
  if (RegExp(r'^\d+$').hasMatch(text)) return '${int.parse(text)}';
  return parseFrenchNumber(text)?.toString();
}
