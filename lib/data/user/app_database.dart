import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/user/stored_fields.dart';

part 'app_database.g.dart';

const productCacheFor = Duration(days: 30);

class Scans extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get scannedAt => dateTime()();
  TextColumn get gtin => text()();
  TextColumn get productName => text().nullable()();
  TextColumn get creator => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get brandNames => text().withDefault(const Constant(''))();
  TextColumn get signaledFortuneIds => text().withDefault(const Constant(''))();
  TextColumn get signaledFortuneNames =>
      text().withDefault(const Constant(''))();
  TextColumn get libraryVersion => text()();
  TextColumn get choice => text().nullable()();
  TextColumn get issue => text()();
  TextColumn get chosenBrandIds => text().withDefault(const Constant(''))();
}

class ProductCacheEntries extends Table {
  @override
  String get tableName => 'product_cache';

  TextColumn get gtin => text()();
  TextColumn get productName => text().nullable()();
  TextColumn get creator => text().nullable()();
  TextColumn get category => text()();
  TextColumn get brandNames => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text()();

  @override
  Set<Column<Object>> get primaryKey => {gtin};
}

class AlertExclusions extends Table {
  TextColumn get fortuneId => text()();
  TextColumn get fortuneName => text()();
  DateTimeColumn get removedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {fortuneId};
}

@DriftDatabase(tables: [Scans, ProductCacheEntries, AlertExclusions])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'transparence'));

  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(alertExclusions);
    },
  );

  Future<ProductCacheEntry?> freshProduct(String gtin, DateTime now) async {
    final row = await cachedProduct(gtin);
    if (row == null) return null;
    final age = now.difference(row.fetchedAt);
    if (age.isNegative || age >= productCacheFor) return null;
    return row;
  }

  Future<ProductCacheEntry?> cachedProduct(String gtin) {
    return (select(
      productCacheEntries,
    )..where((entry) => entry.gtin.equals(gtin))).getSingleOrNull();
  }

  Future<void> evictProduct(String gtin) {
    return (delete(
      productCacheEntries,
    )..where((entry) => entry.gtin.equals(gtin))).go();
  }

  Future<void> saveProduct(BookRecord book, DateTime fetchedAt) {
    return into(productCacheEntries).insertOnConflictUpdate(
      ProductCacheEntriesCompanion.insert(
        gtin: book.gtin,
        productName: Value(book.title),
        creator: Value(book.creator),
        category: book.category,
        brandNames: joinFields(book.publishers),
        fetchedAt: fetchedAt,
        source: book.source,
      ),
    );
  }

  Future<void> updateScanProduct({
    required int id,
    required String? productName,
    required String? creator,
    required String? category,
    required String brandNames,
    required String signaledFortuneIds,
    required String signaledFortuneNames,
    required String issue,
  }) {
    return (update(scans)..where((row) => row.id.equals(id))).write(
      ScansCompanion(
        productName: Value(productName),
        creator: Value(creator),
        category: Value(category),
        brandNames: Value(brandNames),
        signaledFortuneIds: Value(signaledFortuneIds),
        signaledFortuneNames: Value(signaledFortuneNames),
        issue: Value(issue),
      ),
    );
  }

  Future<int> insertScan(ScansCompanion row) => into(scans).insert(row);

  Future<Scan> getScan(int id) {
    return (select(scans)..where((row) => row.id.equals(id))).getSingle();
  }

  Stream<Scan> watchScan(int id) {
    return (select(scans)..where((row) => row.id.equals(id))).watchSingle();
  }

  Stream<List<Scan>> watchScans() {
    return (select(scans)
          ..orderBy([(row) => OrderingTerm.desc(row.scannedAt)]))
        .watch();
  }

  Stream<List<Scan>> watchPutBacks() {
    return (select(scans)
          ..where((row) => row.choice.equals('put_back'))
          ..orderBy([(row) => OrderingTerm.desc(row.scannedAt)]))
        .watch();
  }

  Future<List<Scan>> putBacks() {
    return (select(scans)..where((row) => row.choice.equals('put_back'))).get();
  }

  Future<bool> putBack({
    required int id,
    required List<String> fortuneIds,
    required List<String> fortuneNames,
  }) async {
    final updated =
        await (update(
          scans,
        )..where((row) => row.id.equals(id) & row.choice.isNull())).write(
          ScansCompanion(
            choice: const Value('put_back'),
            signaledFortuneIds: Value(joinFields(fortuneIds)),
            signaledFortuneNames: Value(joinFields(fortuneNames)),
          ),
        );
    return updated == 1;
  }

  Future<bool> buyAnyway(int id) async {
    final updated =
        await (update(scans)
              ..where((row) => row.id.equals(id) & row.choice.isNull()))
            .write(const ScansCompanion(choice: Value('bought')));
    return updated == 1;
  }

  Stream<Set<String>> watchExcludedFortuneIds() {
    return select(alertExclusions).watch().map((rows) {
      return {for (final row in rows) row.fortuneId};
    });
  }

  Future<Set<String>> excludedFortuneIds() async {
    final rows = await select(alertExclusions).get();
    return {for (final row in rows) row.fortuneId};
  }

  Future<void> removeAlert({
    required String fortuneId,
    required String fortuneName,
    required DateTime removedAt,
  }) {
    return into(alertExclusions).insertOnConflictUpdate(
      AlertExclusionsCompanion.insert(
        fortuneId: fortuneId,
        fortuneName: fortuneName,
        removedAt: removedAt,
      ),
    );
  }

  Future<void> restoreAlert(String fortuneId) {
    return (delete(
      alertExclusions,
    )..where((row) => row.fortuneId.equals(fortuneId))).go();
  }

  Future<void> rememberChoice({
    required int id,
    required String chosenBrandIds,
    required String signaledFortuneIds,
    required String signaledFortuneNames,
    required String issue,
  }) {
    return (update(scans)..where((row) => row.id.equals(id))).write(
      ScansCompanion(
        chosenBrandIds: Value(chosenBrandIds),
        signaledFortuneIds: Value(signaledFortuneIds),
        signaledFortuneNames: Value(signaledFortuneNames),
        issue: Value(issue),
      ),
    );
  }
}
