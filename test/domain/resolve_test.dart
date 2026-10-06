import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );
  final grasset = library.brands.firstWhere(
    (brand) => brand.id == 'brand.grasset',
  );
  final editis = library.brands.firstWhere(
    (brand) => brand.id == 'brand.editis',
  );

  test('grasset reaches bollore through the sourced direct links', () {
    final chain = resolveBrand(library, grasset).chain;
    final path = pathToFortune(chain, 'fortune.bollore');

    expect(path[0].owner.id, 'company.louis-hachette-group');
    expect(path[0].capitalPercent?.raw, '66.3');
    expect(path[0].votingPercent, isNull);
    expect(path[0].factDate, '2025-12-31');
    expect(path[0].sourceId, 'source.bollore-deu-2025');

    expect(path[1].owner.id, 'company.bollore-se');
    expect(path[1].capitalPercent?.raw, '30.4');
    // CDC: rights of vote stay empty until a source separates them.
    expect(path[1].votingPercent, isNull);
    expect(path[1].factDate, '2025-12-31');

    expect(path[2].owner.id, 'fortune.bollore');
    expect(path[2].capitalPercent, isNull);
    expect(path[2].votingPercent, isNull);
    expect(path.map((hop) => hop.owner.id), isNot(contains('company.odet')));
    expect(chainState(chain, const {}), ChainState.signaled);
  });

  test('excluding bollore keeps the chain and drops the banner', () {
    final chain = resolveBrand(library, grasset);
    expect(
      chainState(chain.chain, const {'fortune.bollore'}),
      ChainState.alertMuted,
    );
    expect(
      bannersFor(
        library: library,
        chain: chain,
        excludedFortuneIds: const {'fortune.bollore'},
      ),
      isEmpty,
    );
    expect(chain.chain.fortuneIds, ['fortune.bollore']);
  });

  test('editis alerts on kretinsky, not bollore, and keeps vivendi history', () {
    final chain = resolveBrand(library, editis).chain;
    expect(chain.fortuneIds, ['fortune.kretinsky']);
    expect(chain.fortuneIds, isNot(contains('fortune.bollore')));
    expect(chain.historical.single.owner.id, 'company.vivendi-se');
    expect(chain.historical.single.status, LinkStatus.historical);
    expect(chainState(chain, const {}), ChainState.signaled);

    final path = pathToFortune(chain, 'fortune.kretinsky');
    expect(path.map((hop) => hop.owner.id).toList(), [
      'company.imi',
      'company.cmi',
      'fortune.kretinsky',
    ]);
    expect(path.first.capitalPercent?.raw, '100');
  });

  test('garnier reaches bettencourt with tethys figures', () {
    final garnier = library.brands.firstWhere((b) => b.id == 'brand.garnier');
    final chain = resolveBrand(library, garnier).chain;
    expect(chain.fortuneIds, contains('fortune.bettencourt'));
    final path = pathToFortune(chain, 'fortune.bettencourt');
    expect(path.map((hop) => hop.owner.id).take(2).toList(), [
      'company.tethys',
      'fortune.bettencourt',
    ]);
    expect(path.first.capitalPercent?.raw, '28.55');
    expect(path.first.votingPercent?.raw, '28.55');
  });

  test('sephora reaches arnault through christian dior', () {
    final sephora = library.brands.firstWhere((b) => b.id == 'brand.sephora');
    final chain = resolveBrand(library, sephora).chain;
    expect(chain.fortuneIds, ['fortune.arnault']);
    final path = pathToFortune(chain, 'fortune.arnault');
    expect(path.map((hop) => hop.owner.id).toList(), [
      'company.christian-dior-se',
      'company.financiere-agache',
      'company.agache',
      'fortune.arnault',
    ]);
    expect(path.first.capitalPercent?.raw, '42');
    expect(path.first.votingPercent?.raw, '56');
  });

  test('two distinct names give two chains, a homonym gives a choice', () {
    final named = resolveBrandNames(library, const ['Grasset', 'Fayard']);
    expect(named.chains.map((chain) => chain.brand.id), [
      'brand.grasset',
      'brand.fayard',
    ]);
    expect(named.choices, isEmpty);

    final homonyms = Library.parse(_homonymJson);
    final pending = resolveBrandNames(homonyms, const ['Atlas']);
    expect(pending.chains, isEmpty);
    expect(pending.choices.single.brands.map((brand) => brand.id), [
      'brand.atlas-edition',
      'brand.atlas-food',
    ]);

    final chosen = resolveBrandNames(
      homonyms,
      const ['Atlas'],
      chosenIds: const {'atlas': 'brand.atlas-food'},
    );
    expect(chosen.chains.single.brand.id, 'brand.atlas-food');
  });
}

const _homonymJson = '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition", "alimentaire"],
  "sources": [{
    "id": "source.test",
    "title": "Jeu de test",
    "url": "https://example.com/jeu-de-test",
    "publisher": "Test"
  }],
  "fortunes": [],
  "companies": [
    {
      "id": "company.edition",
      "name": "Edition",
      "aliases": [],
      "country": "FR",
      "siren": null,
      "role": "holding"
    },
    {
      "id": "company.food",
      "name": "Food",
      "aliases": [],
      "country": "FR",
      "siren": null,
      "role": "holding"
    }
  ],
  "brands": [
    {
      "id": "brand.atlas-edition",
      "name": "Atlas",
      "aliases": [],
      "sectors": ["edition"],
      "companyId": "company.edition"
    },
    {
      "id": "brand.atlas-food",
      "name": "Atlas",
      "aliases": [],
      "sectors": ["alimentaire"],
      "companyId": "company.food"
    }
  ],
  "ownerships": []
}
''';
