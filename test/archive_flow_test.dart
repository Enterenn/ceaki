import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/demo_books.dart';
import 'package:transparence/data/products/demo_games.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/domain/archive.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/ui/scanner/scanner_page.dart';
import 'package:transparence/ui/transparence_app.dart';

final _library = Library.parse(
  File('assets/library/library.json').readAsStringSync(),
);

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.memory();
  });

  testWidgets('scanned brands land in the archive with tone labels', (
    tester,
  ) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pumpAndSettle();
      await _submitCode(tester, '978-2-246-80723-0');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await _submitCode(tester, '3558380078180');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Terrain').last);
      await tester.pumpAndSettle();

      expect(find.text('Asmodee'), findsOneWidget);
      expect(find.text('Grasset'), findsOneWidget);
      expect(find.text(archiveFortuneLabel), findsOneWidget);
      expect(find.text(archiveClearLabel), findsOneWidget);

      await tester.tap(find.text('Grasset'));
      await tester.pumpAndSettle();
      expect(find.text(archiveFortuneLabel), findsWidgets);
      expect(find.text('Lagardère SA'), findsOneWidget);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await database.close();
    }
  });
}

Future<void> _submitCode(WidgetTester tester, String code) async {
  if (find.byKey(ScannerPage.codeField).evaluate().isEmpty) {
    final toggle = find.byKey(ScannerPage.manualToggle);
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();
  }
  await tester.enterText(find.byKey(ScannerPage.codeField), code);
  final submit = find.byKey(ScannerPage.submitButton);
  await tester.ensureVisible(submit);
  await tester.tap(submit);
}

Widget _app(AppDatabase database) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) => database),
      bookCatalogProvider.overrideWith((ref) => _FixtureBooks()),
      otherCatalogProvider.overrideWith((ref) => _FixtureOther()),
      capitalLibraryProvider.overrideWith((ref) async => _library),
    ],
    child: const TransparenceApp(),
  );
}

class _FixtureBooks implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async => demoBook(gtin);

  @override
  void close() {}
}

class _FixtureOther implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async => demoGame(gtin);

  @override
  void close() {}
}
