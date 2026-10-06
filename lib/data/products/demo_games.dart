import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/known_products_catalog.dart';

/// Test helper — delegates to the production known-product seeds.
BookRecord? demoGame(String gtin) => knownProduct(gtin);
