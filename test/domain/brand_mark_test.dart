import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/ui/brand/brand_mark.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );

  test('core brands ship geometric monogram assets', () {
    final grasset = library.brands.firstWhere((b) => b.id == 'brand.grasset');
    expect(grasset.logoAsset, 'assets/logos/grasset.png');
    expect(grasset.logoSource, contains('Monogramme Céaki'));
    expect(File(grasset.logoAsset!).existsSync(), isTrue);

    for (final id in [
      'brand.fayard',
      'brand.asmodee',
      'brand.free',
      'brand.dobble',
      'brand.plon',
    ]) {
      final brand = library.brands.firstWhere((b) => b.id == id);
      expect(brand.logoAsset, isNotNull);
      expect(File(brand.logoAsset!).existsSync(), isTrue);
    }
  });

  test('brand initials stay short and uppercase', () {
    expect(brandInitials('Grasset'), 'G');
    expect(brandInitials('JC Lattès'), 'JL');
    expect(brandInitials('  '), '?');
  });
}
