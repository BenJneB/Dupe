import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('asInt parses plain integers only', () {
    expect(VolumeNumber.asInt('07'), 7);
    expect(VolumeNumber.asInt(' 12 '), 12);
    expect(VolumeNumber.asInt('1.5'), isNull);
    expect(VolumeNumber.asInt('HS 2'), isNull);
    expect(VolumeNumber.asInt(null), isNull);
  });

  test('compare sorts naturally', () {
    final values = ['10', 'Annual 1', '2', null, 'HS 10', '1,5', 'HS 2', '1']
      ..sort(VolumeNumber.compare);
    expect(values, ['1', '1,5', '2', '10', 'Annual 1', 'HS 2', 'HS 10', null]);
  });
}
