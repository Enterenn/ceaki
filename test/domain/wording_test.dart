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
    expect(body.contains('30,4 % des droits de vote'), isTrue);
    expect(body.contains('66,3 % du capital'), isTrue);
    expect(body.contains('31 décembre 2025'), isTrue);
    expect(body.contains('L’achat alimente'), isFalse);
    expect(body.contains('possède'), isFalse);
    expect(body.contains('100'), isFalse);
    expect(
      RegExp(r'\d+(?:,\d+)? %').allMatches(body).map((match) => match.group(0)),
      ['30,4 %', '30,4 %', '66,3 %'],
    );
  });

  test('capital alone is not repeated as voting rights', () {
    final parsed = Library.parse(_capitalOnly);
    final chain = resolveBrand(parsed, parsed.brands.single);
    final body = bannersFor(
      library: parsed,
      chain: chain,
      excludedFortuneIds: const {},
    ).single.body;
    expect(body.contains('40 % du capital'), isTrue);
    expect(body.contains('droits de vote'), isFalse);
    expect(body.contains('100'), isFalse);
  });

  test('both bases are shown when the source gives both', () {
    final parsed = Library.parse(_bothBases);
    final body = bannersFor(
      library: parsed,
      chain: resolveBrand(parsed, parsed.brands.single),
      excludedFortuneIds: const {},
    ).single.body;
    expect(body.contains('10 % du capital'), isTrue);
    expect(body.contains('25 % des droits de vote'), isTrue);
  });
}

const _capitalOnly = '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition"],
  "sources": [{
    "id": "source.test",
    "title": "Jeu de test",
    "url": "https://example.com/jeu-de-test",
    "publisher": "Test"
  }],
  "fortunes": [{
    "id": "fortune.temoin",
    "name": "famille Témoin",
    "aliases": ["famille Témoin"],
    "summary": "Fiche de test."
  }],
  "companies": [{
    "id": "company.maison",
    "name": "Maison témoin",
    "aliases": [],
    "country": "FR",
    "siren": null,
    "role": "maison d'édition"
  }],
  "brands": [{
    "id": "brand.temoin",
    "name": "Marque témoin",
    "aliases": [],
    "sectors": ["edition"],
    "companyId": "company.maison"
  }],
  "ownerships": [{
    "ownedCompanyId": "company.maison",
    "owner": { "type": "fortune", "id": "fortune.temoin" },
    "capitalPercent": "40",
    "votingPercent": null,
    "linkType": "stake",
    "factDate": "2026-01-01",
    "sourceId": "source.test",
    "status": "active",
    "note": null
  }]
}
''';

const _bothBases = '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition"],
  "sources": [{
    "id": "source.test",
    "title": "Jeu de test",
    "url": "https://example.com/jeu-de-test",
    "publisher": "Test"
  }],
  "fortunes": [{
    "id": "fortune.temoin",
    "name": "famille Témoin",
    "aliases": ["famille Témoin"],
    "summary": "Fiche de test."
  }],
  "companies": [{
    "id": "company.maison",
    "name": "Maison témoin",
    "aliases": [],
    "country": "FR",
    "siren": null,
    "role": "maison d'édition"
  }],
  "brands": [{
    "id": "brand.temoin",
    "name": "Marque témoin",
    "aliases": [],
    "sectors": ["edition"],
    "companyId": "company.maison"
  }],
  "ownerships": [{
    "ownedCompanyId": "company.maison",
    "owner": { "type": "fortune", "id": "fortune.temoin" },
    "capitalPercent": "10",
    "votingPercent": "25",
    "linkType": "stake",
    "factDate": "2026-01-01",
    "sourceId": "source.test",
    "status": "active",
    "note": null
  }]
}
''';
