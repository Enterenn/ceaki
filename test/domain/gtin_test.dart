import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/domain/product.dart';

void main() {
  test('isbn 13 becomes a book gtin', () {
    final read = readGtin('ISBN-13: 978-0-306-40615-7');
    expect(read, isA<GtinAccepted>());
    final gtin = (read as GtinAccepted).gtin;
    expect(gtin.value, '9780306406157');
    expect(gtin.codeCategory, CodeCategory.livre);
    expect(productCategoryFromCode(gtin.codeCategory), ProductCategory.livre);
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
}
