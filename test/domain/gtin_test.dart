import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/domain/product.dart';

void main() {
  test('isbn 10 becomes a book gtin', () {
    final read = readGtin('ISBN 0-306-40615-2');
    expect(read, isA<GtinAccepted>());
    final gtin = (read as GtinAccepted).gtin;
    expect(gtin.value, '9780306406157');
    expect(gtin.codeCategory, CodeCategory.livre);
    expect(productCategoryFromCode(gtin.codeCategory), ProductCategory.livre);
  });

  test('isbn 13 keeps the book category', () {
    final read = readGtin('ISBN-13: 978-0-306-40615-7');
    final gtin = (read as GtinAccepted).gtin;
    expect(gtin.value, '9780306406157');
    expect(gtin.codeCategory, CodeCategory.livre);
  });

  test('a wrong check digit is rejected before any lookup', () {
    final read = readGtin('9780306406158');
    expect(read, isA<GtinRejected>());
    expect((read as GtinRejected).reason, GtinReject.invalidCheck);
  });

  test('9790 is an ismn, not a book', () {
    final read = readGtin('9790123456785');
    final gtin = (read as GtinAccepted).gtin;
    expect(gtin.codeCategory, CodeCategory.autre);
    expect(productCategoryFromCode(gtin.codeCategory), ProductCategory.autre);
  });

  test('979 outside 9790 stays a book', () {
    final read = readGtin('9791234567896');
    expect((read as GtinAccepted).gtin.codeCategory, CodeCategory.livre);
  });

  test('upc-a is stored as ean-13', () {
    final read = readGtin('036000291452');
    final gtin = (read as GtinAccepted).gtin;
    expect(gtin.value, '0036000291452');
    expect(gtin.codeCategory, CodeCategory.inconnue);
  });

  test('ean-8 stays on eight digits', () {
    final read = readGtin('96385074');
    final gtin = (read as GtinAccepted).gtin;
    expect(gtin.value, '96385074');
    expect(gtin.codeCategory, CodeCategory.inconnue);
  });

  test('empty and unknown lengths are rejected', () {
    expect((readGtin('   ') as GtinRejected).reason, GtinReject.empty);
    expect((readGtin('12345') as GtinRejected).reason, GtinReject.unrecognized);
    expect(
      (readGtin('12345678901234') as GtinRejected).reason,
      GtinReject.unrecognized,
    );
  });

  test('a book is a product, not a separate type', () {
    const product = Product(
      gtin: '9780306406157',
      category: ProductCategory.livre,
      name: 'Le titre',
      brandNames: ['Grasset'],
    );
    expect(product.category, ProductCategory.livre);
    expect(product.brandNames, ['Grasset']);
  });
}
