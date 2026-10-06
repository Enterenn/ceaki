import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/data/products/bnf_catalog.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/google_books_catalog.dart';
import 'package:transparence/data/products/open_food_facts_catalog.dart';
import 'package:transparence/data/products/open_library_catalog.dart';
import 'package:transparence/data/products/product_catalog.dart';

void main() {
  test('the first BnF notice with a publisher is kept', () {
    const body = '''
<?xml version="1.0" encoding="UTF-8"?>
<srw:searchRetrieveResponse xmlns:srw="http://www.loc.gov/zing/srw/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/">
<srw:records>
<srw:record><srw:recordData><oai_dc:dc>
  <dc:title>Sans éditeur</dc:title>
</oai_dc:dc></srw:recordData></srw:record>
<srw:record><srw:recordData><oai_dc:dc>
  <dc:title>La traversée de l'été : roman / Truman Capote ; traduit</dc:title>
  <dc:creator>Capote, Truman (1924-1984). Auteur du texte</dc:creator>
  <dc:publisher>Bernard Grasset (Paris)</dc:publisher>
</oai_dc:dc></srw:recordData></srw:record>
</srw:records>
</srw:searchRetrieveResponse>
''';

    final book = parseBnfDc(body, '9782246807230');

    expect(book, isNotNull);
    expect(book!.title, "La traversée de l'été : roman");
    expect(book.creator, 'Capote, Truman (1924-1984)');
    expect(book.publishers, ['Bernard Grasset']);
    expect(book.source, 'bnf');
  });

  test('Open Library books API yields title and publishers', () {
    const body = '''
{
  "ISBN:9780140328721": {
    "title": "Fantastic Mr. Fox",
    "authors": [{"name": "Roald Dahl"}],
    "publishers": [{"name": "Puffin"}]
  }
}
''';
    final book = parseOpenLibraryBooks(body, '9780140328721');
    expect(book?.title, 'Fantastic Mr. Fox');
    expect(book?.creator, 'Roald Dahl');
    expect(book?.publishers, ['Puffin']);
    expect(book?.source, 'openlibrary');
  });

  test('Google Books volumes yield publisher', () {
    const body = '''
{
  "items": [{
    "volumeInfo": {
      "title": "Example",
      "authors": ["Ada"],
      "publisher": "Plon (Paris)"
    }
  }]
}
''';
    final book = parseGoogleBooks(body, '9782259195409');
    expect(book?.title, 'Example');
    expect(book?.creator, 'Ada');
    expect(book?.publishers, ['Plon']);
    expect(book?.source, 'googlebooks');
  });

  test('Open Food Facts maps brands and product_type', () {
    const body = '''
{
  "status": 1,
  "product": {
    "product_name": "Nutella",
    "brands": "Nutella, Ferrero",
    "product_type": "food"
  }
}
''';
    final product = parseOpenFoodFacts(body, '3017620422003');
    expect(product?.title, 'Nutella');
    expect(product?.publishers, ['Nutella', 'Ferrero']);
    expect(product?.category, 'alimentaire');
    expect(product?.source, 'openfoodfacts');
  });

  test('cascading catalog skips failures and keeps the first hit', () async {
    final catalog = CascadingCatalog([
      _Throwing(),
      _Fixed(
        const BookRecord(
          gtin: '1',
          title: 'Hit',
          creator: null,
          publishers: ['Grasset'],
          source: 'openlibrary',
        ),
      ),
      _Fixed(
        const BookRecord(
          gtin: '1',
          title: 'Later',
          creator: null,
          publishers: ['Other'],
          source: 'googlebooks',
        ),
      ),
    ]);

    final hit = await catalog.find('1');
    expect(hit?.title, 'Hit');
    expect(hit?.source, 'openlibrary');
  });
}

class _Throwing implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) => throw StateError('down');

  @override
  void close() {}
}

class _Fixed implements ProductCatalog {
  _Fixed(this.record);

  final BookRecord record;

  @override
  Future<BookRecord?> find(String gtin) async => record;

  @override
  void close() {}
}
