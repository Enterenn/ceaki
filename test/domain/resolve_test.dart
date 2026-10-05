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
    expect(path[1].votingPercent?.raw, '30.4');
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

  test('editis stays historical and does not alert on bollore', () {
    final chain = resolveBrand(library, editis).chain;
    expect(chain.fortuneIds, isEmpty);
    expect(chain.historical.single.owner.id, 'company.vivendi-se');
    expect(chain.historical.single.status, LinkStatus.historical);
    expect(chainState(chain, const {}), ChainState.currentOwnerUndocumented);
    expect(
      labelFor(ChainState.currentOwnerUndocumented),
      currentOwnerUndocumentedLabel,
    );
  });

  test('a historical link leaves the scan and stays on the fiche', () {
    final raw = File('assets/library/library.json')
        .readAsStringSync()
        .replaceAll('\r\n', '\n')
        .replaceFirst(
          '"linkType": "reference_shareholder",\n'
              '      "factDate": "2025-12-31",\n'
              '      "sourceId": "source.bollore-deu-2025",\n'
              '      "status": "active"',
          '"linkType": "reference_shareholder",\n'
              '      "factDate": "2025-12-31",\n'
              '      "sourceId": "source.bollore-deu-2025",\n'
              '      "status": "historical"',
        );
    final changed = Library.parse(raw);
    expect(resolveBrand(changed, grasset).chain.fortuneIds, isEmpty);
    final fiche = resolveCompany(changed, 'company.louis-hachette-group');
    expect(fiche.fortuneIds, isEmpty);
    expect(fiche.historical.single.owner.id, 'company.bollore-se');
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

  test('a non-book brand uses the same chain', () {
    const brand = Brand(
      id: 'brand.yaourt',
      name: 'Yaourt témoin',
      aliases: [],
      sectors: ['alimentaire'],
      companyId: 'company.lagardere-sa',
    );
    final path = pathToFortune(
      resolveBrand(library, brand).chain,
      'fortune.bollore',
    );
    expect(path[0].capitalPercent?.raw, '66.3');
    expect(path[1].capitalPercent?.raw, '30.4');
  });

  test('a known brand with no fortune is not called a small company', () {
    final parsed = Library.parse(_noFortuneJson);
    final brand = parsed.brands.single;
    final state = chainState(resolveBrand(parsed, brand).chain, const {});
    expect(state, ChainState.noDocumentedFortune);
    final label = labelFor(state).toLowerCase();
    expect(label.contains('petite'), isFalse);
    expect(label.contains('modeste'), isFalse);
    expect(label.contains('indépendant'), isFalse);
    expect(label.contains('independant'), isFalse);
  });

  test('a cycle stops and a ninth hop is cut', () {
    final cycled = resolveBrand(
      Library.parse(_cycleJson),
      _onlyBrand(Library.parse(_cycleJson)),
    );
    expect(cycled.chain.owners.single.above.single.stoppedForCycle, isTrue);

    final deepLibrary = Library.parse(_deepJson);
    final deep = resolveBrand(deepLibrary, _onlyBrand(deepLibrary));
    Holding? last = deep.chain.owners.single;
    while (last!.above.isNotEmpty) {
      last = last.above.single;
    }
    expect(last.owner.id, 'company.c8');
    expect(last.stoppedForDepth, isTrue);
  });
}

Brand _onlyBrand(Library library) => library.brands.single;

const _source = '''
  "sources": [
    {
      "id": "source.test",
      "title": "Jeu de test",
      "url": "https://example.com/jeu-de-test",
      "publisher": "Test"
    }
  ]
''';

final _homonymJson =
    '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition", "alimentaire"],
  $_source,
  "fortunes": [],
  "companies": [
    ${_company('company.edition', 'Edition')},
    ${_company('company.food', 'Food')}
  ],
  "brands": [
    ${_brand('brand.atlas-edition', 'Atlas', 'company.edition', 'edition')},
    ${_brand('brand.atlas-food', 'Atlas', 'company.food', 'alimentaire')}
  ],
  "ownerships": []
}
''';

final _noFortuneJson =
    '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition"],
  $_source,
  "fortunes": [],
  "companies": [
    ${_company('company.holding', 'Holding témoin')},
    ${_company('company.maison', 'Société témoin')}
  ],
  "brands": [
    ${_brand('brand.temoin', 'Marque témoin', 'company.maison', 'edition')}
  ],
  "ownerships": [
    {
      "ownedCompanyId": "company.maison",
      "owner": { "type": "company", "id": "company.holding" },
      "capitalPercent": null,
      "votingPercent": null,
      "linkType": "subsidiary",
      "factDate": "2026-01-01",
      "sourceId": "source.test",
      "status": "active",
      "note": null
    }
  ]
}
''';

final _cycleJson =
    '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition"],
  $_source,
  "fortunes": [],
  "companies": [
    ${_company('company.a', 'A')},
    ${_company('company.b', 'B')}
  ],
  "brands": [
    ${_brand('brand.a', 'A', 'company.a', 'edition')}
  ],
  "ownerships": [
    ${_link('company.a', 'company.b')},
    ${_link('company.b', 'company.a')}
  ]
}
''';

final _deepJson =
    '''
{
  "version": "test",
  "updatedOn": "2026-10-06",
  "sectors": ["edition"],
  $_source,
  "fortunes": [],
  "companies": [
    ${[for (var i = 0; i < 10; i++) _company('company.c$i', 'C$i')].join(',')}
  ],
  "brands": [
    ${_brand('brand.c0', 'C0', 'company.c0', 'edition')}
  ],
  "ownerships": [
    ${[for (var i = 0; i < 9; i++) _link('company.c$i', 'company.c${i + 1}')].join(',')}
  ]
}
''';

String _company(String id, String name) {
  return '''
    {
      "id": "$id",
      "name": "$name",
      "aliases": [],
      "country": "FR",
      "siren": null,
      "role": "holding"
    }
  ''';
}

String _brand(String id, String name, String companyId, String sector) {
  return '''
    {
      "id": "$id",
      "name": "$name",
      "aliases": [],
      "sectors": ["$sector"],
      "companyId": "$companyId"
    }
  ''';
}

String _link(String ownedId, String ownerId) {
  return '''
    {
      "ownedCompanyId": "$ownedId",
      "owner": { "type": "company", "id": "$ownerId" },
      "capitalPercent": null,
      "votingPercent": null,
      "linkType": "control",
      "factDate": "2026-01-01",
      "sourceId": "source.test",
      "status": "active",
      "note": null
    }
  ''';
}
