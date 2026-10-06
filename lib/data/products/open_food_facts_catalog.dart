import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/domain/brand_name.dart';

class OpenFoodFactsCatalog implements ProductCatalog {
  OpenFoodFactsCatalog({http.Client? client})
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
    final uri = Uri.https('world.openfoodfacts.org', '/api/v2/product/$gtin', {
      'product_type': 'all',
      'fields': 'code,product_name,brands,brands_tags,product_type,categories_tags',
    });
    final response = await catalogGet(_client, uri);
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw StateError('openfoodfacts ${response.statusCode}');
    }
    return parseOpenFoodFacts(response.body, gtin);
  }
}

BookRecord? parseOpenFoodFacts(String body, String gtin) {
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) return null;
  final status = decoded['status'];
  if (status != 1) return null;
  final product = decoded['product'];
  if (product is! Map<String, dynamic>) return null;

  final publishers = _brands(product);
  if (publishers.isEmpty) return null;

  final title = (product['product_name'] as String?)?.trim() ?? '';
  final productType = (product['product_type'] as String?)?.trim();

  return BookRecord(
    gtin: gtin,
    title: title,
    creator: null,
    publishers: publishers,
    source: 'openfoodfacts',
    category: _category(productType),
  );
}

List<String> _brands(Map<String, dynamic> product) {
  final fromField = <String>[];
  final brands = product['brands'];
  if (brands is String) {
    for (final part in brands.split(',')) {
      final cleaned = displayBrandName(part);
      if (cleaned.isNotEmpty && !fromField.contains(cleaned)) {
        fromField.add(cleaned);
      }
    }
  }
  if (fromField.isNotEmpty) return fromField;

  final tags = product['brands_tags'];
  if (tags is List) {
    for (final tag in tags) {
      final raw = tag.toString().replaceFirst(RegExp(r'^[a-z]{2}:'), '');
      final cleaned = displayBrandName(raw.replaceAll('-', ' '));
      if (cleaned.isNotEmpty && !fromField.contains(cleaned)) {
        fromField.add(cleaned);
      }
    }
  }
  return fromField;
}

String _category(String? productType) {
  return switch (productType) {
    'food' => 'alimentaire',
    'beauty' => 'beaute',
    'petfood' => 'animalerie',
    'product' => 'produit',
    _ => 'autre',
  };
}
