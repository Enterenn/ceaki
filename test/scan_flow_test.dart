import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/demo_books.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/data/user/app_database.dart';
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

  testWidgets('a grasset isbn can be put back into the notebook', (
    tester,
  ) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pumpAndSettle();
      await _submitCode(tester, '978-2-246-80723-0');
      await tester.pumpAndSettle();

      expect(find.text('GRANDE FORTUNE'), findsOneWidget);
      expect(find.textContaining('Grasset y est rattaché'), findsOneWidget);
      expect(find.text("La traversée de l'été : roman"), findsOneWidget);

      await tester.tap(find.text('Je le repose'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Reposé.'), findsOneWidget);
      expect(find.text('Je le repose'), findsNothing);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profil').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('1 reposé'), findsOneWidget);
    } finally {
      await _closeApp(tester, database);
    }
  });
}

Future<void> _openManual(WidgetTester tester) async {
  final toggle = find.byKey(ScannerPage.manualToggle);
  await tester.ensureVisible(toggle);
  await tester.tap(toggle);
  await tester.pump();
  expect(find.byKey(ScannerPage.codeField), findsOneWidget);
}

Future<void> _submitCode(WidgetTester tester, String code) async {
  await _openManual(tester);
  await tester.enterText(find.byKey(ScannerPage.codeField), code);
  final submit = find.byKey(ScannerPage.submitButton);
  await tester.ensureVisible(submit);
  await tester.tap(submit);
}

Widget _app(AppDatabase database) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) => database),
      bookCatalogProvider.overrideWith((ref) => _FixtureCatalog()),
      otherCatalogProvider.overrideWith((ref) => _EmptyCatalog()),
      capitalLibraryProvider.overrideWith((ref) async => _library),
    ],
    child: const TransparenceApp(),
  );
}

Future<void> _closeApp(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
  await database.close();
}

class _FixtureCatalog implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async => demoBook(gtin);

  @override
  void close() {}
}

class _EmptyCatalog implements ProductCatalog {
  @override
  Future<BookRecord?> find(String gtin) async => null;

  @override
  void close() {}
}
