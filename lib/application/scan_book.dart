import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_view.dart';
import 'package:transparence/data/products/bnf_catalog.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/demo_books.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/domain/library.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final bookCatalogProvider = Provider<BookCatalog>((ref) {
  final catalog = BnfBookCatalog();
  ref.onDispose(catalog.close);
  return catalog;
});

final scanBookProvider = Provider<ScanBook>((ref) {
  return ScanBook(
    database: ref.watch(appDatabaseProvider),
    catalog: ref.watch(bookCatalogProvider),
  );
});

final scanViewProvider = Provider.autoDispose.family<AsyncValue<ScanView>, int>(
  (ref, id) {
    final library = ref.watch(capitalLibraryProvider);
    final scan = ref.watch(_scanRowProvider(id));
    return library.when(
      loading: () => const AsyncLoading(),
      error: AsyncError.new,
      data: (loaded) => scan.when(
        loading: () => const AsyncLoading(),
        error: AsyncError.new,
        data: (row) => AsyncData(describeScan(loaded, row)),
      ),
    );
  },
);

final _scanRowProvider = StreamProvider.autoDispose.family<Scan, int>((
  ref,
  id,
) {
  return ref.watch(appDatabaseProvider).watchScan(id);
});

class ScanBook {
  ScanBook({
    required this.database,
    required this.catalog,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AppDatabase database;
  final BookCatalog catalog;
  final DateTime Function() _now;

  Future<int> open(Gtin gtin, Library library) async {
    final now = _now();
    if (gtin.codeCategory != CodeCategory.livre) {
      return _store(
        gtin: gtin,
        library: library,
        book: null,
        issue: ScanIssue.notABook,
        now: now,
      );
    }

    final cached = await database.freshProduct(gtin.value, now);
    if (cached != null) {
      return _store(
        gtin: gtin,
        library: library,
        book: BookRecord(
          gtin: cached.gtin,
          title: cached.productName ?? '',
          creator: cached.creator,
          publishers: splitFields(cached.brandNames),
          source: cached.source,
        ),
        issue: ScanIssue.resolved,
        now: now,
      );
    }

    BookRecord? book;
    var offline = false;
    try {
      book = await catalog.find(gtin.value);
    } catch (_) {
      offline = true;
    }
    if (book != null) {
      await database.saveProduct(book, now);
    } else {
      book = demoBook(gtin.value);
    }
    return _store(
      gtin: gtin,
      library: library,
      book: book,
      issue: book == null
          ? (offline ? ScanIssue.offline : ScanIssue.productUnknown)
          : ScanIssue.resolved,
      now: now,
    );
  }

  Future<void> chooseBrand({
    required int scanId,
    required String key,
    required String brandId,
    required Library library,
  }) async {
    final scan = await database.getScan(scanId);
    final chosen = decodeChoices(scan.chosenBrandIds);
    chosen[key] = brandId;
    final attachment = attachmentOf(
      library: library,
      names: splitFields(scan.brandNames),
      chosenIds: chosen,
      issue: ScanIssue.resolved,
    );
    await database.rememberChoice(
      id: scanId,
      chosenBrandIds: encodeChoices(chosen),
      signaledFortuneIds: joinFields(attachment.fortuneIds),
      signaledFortuneNames: joinFields(attachment.fortuneNames),
      issue: attachment.issue.name,
    );
  }

  Future<bool> putBack(int id, Library library) async {
    final view = describeScan(library, await database.getScan(id));
    if (view.fortuneNames.isEmpty) return false;
    return database.putBack(
      id: id,
      fortuneIds: view.fortuneIds,
      fortuneNames: view.fortuneNames,
    );
  }

  Future<bool> buyAnyway(int id) => database.buyAnyway(id);

  Future<int> _store({
    required Gtin gtin,
    required Library library,
    required BookRecord? book,
    required ScanIssue issue,
    required DateTime now,
  }) {
    final names = book?.publishers ?? const <String>[];
    final attachment = attachmentOf(
      library: library,
      names: names,
      chosenIds: const {},
      issue: issue,
    );
    return database.insertScan(
      ScansCompanion.insert(
        scannedAt: now,
        gtin: gtin.value,
        productName: Value(_text(book?.title)),
        creator: Value(_text(book?.creator)),
        category: Value(book == null ? null : 'livre'),
        brandNames: Value(joinFields(names)),
        signaledFortuneIds: Value(joinFields(attachment.fortuneIds)),
        signaledFortuneNames: Value(joinFields(attachment.fortuneNames)),
        libraryVersion: library.version,
        issue: attachment.issue.name,
      ),
    );
  }
}

String? _text(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value.trim();
}
