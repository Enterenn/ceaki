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

@DriftDatabase(tables: [Scans, ProductCacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'transparence'));

  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  Future<ProductCacheEntry?> freshProduct(String gtin, DateTime now) async {
    final row = await (select(
      productCacheEntries,
    )..where((entry) => entry.gtin.equals(gtin))).getSingleOrNull();
    if (row == null) return null;
    final age = now.difference(row.fetchedAt);
    if (age.isNegative || age >= productCacheFor) return null;
    return row;
  }

  Future<void> saveProduct(BookRecord book, DateTime fetchedAt) {
    return into(productCacheEntries).insertOnConflictUpdate(
      ProductCacheEntriesCompanion.insert(
        gtin: book.gtin,
        productName: Value(book.title),
        creator: Value(book.creator),
        category: 'livre',
        brandNames: joinFields(book.publishers),
        fetchedAt: fetchedAt,
        source: book.source,
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
