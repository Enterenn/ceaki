import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/domain/brand_name.dart';

class GoogleBooksCatalog implements ProductCatalog {
  GoogleBooksCatalog({http.Client? client})
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
    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', {
      'q': 'isbn:$gtin',
      'maxResults': '1',
    });
    final response = await catalogGet(_client, uri);
    if (response.statusCode == 404 || response.statusCode == 429) {
      return null;
    }
    if (response.statusCode != 200) {
      throw StateError('googlebooks ${response.statusCode}');
    }
    return parseGoogleBooks(response.body, gtin);
  }
}

BookRecord? parseGoogleBooks(String body, String gtin) {
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) return null;
  final items = decoded['items'];
  if (items is! List || items.isEmpty) return null;
  final first = items.first;
  if (first is! Map<String, dynamic>) return null;
  final info = first['volumeInfo'];
  if (info is! Map<String, dynamic>) return null;

  final publisher = displayBrandName((info['publisher'] as String?) ?? '');
  if (publisher.isEmpty) return null;

  final authors = info['authors'];
  String? creator;
  if (authors is List && authors.isNotEmpty) {
    creator = authors.first.toString().trim();
  }

  return BookRecord(
    gtin: gtin,
    title: (info['title'] as String?)?.trim() ?? '',
    creator: creator,
    publishers: [publisher],
    source: 'googlebooks',
  );
}
