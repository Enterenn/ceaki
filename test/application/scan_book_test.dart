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
      'Reposé. famille Bolloré — celui-ci reste en rayon.',
    );
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

class _ThrowingCatalog implements BookCatalog {
  @override
  Future<BookRecord?> find(String gtin) {
    throw StateError('offline');
  }
}
