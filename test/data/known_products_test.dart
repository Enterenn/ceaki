import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/data/products/known_products_catalog.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );

  test('dobble seed resolves to asmodee without a fortune', () async {
    final hit = await const KnownProductsCatalog().find('3558380078180');
    expect(hit, isNotNull);
    expect(hit!.publishers, ['Asmodee']);
    expect(hit.category, 'jeu');

    final resolved = resolveBrandNames(library, hit.publishers);
    expect(resolved.chains.single.brand.id, 'brand.asmodee');
    expect(resolved.chains.single.chain.fortuneIds, isEmpty);
  });

  test('evian seed resolves to danone company', () {
    final hit = knownProduct('3068320115257');
    expect(hit, isNotNull);
    final resolved = resolveBrandNames(library, hit!.publishers);
    expect(
      resolved.chains.map((c) => c.brand.id),
      containsAll(['brand.evian', 'brand.danone']),
    );
  });

  test('parenthetical-free names still normalize', () {
    expect(normalizeBrandName('Bernard Grasset (Paris)'), 'bernard grasset');
  });
}
