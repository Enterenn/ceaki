import 'package:transparence/data/products/book_record.dart';

BookRecord? demoGame(String gtin) {
  return switch (gtin) {
    '3558380078180' => const BookRecord(
      gtin: '3558380078180',
      title: 'Dobble classique',
      creator: null,
      publishers: ['Asmodee'],
      source: 'fixture',
      category: 'jeu',
    ),
    _ => null,
  };
}
