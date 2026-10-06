import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/notebook_lines.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/application/scan_view.dart';
import 'package:transparence/data/products/bnf_catalog.dart';
import 'package:transparence/data/products/book_record.dart';
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

  test('an offline grasset isbn still opens the banner', () async {
    final book = ScanBook(database: database, catalog: _ThrowingCatalog());
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
    expect(lines.single.label, 'famille Bolloré — 1 produit reposé');
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
      contains('n’aura pas celui-ci'),
    );
  });

  test('a fresh catalogue answer is reused', () async {
    final catalog = _CountingCatalog();
    final book = ScanBook(database: database, catalog: catalog);

    await book.open(gtin, library);
    await book.open(gtin, library);

    expect(catalog.calls, 1);
  });

  test('a plon isbn documents the former owner only', () async {
    final book = ScanBook(database: database, catalog: _ThrowingCatalog());
    final plon = (readGtin('978-2-259-19540-9') as GtinAccepted).gtin;
    final id = await book.open(plon, library);
    final view = describeScan(
      library,
      await database.getScan(id),
      excludedFortuneIds: await database.excludedFortuneIds(),
    );

    expect(view.brandLabel, 'Plon');
    expect(view.title, 'Plus belle sera la vie : roman');
    expect(view.banners, isEmpty);
    expect(view.state, ChainState.currentOwnerUndocumented);
    expect(
      view.chains.single.chain.historical.single.owner.id,
      'company.vivendi-se',
    );
    expect(await book.putBack(id, library), isFalse);
  });

  test(
    'a removed alert hides the banner and keeps a recorded put-back',
    () async {
      final book = ScanBook(database: database, catalog: _ThrowingCatalog());
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
      expect(
        notebookLines(await database.putBacks()).single.label,
        'famille Bolloré — 1 produit reposé',
      );
      final stored = await (database.select(
        database.alertExclusions,
      )..where((row) => row.fortuneId.equals('fortune.bollore'))).getSingle();
      expect(stored.fortuneName, 'famille Bolloré');
      expect(stored.removedAt, removedAt.toLocal());

      final again = await book.open(gtin, library);
      expect(await book.putBack(again, library), isFalse);

      await database.restoreAlert('fortune.bollore');
      expect(await database.excludedFortuneIds(), isEmpty);
    },
  );

  test('a dobble barcode names the shareholders and not a fortune', () async {
    final book = ScanBook(database: database, catalog: _ThrowingCatalog());
    final code = (readGtin('3558380078180') as GtinAccepted).gtin;
    final id = await book.open(code, library);
    final view = describeScan(
      library,
      await database.getScan(id),
      excludedFortuneIds: const {},
    );

    expect(view.category, 'jeu');
    expect(view.title, 'Dobble classique');
    expect(view.brandLabel, 'Asmodee');
    expect(view.banners, isEmpty);
    expect(view.state, ChainState.noDocumentedFortune);
    expect(await book.putBack(id, library), isFalse);
  });
}

class _ThrowingCatalog implements BookCatalog {
  @override
  Future<BookRecord?> find(String gtin) {
    throw StateError('offline');
  }
}

class _CountingCatalog implements BookCatalog {
  var calls = 0;

  @override
  Future<BookRecord?> find(String gtin) async {
    calls++;
    return const BookRecord(
      gtin: '9782246807230',
      title: "La traversée de l'été : roman",
      creator: 'Capote, Truman (1924-1984)',
      publishers: ['Bernard Grasset (Paris)'],
      source: 'bnf',
    );
  }
}
