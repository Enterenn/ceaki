import 'package:http/http.dart' as http;
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:xml/xml.dart';

class BnfBookCatalog implements ProductCatalog {
  BnfBookCatalog({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  @override
  void close() {
    if (_ownsClient) _client.close();
  }

  @override
  Future<BookRecord?> find(String gtin) async {
    final uri = Uri.https('catalogue.bnf.fr', '/api/SRU', {
      'version': '1.2',
      'operation': 'searchRetrieve',
      'query': 'bib.fuzzyISBN all "$gtin"',
      'recordSchema': 'dublincore',
      'maximumRecords': '5',
    });
    final response = await catalogGet(
      _client,
      uri,
      accept: 'application/xml, text/xml, */*',
    );
    if (response.statusCode != 200) {
      throw StateError('bnf ${response.statusCode}');
    }
    return parseBnfDc(response.body, gtin);
  }
}

BookRecord? parseBnfDc(String body, String gtin) {
  final document = XmlDocument.parse(body);
  for (final record in document.descendantElements) {
    if (record.name.local != 'dc') continue;
    final publishers = <String>[];
    String? title;
    String? creator;
    for (final node in record.childElements) {
      final text = node.innerText.trim();
      if (text.isEmpty) continue;
      switch (node.name.local) {
        case 'publisher':
          final cleaned = displayBrandName(text);
          if (cleaned.isNotEmpty) publishers.add(cleaned);
        case 'title' when title == null:
          title = text.split(' / ').first.trim();
        case 'creator' when creator == null:
          creator = text.split('. ').first.trim();
      }
    }
    if (publishers.isEmpty) continue;
    return BookRecord(
      gtin: gtin,
      title: title ?? '',
      creator: creator,
      publishers: publishers,
      source: 'bnf',
    );
  }
  return null;
}
