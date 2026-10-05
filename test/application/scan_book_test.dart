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
    final view = describeScan(library, await database.getScan(id));

    expect(view.issue, ScanIssue.resolved);
    expect(view.title, "La traversée de l'été : roman");
    expect(view.banners.single.body, contains('Grasset y est rattaché'));
    expect(view.fortuneNames, ['famille Bolloré']);

    expect(await book.putBack(id, library), isTrue);
    expect(await book.putBack(id, library), isFalse);

    final lines = notebookLines(await database.putBacks());
    expect(lines.single.label, 'famille Bolloré — 1 produit reposé');
    expect(describeScan(library, await database.getScan(id)).choice, isNotNull);
    expect(
      putBackLine(
        describeScan(library, await database.getScan(id)).fortuneNames,
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
