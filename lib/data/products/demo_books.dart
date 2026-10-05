import 'package:transparence/data/products/book_record.dart';

BookRecord? demoBook(String gtin) {
  return switch (gtin) {
    '9782246807230' => const BookRecord(
      gtin: '9782246807230',
      title: "La traversée de l'été : roman",
      creator: 'Capote, Truman (1924-1984)',
      publishers: ['Bernard Grasset (Paris)'],
      source: 'fixture',
    ),
    _ => null,
  };
}
