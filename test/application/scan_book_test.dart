import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/notebook_lines.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/application/scan_view.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/demo_books.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/notebook.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );
  final gtin = (readGtin('978-2-246-80723-0') as GtinAccepted).gtin;

  late AppDatabase database;

  setUp(() {
    database = AppDatabase.memory();
  });

  tearDown(() => database.close());

  test('a known grasset isbn opens the banner and can be put back', () async {
    final book = ScanBook(
      database: database,
      books: _FixtureBookCatalog(),
      other: _EmptyCatalog(),
    );
    final id = await book.open(gtin, library);
    final view = describeScan(
      library,
      await database.getScan(id),
      excludedFortuneIds: const {},
    );

    expect(view.issue, ScanIssue.resolved);
    expect(view.title, "La traversée de l'été : roman");
    expect(view.banners.single.body, contains('Grasset y est rattaché'));
    expect(view.fortuneNames, ['famille Bolloré']);

    expect(await book.putBack(id, library), isTrue);
    expect(await book.putBack(id, library), isFalse);

    final lines = notebookLines(await database.putBacks());
    expect(lines.single.name, 'famille Bolloré');
    expect(lines.single.count, 1);
    expect(
      describeScan(
        library,
        await database.getScan(id),
        excludedFortuneIds: const {},
      ).choice,
      isNotNull,
    );
    expect(
      putBackLine(
        describeScan(
          library,
          await database.getScan(id),
          excludedFortuneIds: const {},
        ).fortuneNames,
      ),
      "Reposé. la famille Bolloré n'aura pas celui-ci.",
    );
  });

  test('stale cache still resolves when catalogues are offline', () async {
    final book = ScanBook(
      database: database,
      books: _FixtureBookCatalog(),
      other: _EmptyCatalog(),
    );
    await book.open(gtin, library);

    final offline = ScanBook(
      database: database,
      books: _ThrowingCatalog(),
      other: _EmptyCatalog(),
      now: () => DateTime.utc(2026, 11, 10),
    );
    final id = await offline.open(gtin, library);
    final view = describeScan(
      library,
      await database.getScan(id),
      excludedFortuneIds: const {},
    );
    expect(view.issue, ScanIssue.resolved);
    expect(view.title, "La traversée de l'été : roman");
  });

  test('refresh rewrites an offline scan when a source answers', () async {
    final offline = ScanBook(
      database: database,
      books: _ThrowingCatalog(),
      other: _EmptyCatalog(),
    );
    final id = await offline.open(gtin, library);
    expect(
      describeScan(
        library,
        await database.getScan(id),
        excludedFortuneIds: const {},
      ).issue,
      ScanIssue.offline,
    );

    final online = ScanBook(
      database: database,
      books: _FixtureBookCatalog(),
      other: _EmptyCatalog(),
    );
    await online.refresh(id, library);
    final view = describeScan(
      library,
      await database.getScan(id),
      excludedFortuneIds: const {},
    );
    expect(view.issue, ScanIssue.resolved);
    expect(view.title, "La traversée de l'été : roman");
  });

  test('homonym brand choice is remembered for the same GTIN', () async {
    final homonyms = Library.parse(_homonymJson);
    final atlasGtin = (readGtin('3017620422003') as GtinAccepted).gtin;
    final book = ScanBook(
      database: database,
      books: _EmptyCatalog(),
      other: _AtlasCatalog(),
    );

    final first = await book.open(atlasGtin, homonyms);
    final pending = describeScan(
      homonyms,
      await database.getScan(first),
      excludedFortuneIds: const {},
    );
    expect(pending.choices, isNotEmpty);

    await book.chooseBrand(
      scanId: first,
      key: 'atlas',
      brandId: 'brand.atlas-food',
      library: homonyms,
    );

    final second = await book.open(atlasGtin, homonyms);
    final remembered = describeScan(
      homonyms,
      await database.getScan(second),
      excludedFortuneIds: const {},
    );
    expect(remembered.choices, isEmpty);
    expect(remembered.chains.single.brand.id, 'brand.atlas-food');
  });

  test('clearing history removes scans and remembered choices', () async {
    final book = ScanBook(
      database: database,
      books: _FixtureBookCatalog(),
      other: _EmptyCatalog(),
    );
    await book.open(gtin, library);
    await database.rememberGtinChoice(
      gtin: gtin.value,
      choiceKey: 'atlas',
      brandId: 'brand.atlas-food',
    );
    expect(await database.choicesForGtin(gtin.value), isNotEmpty);

    await database.clearScanHistory();
    expect(await database.watchScans().first, isEmpty);
    expect(await database.choicesForGtin(gtin.value), isEmpty);
  });

  test(
    'a removed alert hides the banner and keeps a recorded put-back',
    () async {
      final book = ScanBook(
        database: database,
        books: _FixtureBookCatalog(),
        other: _EmptyCatalog(),
      );
      final id = await book.open(gtin, library);
      expect(await book.putBack(id, library), isTrue);

      final removedAt = DateTime.utc(2026, 10, 6, 12);
      await database.removeAlert(
        fortuneId: 'fortune.bollore',
        fortuneName: 'famille Bolloré',
        removedAt: removedAt,
      );
      final excluded = await database.excludedFortuneIds();
      final kept = describeScan(
        library,
        await database.getScan(id),
        excludedFortuneIds: excluded,
      );
      expect(kept.banners, isEmpty);
      expect(kept.state, ChainState.alertMuted);
      expect(kept.choice, ScanChoice.putBack);
      expect(kept.fortuneNames, ['famille Bolloré']);
      final keptLine = notebookLines(await database.putBacks()).single;
      expect(keptLine.name, 'famille Bolloré');
      expect(keptLine.count, 1);

      final again = await book.open(gtin, library);
      expect(await book.putBack(again, library), isFalse);

      await database.restoreAlert('fortune.bollore');
      expect(await database.excludedFortuneIds(), isEmpty);
    },
  );
}

class _FixtureBookCatalog implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async => demoBook(gtin);

  @override
  void close() {}
}

class _ThrowingCatalog implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) {
    throw StateError('offline');
  }

  @override
  void close() {}
}

class _EmptyCatalog implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async => null;

  @override
  void close() {}
}

class _AtlasCatalog implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async {
    return BookRecord(
      gtin: gtin,
      title: 'Atlas test',
      creator: null,
      publishers: const ['Atlas'],
      source: 'fixture',
      category: 'alimentaire',
    );
  }

  @override
  void close() {}
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
