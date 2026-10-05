import 'package:transparence/domain/gtin.dart';

enum ProductCategory { livre, alimentaire, hygiene, autre }

final class Product {
  const Product({
    required this.gtin,
    required this.category,
    required this.name,
    required this.brandNames,
  });

  final String gtin;
  final ProductCategory category;
  final String name;
  final List<String> brandNames;
}

ProductCategory? productCategoryFromCode(CodeCategory category) {
  return switch (category) {
    CodeCategory.livre => ProductCategory.livre,
    CodeCategory.autre => ProductCategory.autre,
    CodeCategory.inconnue => null,
  };
}
