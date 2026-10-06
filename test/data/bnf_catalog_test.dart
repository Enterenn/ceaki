import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/data/products/bnf_catalog.dart';

void main() {
  test('the first notice with a publisher is kept', () {
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
}
