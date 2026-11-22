import 'package:dupe/features/covers/domain/cover_image_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Google Books: same volume id whatever the zoom, curl or protocol', () {
    const a =
        'http://books.google.com/books/content?id=Ab1_c&printsec=frontcover'
        '&img=1&zoom=1&edge=curl&source=gbs_api';
    const b =
        'https://books.google.com/books/content?id=Ab1_c&printsec=frontcover'
        '&img=1&zoom=5&source=gbs_api';
    expect(coverImageKey(a), coverImageKey(b));
    expect(
      coverImageKey(a),
      isNot(coverImageKey(b.replaceFirst('Ab1_c', 'Zz9'))),
    );
  });

  test('Open Library: same cover whatever the size', () {
    expect(
      coverImageKey('https://covers.openlibrary.org/b/id/12345-M.jpg'),
      coverImageKey('https://covers.openlibrary.org/b/id/12345-L.jpg'),
    );
    expect(
      coverImageKey(
        'https://covers.openlibrary.org/b/isbn/9782266320481-L.jpg?default=false',
      ),
      'ol:isbn:9782266320481',
    );
    expect(
      coverImageKey('https://covers.openlibrary.org/b/id/1-L.jpg'),
      isNot(coverImageKey('https://covers.openlibrary.org/b/id/2-L.jpg')),
    );
  });

  test('other sources: host and path, without protocol or query', () {
    expect(
      coverImageKey('http://img.example.org/a/cover.jpg?w=200'),
      coverImageKey('https://IMG.example.org/a/cover.jpg'),
    );
  });
}
