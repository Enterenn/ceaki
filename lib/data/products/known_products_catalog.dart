import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/product_catalog.dart';

/// Local GTIN → product seeds for codes catalogues miss (games, etc.).
///
/// Tried before Open Food Facts. Keep entries sourced and minimal.
class KnownProductsCatalog implements ProductCatalog {
  const KnownProductsCatalog();

  @override
  Future<BookRecord?> find(String gtin) async => knownProduct(gtin);

  @override
  void close() {}
}

BookRecord? knownProduct(String gtin) {
  return switch (gtin) {
    '3558380078180' => const BookRecord(
      gtin: '3558380078180',
      title: 'Dobble classique',
      creator: null,
      publishers: ['Asmodee'],
      source: 'known',
      category: 'jeu',
    ),
    // Common FR supermarket codes — verified via prior OFF hits / packaging.
    '3068320115257' => const BookRecord(
      gtin: '3068320115257',
      title: 'Evian',
      creator: null,
      publishers: ['Evian', 'Danone'],
      source: 'known',
      category: 'alimentaire',
    ),
    '3017620422006' => const BookRecord(
      gtin: '3017620422006',
      title: 'Nutella',
      creator: null,
      publishers: ['Nutella', 'Ferrero'],
      source: 'known',
      category: 'alimentaire',
    ),
    '4005808819203' => const BookRecord(
      gtin: '4005808819203',
      title: 'Nivea Soft',
      creator: null,
      publishers: ['Nivea'],
      source: 'known',
      category: 'beaute',
    ),
    '3600541226481' => const BookRecord(
      gtin: '3600541226481',
      title: 'Garnier Fructis',
      creator: null,
      publishers: ['Garnier'],
      source: 'known',
      category: 'beaute',
    ),
    '8710847904013' => const BookRecord(
      gtin: '8710847904013',
      title: 'Dove',
      creator: null,
      publishers: ['Dove'],
      source: 'known',
      category: 'beaute',
    ),
    _ => null,
  };
}
