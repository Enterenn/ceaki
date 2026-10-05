import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/brand_name.dart';

void main() {
  test('editorial forms and legal suffixes fall on the same key', () {
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
    expect(
      normalizeBrandName('Librairie Arthème Fayard'),
      'librairie artheme fayard',
    );
  });
}
