import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_view.dart';
import 'package:transparence/data/products/bnf_catalog.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/products/google_books_catalog.dart';
import 'package:transparence/data/products/open_food_facts_catalog.dart';
import 'package:transparence/data/products/open_library_catalog.dart';
import 'package:transparence/data/products/product_catalog.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/domain/library.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

/// Book cascade: BnF → Open Library → Google Books.
final bookCatalogProvider = Provider<ProductCatalog>((ref) {
  final client = http.Client();
  final catalog = CascadingCatalog([
    BnfBookCatalog(client: client),
    OpenLibraryCatalog(client: client),
    GoogleBooksCatalog(client: client),
  ]);
  ref.onDispose(() {
    catalog.close();
    client.close();
  });
  return catalog;
});

/// Non-book products via Open Food Facts (`product_type=all`).
final otherCatalogProvider = Provider<ProductCatalog>((ref) {
  final catalog = OpenFoodFactsCatalog();
  ref.onDispose(catalog.close);
  return catalog;
});

final scanBookProvider = Provider<ScanBook>((ref) {
  return ScanBook(
    database: ref.watch(appDatabaseProvider),
    books: ref.watch(bookCatalogProvider),
    other: ref.watch(otherCatalogProvider),
  );
});

final excludedFortuneIdsProvider = StreamProvider<Set<String>>((ref) {
  return ref.watch(appDatabaseProvider).watchExcludedFortuneIds();
});

final scanViewProvider = Provider.autoDispose.family<AsyncValue<ScanView>, int>(
  (ref, id) {
    final library = ref.watch(capitalLibraryProvider);
    final scan = ref.watch(_scanRowProvider(id));
    final excluded = ref.watch(excludedFortuneIdsProvider);
    if (library.isLoading || scan.isLoading || excluded.isLoading) {
      return const AsyncLoading();
    }
    if (library.hasError) {
      return AsyncError(library.error!, library.stackTrace!);
    }
    if (scan.hasError) return AsyncError(scan.error!, scan.stackTrace!);
    if (excluded.hasError) {
      return AsyncError(excluded.error!, excluded.stackTrace!);
    }
    return AsyncData(
      describeScan(
        library.requireValue,
        scan.requireValue,
        excludedFortuneIds: excluded.requireValue,
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
    required this.books,
    required this.other,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AppDatabase database;
  final ProductCatalog books;
  final ProductCatalog other;
  final DateTime Function() _now;

  Future<int> open(Gtin gtin, Library library, {bool bypassCache = false}) async {
    final now = _now();
    final excluded = await database.excludedFortuneIds();
    final remembered = await database.choicesForGtin(gtin.value);
    final catalog = _catalogFor(gtin);

    if (!bypassCache) {
      final cached = await database.freshProduct(gtin.value, now);
      if (cached != null) {
        return _store(
          gtin: gtin,
          library: library,
          book: _fromCache(cached),
          issue: ScanIssue.resolved,
          excludedFortuneIds: excluded,
          chosenIds: remembered,
          now: now,
        );
      }
    }

    BookRecord? book;
    var offline = false;
    try {
      book = await catalog.find(gtin.value);
    } catch (_) {
      offline = true;
      if (!bypassCache) {
        final stale = await database.cachedProduct(gtin.value);
        if (stale != null) {
          return _store(
            gtin: gtin,
            library: library,
            book: _fromCache(stale),
            issue: ScanIssue.resolved,
            excludedFortuneIds: excluded,
            chosenIds: remembered,
            now: now,
          );
        }
      }
    }
    if (book != null) {
      await database.saveProduct(book, now);
    }
    return _store(
      gtin: gtin,
      library: library,
      book: book,
      issue: book == null
          ? (offline ? ScanIssue.offline : ScanIssue.productUnknown)
          : ScanIssue.resolved,
      excludedFortuneIds: excluded,
      chosenIds: remembered,
      now: now,
    );
  }

  /// Re-query catalogues and rewrite the existing scan row (pull-to-refresh).
  Future<void> refresh(int scanId, Library library) async {
    final scan = await database.getScan(scanId);
    final read = readGtin(scan.gtin);
    if (read is! GtinAccepted) return;
    final now = _now();
    final excluded = await database.excludedFortuneIds();
    await database.evictProduct(read.gtin.value);

    BookRecord? book;
    var offline = false;
    try {
      book = await _catalogFor(read.gtin).find(read.gtin.value);
    } catch (_) {
      offline = true;
    }
    if (book != null) {
      await database.saveProduct(book, now);
    }
    final names = book?.publishers ?? const <String>[];
    final attachment = attachmentOf(
      library: library,
      names: names,
      chosenIds: decodeChoices(scan.chosenBrandIds),
      issue: book == null
          ? (offline ? ScanIssue.offline : ScanIssue.productUnknown)
          : ScanIssue.resolved,
      excludedFortuneIds: excluded,
    );
    await database.updateScanProduct(
      id: scanId,
      productName: _text(book?.title),
      creator: _text(book?.creator),
      category: book?.category,
      brandNames: joinFields(names),
      signaledFortuneIds: joinFields(attachment.fortuneIds),
      signaledFortuneNames: joinFields(attachment.fortuneNames),
      issue: attachment.issue.name,
    );
  }

  Future<void> chooseBrand({
    required int scanId,
    required String key,
    required String brandId,
    required Library library,
  }) async {
    final scan = await database.getScan(scanId);
    final chosen = Map<String, String>.of(decodeChoices(scan.chosenBrandIds));
    chosen[key] = brandId;
    await database.rememberGtinChoice(
      gtin: scan.gtin,
      choiceKey: key,
      brandId: brandId,
    );
    final attachment = attachmentOf(
      library: library,
      names: splitFields(scan.brandNames),
      chosenIds: chosen,
      issue: ScanIssue.resolved,
      excludedFortuneIds: await database.excludedFortuneIds(),
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
    final view = describeScan(
      library,
      await database.getScan(id),
      excludedFortuneIds: await database.excludedFortuneIds(),
    );
    if (view.fortuneNames.isEmpty) return false;
    return database.putBack(
      id: id,
      fortuneIds: view.fortuneIds,
      fortuneNames: view.fortuneNames,
    );
  }

  Future<bool> buyAnyway(int id) => database.buyAnyway(id);

  ProductCatalog _catalogFor(Gtin gtin) {
    return gtin.codeCategory == CodeCategory.livre ? books : other;
  }

  BookRecord _fromCache(ProductCacheEntry cached) {
    return BookRecord(
      gtin: cached.gtin,
      title: cached.productName ?? '',
      creator: cached.creator,
      publishers: splitFields(cached.brandNames),
      source: cached.source,
      category: cached.category,
    );
  }

  Future<int> _store({
    required Gtin gtin,
    required Library library,
    required BookRecord? book,
    required ScanIssue issue,
    required Set<String> excludedFortuneIds,
    required Map<String, String> chosenIds,
    required DateTime now,
  }) {
    final names = book?.publishers ?? const <String>[];
    final attachment = attachmentOf(
      library: library,
      names: names,
      chosenIds: chosenIds,
      issue: issue,
      excludedFortuneIds: excludedFortuneIds,
    );
    return database.insertScan(
      ScansCompanion.insert(
        scannedAt: now,
        gtin: gtin.value,
        productName: Value(_text(book?.title)),
        creator: Value(_text(book?.creator)),
        category: Value(book?.category),
        brandNames: Value(joinFields(names)),
        signaledFortuneIds: Value(joinFields(attachment.fortuneIds)),
        signaledFortuneNames: Value(joinFields(attachment.fortuneNames)),
        libraryVersion: library.version,
        issue: attachment.issue.name,
        chosenBrandIds: Value(encodeChoices(chosenIds)),
      ),
    );
  }
}

String? _text(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value.trim();
}
