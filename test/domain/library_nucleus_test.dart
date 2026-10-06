import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );

  test('the nucleus file is coherent', () {
    expect(schemaIssues(library), isEmpty);
  });

  test('odet is a company and not an alias of the family', () {
    expect(library.company('company.odet').name, "Compagnie de l'Odet");
    final aliases = library.fortune('fortune.bollore').aliases;
    expect(aliases, isNot(contains("Compagnie de l'Odet")));
    expect(aliases, isNot(contains('Odet')));
    expect(aliases, isNot(contains('Bolloré SE')));
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
      library
          .brandsForKey(normalizeBrandName('Bernard Grasset (Paris)'))
          .single
          .id,
      'brand.grasset',
    );
  });

  test('descent from bollore includes grasset and fayard, not editis', () {
    final portfolio = descendFromFortune(library, 'fortune.bollore');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    final companyIds = portfolio.companies.map((company) => company.id);
    expect(brandIds, containsAll(['brand.grasset', 'brand.fayard']));
    expect(brandIds, containsAll(['brand.geo', 'brand.capital']));
    expect(brandIds, isNot(contains('brand.editis')));
    expect(brandIds, isNot(contains('brand.plon')));
    expect(companyIds, isNot(contains('company.editis')));
    expect(companyIds, isNot(contains('company.odet')));
  });

  test('bouygues reaches tf1 and bouygues telecom', () {
    final portfolio = descendFromFortune(library, 'fortune.bouygues');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    expect(brandIds, containsAll(['brand.tf1', 'brand.bouygues-telecom']));
  });

  test('kretinsky reaches editis and plon, not grasset', () {
    final portfolio = descendFromFortune(library, 'fortune.kretinsky');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    expect(brandIds, containsAll(['brand.editis', 'brand.plon', 'brand.pocket']));
    expect(brandIds, isNot(contains('brand.grasset')));
  });

  test('bettencourt reaches garnier and maybelline via loreal', () {
    final portfolio = descendFromFortune(library, 'fortune.bettencourt');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    expect(
      brandIds,
      containsAll(['brand.garnier', 'brand.loreal-paris', 'brand.maybelline']),
    );
    expect(brandIds, isNot(contains('brand.nestle')));
  });

  test('arnault reaches sephora and dior via lvmh, not bollore marques', () {
    final portfolio = descendFromFortune(library, 'fortune.arnault');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    expect(brandIds, containsAll(['brand.sephora', 'brand.dior', 'brand.louis-vuitton']));
    expect(brandIds, isNot(contains('brand.grasset')));
  });

  test('mulliez reaches auchan', () {
    final portfolio = descendFromFortune(library, 'fortune.mulliez');
    final brandIds = portfolio.brands.map((brand) => brand.id);
    expect(brandIds, contains('brand.auchan'));
  });
}
