import 'package:dupe/features/scan/presentation/parse_scanned_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an ISBN wins over another barcode of the same frame', () {
    // Book with a second barcode read as UPC-A (recette M-13).
    const upc = '036000291452';
    const isbn = '9782266320481';
    expect(pickScannedCode([upc, isbn]), isbn);
    expect(pickScannedCode([isbn, upc]), isbn);
    // No ISBN: the first code (US comic: the UPC help message).
    expect(pickScannedCode([upc]), upc);
    expect(pickScannedCode(const []), isNull);
  });
}
