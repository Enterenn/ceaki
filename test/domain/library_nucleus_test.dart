import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/percent.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );

  test('the nucleus file is coherent', () {
    expect(schemaIssues(library), isEmpty);
  });

  test('percentages stay decimal strings inside 0 and 100', () {
    expect(Percent.parse('30.4', 'capital').french, '30,4');
    expect(Percent.parse('100', 'capital').raw, '100');
    expect(() => Percent.parse('100.1', 'capital'), throwsFormatException);
    expect(() => Percent.parse(30.4, 'capital'), throwsFormatException);
  });

  test('odet is a company and not an alias of the family', () {
    expect(library.company('company.odet').name, "Compagnie de l'Odet");
    final aliases = library.fortune('fortune.bollore').aliases;
    expect(aliases, isNot(contains("Compagnie de l'Odet")));
    expect(aliases, isNot(contains('Odet')));
    expect(aliases, isNot(contains('Bolloré SE')));
  });

  test('three hachette imprints stay three brands', () {
    final ids = library.brands.map((brand) => brand.id).toSet();
    expect(
      ids.containsAll({
        'brand.livre-de-poche',
        'brand.lgf',
        'brand.hachette-livre',
      }),
      isTrue,
    );
  });

  test('grasset aliases resolve to one fiche', () {
    expect(
      library
          .brandsForKey(normalizeBrandName('Éditions Grasset & Fasquelle'))
          .single
          .id,
      'brand.grasset',
    );
    expect(
      library.brandsForKey(normalizeBrandName('Grasset')).single.id,
      'brand.grasset',
    );
    expect(
      library
          .brandsForKey(normalizeBrandName('Librairie Arthème Fayard'))
          .single
          .id,
      'brand.fayard',
    );
  });

  test('no active shortcut skips louis hachette group', () {
    final shortcut = library.ownerships.any(
      (link) =>
          link.status == LinkStatus.active &&
          link.ownedCompanyId == 'company.lagardere-sa' &&
          link.owner.id == 'company.bollore-se',
    );
    expect(shortcut, isFalse);
  });

  test('descent from bollore includes grasset and fayard, not editis', () {
    final portfolio = descendFromFortune(library, 'fortune.bollore');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    final companyIds = portfolio.companies.map((company) => company.id);
    expect(brandIds, containsAll(['brand.grasset', 'brand.fayard']));
    expect(brandIds, isNot(contains('brand.editis')));
    expect(companyIds, contains('company.prisma-media'));
    expect(companyIds, isNot(contains('company.editis')));
    expect(companyIds, isNot(contains('company.odet')));
  });
}
