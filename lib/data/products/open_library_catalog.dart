import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/domain/brand_name.dart';

class OpenLibraryCatalog implements ProductCatalog {
  OpenLibraryCatalog({http.Client? client})
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
    final uri = Uri.https('openlibrary.org', '/api/books', {
      'bibkeys': 'ISBN:$gtin',
      'jscmd': 'data',
      'format': 'json',
    });
    final response = await catalogGet(_client, uri);
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw StateError('openlibrary ${response.statusCode}');
    }
    return parseOpenLibraryBooks(response.body, gtin);
  }
}

BookRecord? parseOpenLibraryBooks(String body, String gtin) {
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) return null;
  final entry = decoded['ISBN:$gtin'];
  if (entry is! Map<String, dynamic>) return null;

  final publishers = <String>[];
  final rawPublishers = entry['publishers'];
  if (rawPublishers is List) {
    for (final item in rawPublishers) {
      final name = switch (item) {
        final String text => text,
        final Map map => map['name']?.toString(),
        _ => null,
      };
      final cleaned = displayBrandName(name ?? '');
      if (cleaned.isNotEmpty) publishers.add(cleaned);
    }
  }
  if (publishers.isEmpty) return null;

  final authors = entry['authors'];
  String? creator;
  if (authors is List && authors.isNotEmpty) {
    final first = authors.first;
    creator = switch (first) {
      final String text => text,
      final Map map => map['name']?.toString(),
      _ => null,
    };
  }

  return BookRecord(
    gtin: gtin,
    title: (entry['title'] as String?)?.trim() ?? '',
    creator: creator?.trim(),
    publishers: publishers,
    source: 'openlibrary',
  );
}
