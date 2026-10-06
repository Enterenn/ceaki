import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );

  test('the grasset banner quotes each sourced figure once', () {
    final chain = resolveBrand(
      library,
      library.brands.firstWhere((brand) => brand.id == 'brand.grasset'),
    );
    final banners = bannersFor(
      library: library,
      chain: chain,
      excludedFortuneIds: const {},
    );

    expect(banners.single.title, 'famille Bolloré');
    final body = banners.single.body;
    expect(body.contains('Grasset y est rattaché'), isTrue);
    expect(body.contains('30,4 % du capital'), isTrue);
    expect(body.contains('des droits de vote'), isFalse);
    expect(body.contains('66,3 % du capital'), isTrue);
    expect(body.contains('31 décembre 2025'), isTrue);
    expect(body.contains('L’achat alimente un groupe lié à cette fortune'), isTrue);
    expect(body.contains('possède'), isFalse);
    expect(body.contains('100'), isFalse);
    expect(
      RegExp(r'\d+(?:,\d+)? %').allMatches(body).map((match) => match.group(0)),
      ['30,4 %', '66,3 %'],
    );
  });
}
