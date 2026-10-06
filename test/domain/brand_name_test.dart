import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/brand_name.dart';

void main() {
  test('displayBrandName strips catalogue parentheticals', () {
    expect(displayBrandName('Gallimard Jeunesse (Paris)'), 'Gallimard Jeunesse');
    expect(displayBrandName('Crunchyroll (Paris)'), 'Crunchyroll');
    expect(displayBrandName('Bernard Grasset (Paris)'), 'Bernard Grasset');
    expect(displayBrandName('  Plon  (Paris)  '), 'Plon');
  });

  test('normalizeBrandName folds accents and drops legal forms', () {
    expect(normalizeBrandName('Grasset'), 'grasset');
    expect(normalizeBrandName('Éditions Grasset'), 'grasset');
    expect(normalizeBrandName('Ed. Grasset'), 'grasset');
    expect(normalizeBrandName('Grasset & Fasquelle'), 'grasset fasquelle');
    expect(
      normalizeBrandName('Éditions Grasset & Fasquelle'),
      'grasset fasquelle',
    );
    expect(normalizeBrandName('SAS Éditions Grasset SA'), 'grasset');
    expect(normalizeBrandName('Hachette Livre SA'), 'hachette livre');
    expect(normalizeBrandName('Bernard Grasset (Paris)'), 'bernard grasset');
  });
}
