// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScansTable extends Scans with TableInfo<$ScansTable, Scan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scannedAtMeta = const VerificationMeta(
    'scannedAt',
  );
  @override
  late final GeneratedColumn<DateTime> scannedAt = GeneratedColumn<DateTime>(
    'scanned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gtinMeta = const VerificationMeta('gtin');
  @override
  late final GeneratedColumn<String> gtin = GeneratedColumn<String>(
    'gtin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandNamesMeta = const VerificationMeta(
    'brandNames',
  );
  @override
  late final GeneratedColumn<String> brandNames = GeneratedColumn<String>(
    'brand_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _signaledFortuneIdsMeta =
      const VerificationMeta('signaledFortuneIds');
  @override
  late final GeneratedColumn<String> signaledFortuneIds =
      GeneratedColumn<String>(
        'signaled_fortune_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _signaledFortuneNamesMeta =
      const VerificationMeta('signaledFortuneNames');
  @override
  late final GeneratedColumn<String> signaledFortuneNames =
      GeneratedColumn<String>(
        'signaled_fortune_names',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _libraryVersionMeta = const VerificationMeta(
    'libraryVersion',
  );
  @override
  late final GeneratedColumn<String> libraryVersion = GeneratedColumn<String>(
    'library_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choiceMeta = const VerificationMeta('choice');
  @override
  late final GeneratedColumn<String> choice = GeneratedColumn<String>(
    'choice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _issueMeta = const VerificationMeta('issue');
  @override
  late final GeneratedColumn<String> issue = GeneratedColumn<String>(
    'issue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chosenBrandIdsMeta = const VerificationMeta(
    'chosenBrandIds',
  );
  @override
  late final GeneratedColumn<String> chosenBrandIds = GeneratedColumn<String>(
    'chosen_brand_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scannedAt,
    gtin,
    productName,
    creator,
    category,
    brandNames,
    signaledFortuneIds,
    signaledFortuneNames,
    libraryVersion,
    choice,
    issue,
    chosenBrandIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Scan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scanned_at')) {
      context.handle(
        _scannedAtMeta,
        scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_scannedAtMeta);
    }
    if (data.containsKey('gtin')) {
      context.handle(
        _gtinMeta,
        gtin.isAcceptableOrUnknown(data['gtin']!, _gtinMeta),
      );
    } else if (isInserting) {
      context.missing(_gtinMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('brand_names')) {
      context.handle(
        _brandNamesMeta,
        brandNames.isAcceptableOrUnknown(data['brand_names']!, _brandNamesMeta),
      );
    }
    if (data.containsKey('signaled_fortune_ids')) {
      context.handle(
        _signaledFortuneIdsMeta,
        signaledFortuneIds.isAcceptableOrUnknown(
          data['signaled_fortune_ids']!,
          _signaledFortuneIdsMeta,
        ),
      );
    }
    if (data.containsKey('signaled_fortune_names')) {
      context.handle(
        _signaledFortuneNamesMeta,
        signaledFortuneNames.isAcceptableOrUnknown(
          data['signaled_fortune_names']!,
          _signaledFortuneNamesMeta,
        ),
      );
    }
    if (data.containsKey('library_version')) {
      context.handle(
        _libraryVersionMeta,
        libraryVersion.isAcceptableOrUnknown(
          data['library_version']!,
          _libraryVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryVersionMeta);
    }
    if (data.containsKey('choice')) {
      context.handle(
        _choiceMeta,
        choice.isAcceptableOrUnknown(data['choice']!, _choiceMeta),
      );
    }
    if (data.containsKey('issue')) {
      context.handle(
        _issueMeta,
        issue.isAcceptableOrUnknown(data['issue']!, _issueMeta),
      );
    } else if (isInserting) {
      context.missing(_issueMeta);
    }
    if (data.containsKey('chosen_brand_ids')) {
      context.handle(
        _chosenBrandIdsMeta,
        chosenBrandIds.isAcceptableOrUnknown(
          data['chosen_brand_ids']!,
          _chosenBrandIdsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Scan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Scan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scanned_at'],
      )!,
      gtin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gtin'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      ),
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      brandNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_names'],
      )!,
      signaledFortuneIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signaled_fortune_ids'],
      )!,
      signaledFortuneNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signaled_fortune_names'],
      )!,
      libraryVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_version'],
      )!,
      choice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choice'],
      ),
      issue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue'],
      )!,
      chosenBrandIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chosen_brand_ids'],
      )!,
    );
  }

  @override
  $ScansTable createAlias(String alias) {
    return $ScansTable(attachedDatabase, alias);
  }
}

class Scan extends DataClass implements Insertable<Scan> {
  final int id;
  final DateTime scannedAt;
  final String gtin;
  final String? productName;
  final String? creator;
  final String? category;
  final String brandNames;
  final String signaledFortuneIds;
  final String signaledFortuneNames;
  final String libraryVersion;
  final String? choice;
  final String issue;
  final String chosenBrandIds;
  const Scan({
    required this.id,
    required this.scannedAt,
    required this.gtin,
    this.productName,
    this.creator,
    this.category,
    required this.brandNames,
    required this.signaledFortuneIds,
    required this.signaledFortuneNames,
    required this.libraryVersion,
    this.choice,
    required this.issue,
    required this.chosenBrandIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scanned_at'] = Variable<DateTime>(scannedAt);
    map['gtin'] = Variable<String>(gtin);
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || creator != null) {
      map['creator'] = Variable<String>(creator);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['brand_names'] = Variable<String>(brandNames);
    map['signaled_fortune_ids'] = Variable<String>(signaledFortuneIds);
    map['signaled_fortune_names'] = Variable<String>(signaledFortuneNames);
    map['library_version'] = Variable<String>(libraryVersion);
    if (!nullToAbsent || choice != null) {
      map['choice'] = Variable<String>(choice);
    }
    map['issue'] = Variable<String>(issue);
    map['chosen_brand_ids'] = Variable<String>(chosenBrandIds);
    return map;
  }

  ScansCompanion toCompanion(bool nullToAbsent) {
    return ScansCompanion(
      id: Value(id),
      scannedAt: Value(scannedAt),
      gtin: Value(gtin),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      brandNames: Value(brandNames),
      signaledFortuneIds: Value(signaledFortuneIds),
      signaledFortuneNames: Value(signaledFortuneNames),
      libraryVersion: Value(libraryVersion),
      choice: choice == null && nullToAbsent
          ? const Value.absent()
          : Value(choice),
      issue: Value(issue),
      chosenBrandIds: Value(chosenBrandIds),
    );
  }

  factory Scan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Scan(
      id: serializer.fromJson<int>(json['id']),
      scannedAt: serializer.fromJson<DateTime>(json['scannedAt']),
      gtin: serializer.fromJson<String>(json['gtin']),
      productName: serializer.fromJson<String?>(json['productName']),
      creator: serializer.fromJson<String?>(json['creator']),
      category: serializer.fromJson<String?>(json['category']),
      brandNames: serializer.fromJson<String>(json['brandNames']),
      signaledFortuneIds: serializer.fromJson<String>(
        json['signaledFortuneIds'],
      ),
      signaledFortuneNames: serializer.fromJson<String>(
        json['signaledFortuneNames'],
      ),
      libraryVersion: serializer.fromJson<String>(json['libraryVersion']),
      choice: serializer.fromJson<String?>(json['choice']),
      issue: serializer.fromJson<String>(json['issue']),
      chosenBrandIds: serializer.fromJson<String>(json['chosenBrandIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scannedAt': serializer.toJson<DateTime>(scannedAt),
      'gtin': serializer.toJson<String>(gtin),
      'productName': serializer.toJson<String?>(productName),
      'creator': serializer.toJson<String?>(creator),
      'category': serializer.toJson<String?>(category),
      'brandNames': serializer.toJson<String>(brandNames),
      'signaledFortuneIds': serializer.toJson<String>(signaledFortuneIds),
      'signaledFortuneNames': serializer.toJson<String>(signaledFortuneNames),
      'libraryVersion': serializer.toJson<String>(libraryVersion),
      'choice': serializer.toJson<String?>(choice),
      'issue': serializer.toJson<String>(issue),
      'chosenBrandIds': serializer.toJson<String>(chosenBrandIds),
    };
  }

  Scan copyWith({
    int? id,
    DateTime? scannedAt,
    String? gtin,
    Value<String?> productName = const Value.absent(),
    Value<String?> creator = const Value.absent(),
    Value<String?> category = const Value.absent(),
    String? brandNames,
    String? signaledFortuneIds,
    String? signaledFortuneNames,
    String? libraryVersion,
    Value<String?> choice = const Value.absent(),
    String? issue,
    String? chosenBrandIds,
  }) => Scan(
    id: id ?? this.id,
    scannedAt: scannedAt ?? this.scannedAt,
    gtin: gtin ?? this.gtin,
    productName: productName.present ? productName.value : this.productName,
    creator: creator.present ? creator.value : this.creator,
    category: category.present ? category.value : this.category,
    brandNames: brandNames ?? this.brandNames,
    signaledFortuneIds: signaledFortuneIds ?? this.signaledFortuneIds,
    signaledFortuneNames: signaledFortuneNames ?? this.signaledFortuneNames,
    libraryVersion: libraryVersion ?? this.libraryVersion,
    choice: choice.present ? choice.value : this.choice,
    issue: issue ?? this.issue,
    chosenBrandIds: chosenBrandIds ?? this.chosenBrandIds,
  );
  Scan copyWithCompanion(ScansCompanion data) {
    return Scan(
      id: data.id.present ? data.id.value : this.id,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
      gtin: data.gtin.present ? data.gtin.value : this.gtin,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      creator: data.creator.present ? data.creator.value : this.creator,
      category: data.category.present ? data.category.value : this.category,
      brandNames: data.brandNames.present
          ? data.brandNames.value
          : this.brandNames,
      signaledFortuneIds: data.signaledFortuneIds.present
          ? data.signaledFortuneIds.value
          : this.signaledFortuneIds,
      signaledFortuneNames: data.signaledFortuneNames.present
          ? data.signaledFortuneNames.value
          : this.signaledFortuneNames,
      libraryVersion: data.libraryVersion.present
          ? data.libraryVersion.value
          : this.libraryVersion,
      choice: data.choice.present ? data.choice.value : this.choice,
      issue: data.issue.present ? data.issue.value : this.issue,
      chosenBrandIds: data.chosenBrandIds.present
          ? data.chosenBrandIds.value
          : this.chosenBrandIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Scan(')
          ..write('id: $id, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('gtin: $gtin, ')
          ..write('productName: $productName, ')
          ..write('creator: $creator, ')
          ..write('category: $category, ')
          ..write('brandNames: $brandNames, ')
          ..write('signaledFortuneIds: $signaledFortuneIds, ')
          ..write('signaledFortuneNames: $signaledFortuneNames, ')
          ..write('libraryVersion: $libraryVersion, ')
          ..write('choice: $choice, ')
          ..write('issue: $issue, ')
          ..write('chosenBrandIds: $chosenBrandIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scannedAt,
    gtin,
    productName,
    creator,
    category,
    brandNames,
    signaledFortuneIds,
    signaledFortuneNames,
    libraryVersion,
    choice,
    issue,
    chosenBrandIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Scan &&
          other.id == this.id &&
          other.scannedAt == this.scannedAt &&
          other.gtin == this.gtin &&
          other.productName == this.productName &&
          other.creator == this.creator &&
          other.category == this.category &&
          other.brandNames == this.brandNames &&
          other.signaledFortuneIds == this.signaledFortuneIds &&
          other.signaledFortuneNames == this.signaledFortuneNames &&
          other.libraryVersion == this.libraryVersion &&
          other.choice == this.choice &&
          other.issue == this.issue &&
          other.chosenBrandIds == this.chosenBrandIds);
}

class ScansCompanion extends UpdateCompanion<Scan> {
  final Value<int> id;
  final Value<DateTime> scannedAt;
  final Value<String> gtin;
  final Value<String?> productName;
  final Value<String?> creator;
  final Value<String?> category;
  final Value<String> brandNames;
  final Value<String> signaledFortuneIds;
  final Value<String> signaledFortuneNames;
  final Value<String> libraryVersion;
  final Value<String?> choice;
  final Value<String> issue;
  final Value<String> chosenBrandIds;
  const ScansCompanion({
    this.id = const Value.absent(),
    this.scannedAt = const Value.absent(),
    this.gtin = const Value.absent(),
    this.productName = const Value.absent(),
    this.creator = const Value.absent(),
    this.category = const Value.absent(),
    this.brandNames = const Value.absent(),
    this.signaledFortuneIds = const Value.absent(),
    this.signaledFortuneNames = const Value.absent(),
    this.libraryVersion = const Value.absent(),
    this.choice = const Value.absent(),
    this.issue = const Value.absent(),
    this.chosenBrandIds = const Value.absent(),
  });
  ScansCompanion.insert({
    this.id = const Value.absent(),
    required DateTime scannedAt,
    required String gtin,
    this.productName = const Value.absent(),
    this.creator = const Value.absent(),
    this.category = const Value.absent(),
    this.brandNames = const Value.absent(),
    this.signaledFortuneIds = const Value.absent(),
    this.signaledFortuneNames = const Value.absent(),
    required String libraryVersion,
    this.choice = const Value.absent(),
    required String issue,
    this.chosenBrandIds = const Value.absent(),
  }) : scannedAt = Value(scannedAt),
       gtin = Value(gtin),
       libraryVersion = Value(libraryVersion),
       issue = Value(issue);
  static Insertable<Scan> custom({
    Expression<int>? id,
    Expression<DateTime>? scannedAt,
    Expression<String>? gtin,
    Expression<String>? productName,
    Expression<String>? creator,
    Expression<String>? category,
    Expression<String>? brandNames,
    Expression<String>? signaledFortuneIds,
    Expression<String>? signaledFortuneNames,
    Expression<String>? libraryVersion,
    Expression<String>? choice,
    Expression<String>? issue,
    Expression<String>? chosenBrandIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scannedAt != null) 'scanned_at': scannedAt,
      if (gtin != null) 'gtin': gtin,
      if (productName != null) 'product_name': productName,
      if (creator != null) 'creator': creator,
      if (category != null) 'category': category,
      if (brandNames != null) 'brand_names': brandNames,
      if (signaledFortuneIds != null)
        'signaled_fortune_ids': signaledFortuneIds,
      if (signaledFortuneNames != null)
        'signaled_fortune_names': signaledFortuneNames,
      if (libraryVersion != null) 'library_version': libraryVersion,
      if (choice != null) 'choice': choice,
      if (issue != null) 'issue': issue,
      if (chosenBrandIds != null) 'chosen_brand_ids': chosenBrandIds,
    });
  }

  ScansCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? scannedAt,
    Value<String>? gtin,
    Value<String?>? productName,
    Value<String?>? creator,
    Value<String?>? category,
    Value<String>? brandNames,
    Value<String>? signaledFortuneIds,
    Value<String>? signaledFortuneNames,
    Value<String>? libraryVersion,
    Value<String?>? choice,
    Value<String>? issue,
    Value<String>? chosenBrandIds,
  }) {
    return ScansCompanion(
      id: id ?? this.id,
      scannedAt: scannedAt ?? this.scannedAt,
      gtin: gtin ?? this.gtin,
      productName: productName ?? this.productName,
      creator: creator ?? this.creator,
      category: category ?? this.category,
      brandNames: brandNames ?? this.brandNames,
      signaledFortuneIds: signaledFortuneIds ?? this.signaledFortuneIds,
      signaledFortuneNames: signaledFortuneNames ?? this.signaledFortuneNames,
      libraryVersion: libraryVersion ?? this.libraryVersion,
      choice: choice ?? this.choice,
      issue: issue ?? this.issue,
      chosenBrandIds: chosenBrandIds ?? this.chosenBrandIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<DateTime>(scannedAt.value);
    }
    if (gtin.present) {
      map['gtin'] = Variable<String>(gtin.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (brandNames.present) {
      map['brand_names'] = Variable<String>(brandNames.value);
    }
    if (signaledFortuneIds.present) {
      map['signaled_fortune_ids'] = Variable<String>(signaledFortuneIds.value);
    }
    if (signaledFortuneNames.present) {
      map['signaled_fortune_names'] = Variable<String>(
        signaledFortuneNames.value,
      );
    }
    if (libraryVersion.present) {
      map['library_version'] = Variable<String>(libraryVersion.value);
    }
    if (choice.present) {
      map['choice'] = Variable<String>(choice.value);
    }
    if (issue.present) {
      map['issue'] = Variable<String>(issue.value);
    }
    if (chosenBrandIds.present) {
      map['chosen_brand_ids'] = Variable<String>(chosenBrandIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScansCompanion(')
          ..write('id: $id, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('gtin: $gtin, ')
          ..write('productName: $productName, ')
          ..write('creator: $creator, ')
          ..write('category: $category, ')
          ..write('brandNames: $brandNames, ')
          ..write('signaledFortuneIds: $signaledFortuneIds, ')
          ..write('signaledFortuneNames: $signaledFortuneNames, ')
          ..write('libraryVersion: $libraryVersion, ')
          ..write('choice: $choice, ')
          ..write('issue: $issue, ')
          ..write('chosenBrandIds: $chosenBrandIds')
          ..write(')'))
        .toString();
  }
}

class $ProductCacheEntriesTable extends ProductCacheEntries
    with TableInfo<$ProductCacheEntriesTable, ProductCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gtinMeta = const VerificationMeta('gtin');
  @override
  late final GeneratedColumn<String> gtin = GeneratedColumn<String>(
    'gtin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandNamesMeta = const VerificationMeta(
    'brandNames',
  );
  @override
  late final GeneratedColumn<String> brandNames = GeneratedColumn<String>(
    'brand_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    gtin,
    productName,
    creator,
    category,
    brandNames,
    fetchedAt,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gtin')) {
      context.handle(
        _gtinMeta,
        gtin.isAcceptableOrUnknown(data['gtin']!, _gtinMeta),
      );
    } else if (isInserting) {
      context.missing(_gtinMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('brand_names')) {
      context.handle(
        _brandNamesMeta,
        brandNames.isAcceptableOrUnknown(data['brand_names']!, _brandNamesMeta),
      );
    } else if (isInserting) {
      context.missing(_brandNamesMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gtin};
  @override
  ProductCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductCacheEntry(
      gtin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gtin'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      ),
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      brandNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_names'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $ProductCacheEntriesTable createAlias(String alias) {
    return $ProductCacheEntriesTable(attachedDatabase, alias);
  }
}

class ProductCacheEntry extends DataClass
    implements Insertable<ProductCacheEntry> {
  final String gtin;
  final String? productName;
  final String? creator;
  final String category;
  final String brandNames;
  final DateTime fetchedAt;
  final String source;
  const ProductCacheEntry({
    required this.gtin,
    this.productName,
    this.creator,
    required this.category,
    required this.brandNames,
    required this.fetchedAt,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gtin'] = Variable<String>(gtin);
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || creator != null) {
      map['creator'] = Variable<String>(creator);
    }
    map['category'] = Variable<String>(category);
    map['brand_names'] = Variable<String>(brandNames);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  ProductCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProductCacheEntriesCompanion(
      gtin: Value(gtin),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      category: Value(category),
      brandNames: Value(brandNames),
      fetchedAt: Value(fetchedAt),
      source: Value(source),
    );
  }

  factory ProductCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductCacheEntry(
      gtin: serializer.fromJson<String>(json['gtin']),
      productName: serializer.fromJson<String?>(json['productName']),
      creator: serializer.fromJson<String?>(json['creator']),
      category: serializer.fromJson<String>(json['category']),
      brandNames: serializer.fromJson<String>(json['brandNames']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gtin': serializer.toJson<String>(gtin),
      'productName': serializer.toJson<String?>(productName),
      'creator': serializer.toJson<String?>(creator),
      'category': serializer.toJson<String>(category),
      'brandNames': serializer.toJson<String>(brandNames),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'source': serializer.toJson<String>(source),
    };
  }

  ProductCacheEntry copyWith({
    String? gtin,
    Value<String?> productName = const Value.absent(),
    Value<String?> creator = const Value.absent(),
    String? category,
    String? brandNames,
    DateTime? fetchedAt,
    String? source,
  }) => ProductCacheEntry(
    gtin: gtin ?? this.gtin,
    productName: productName.present ? productName.value : this.productName,
    creator: creator.present ? creator.value : this.creator,
    category: category ?? this.category,
    brandNames: brandNames ?? this.brandNames,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    source: source ?? this.source,
  );
  ProductCacheEntry copyWithCompanion(ProductCacheEntriesCompanion data) {
    return ProductCacheEntry(
      gtin: data.gtin.present ? data.gtin.value : this.gtin,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      creator: data.creator.present ? data.creator.value : this.creator,
      category: data.category.present ? data.category.value : this.category,
      brandNames: data.brandNames.present
          ? data.brandNames.value
          : this.brandNames,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductCacheEntry(')
          ..write('gtin: $gtin, ')
          ..write('productName: $productName, ')
          ..write('creator: $creator, ')
          ..write('category: $category, ')
          ..write('brandNames: $brandNames, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    gtin,
    productName,
    creator,
    category,
    brandNames,
    fetchedAt,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCacheEntry &&
          other.gtin == this.gtin &&
          other.productName == this.productName &&
          other.creator == this.creator &&
          other.category == this.category &&
          other.brandNames == this.brandNames &&
          other.fetchedAt == this.fetchedAt &&
          other.source == this.source);
}

class ProductCacheEntriesCompanion extends UpdateCompanion<ProductCacheEntry> {
  final Value<String> gtin;
  final Value<String?> productName;
  final Value<String?> creator;
  final Value<String> category;
  final Value<String> brandNames;
  final Value<DateTime> fetchedAt;
  final Value<String> source;
  final Value<int> rowid;
  const ProductCacheEntriesCompanion({
    this.gtin = const Value.absent(),
    this.productName = const Value.absent(),
    this.creator = const Value.absent(),
    this.category = const Value.absent(),
    this.brandNames = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductCacheEntriesCompanion.insert({
    required String gtin,
    this.productName = const Value.absent(),
    this.creator = const Value.absent(),
    required String category,
    required String brandNames,
    required DateTime fetchedAt,
    required String source,
    this.rowid = const Value.absent(),
  }) : gtin = Value(gtin),
       category = Value(category),
       brandNames = Value(brandNames),
       fetchedAt = Value(fetchedAt),
       source = Value(source);
  static Insertable<ProductCacheEntry> custom({
    Expression<String>? gtin,
    Expression<String>? productName,
    Expression<String>? creator,
    Expression<String>? category,
    Expression<String>? brandNames,
    Expression<DateTime>? fetchedAt,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gtin != null) 'gtin': gtin,
      if (productName != null) 'product_name': productName,
      if (creator != null) 'creator': creator,
      if (category != null) 'category': category,
      if (brandNames != null) 'brand_names': brandNames,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductCacheEntriesCompanion copyWith({
    Value<String>? gtin,
    Value<String?>? productName,
    Value<String?>? creator,
    Value<String>? category,
    Value<String>? brandNames,
    Value<DateTime>? fetchedAt,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return ProductCacheEntriesCompanion(
      gtin: gtin ?? this.gtin,
      productName: productName ?? this.productName,
      creator: creator ?? this.creator,
      category: category ?? this.category,
      brandNames: brandNames ?? this.brandNames,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gtin.present) {
      map['gtin'] = Variable<String>(gtin.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (brandNames.present) {
      map['brand_names'] = Variable<String>(brandNames.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCacheEntriesCompanion(')
          ..write('gtin: $gtin, ')
          ..write('productName: $productName, ')
          ..write('creator: $creator, ')
          ..write('category: $category, ')
          ..write('brandNames: $brandNames, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertExclusionsTable extends AlertExclusions
    with TableInfo<$AlertExclusionsTable, AlertExclusion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertExclusionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fortuneIdMeta = const VerificationMeta(
    'fortuneId',
  );
  @override
  late final GeneratedColumn<String> fortuneId = GeneratedColumn<String>(
    'fortune_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fortuneNameMeta = const VerificationMeta(
    'fortuneName',
  );
  @override
  late final GeneratedColumn<String> fortuneName = GeneratedColumn<String>(
    'fortune_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _removedAtMeta = const VerificationMeta(
    'removedAt',
  );
  @override
  late final GeneratedColumn<DateTime> removedAt = GeneratedColumn<DateTime>(
    'removed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fortuneId, fortuneName, removedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_exclusions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertExclusion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fortune_id')) {
      context.handle(
        _fortuneIdMeta,
        fortuneId.isAcceptableOrUnknown(data['fortune_id']!, _fortuneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fortuneIdMeta);
    }
    if (data.containsKey('fortune_name')) {
      context.handle(
        _fortuneNameMeta,
        fortuneName.isAcceptableOrUnknown(
          data['fortune_name']!,
          _fortuneNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fortuneNameMeta);
    }
    if (data.containsKey('removed_at')) {
      context.handle(
        _removedAtMeta,
        removedAt.isAcceptableOrUnknown(data['removed_at']!, _removedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_removedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fortuneId};
  @override
  AlertExclusion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertExclusion(
      fortuneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fortune_id'],
      )!,
      fortuneName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fortune_name'],
      )!,
      removedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}removed_at'],
      )!,
    );
  }

  @override
  $AlertExclusionsTable createAlias(String alias) {
    return $AlertExclusionsTable(attachedDatabase, alias);
  }
}

class AlertExclusion extends DataClass implements Insertable<AlertExclusion> {
  final String fortuneId;
  final String fortuneName;
  final DateTime removedAt;
  const AlertExclusion({
    required this.fortuneId,
    required this.fortuneName,
    required this.removedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fortune_id'] = Variable<String>(fortuneId);
    map['fortune_name'] = Variable<String>(fortuneName);
    map['removed_at'] = Variable<DateTime>(removedAt);
    return map;
  }

  AlertExclusionsCompanion toCompanion(bool nullToAbsent) {
    return AlertExclusionsCompanion(
      fortuneId: Value(fortuneId),
      fortuneName: Value(fortuneName),
      removedAt: Value(removedAt),
    );
  }

  factory AlertExclusion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertExclusion(
      fortuneId: serializer.fromJson<String>(json['fortuneId']),
      fortuneName: serializer.fromJson<String>(json['fortuneName']),
      removedAt: serializer.fromJson<DateTime>(json['removedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fortuneId': serializer.toJson<String>(fortuneId),
      'fortuneName': serializer.toJson<String>(fortuneName),
      'removedAt': serializer.toJson<DateTime>(removedAt),
    };
  }

  AlertExclusion copyWith({
    String? fortuneId,
    String? fortuneName,
    DateTime? removedAt,
  }) => AlertExclusion(
    fortuneId: fortuneId ?? this.fortuneId,
    fortuneName: fortuneName ?? this.fortuneName,
    removedAt: removedAt ?? this.removedAt,
  );
  AlertExclusion copyWithCompanion(AlertExclusionsCompanion data) {
    return AlertExclusion(
      fortuneId: data.fortuneId.present ? data.fortuneId.value : this.fortuneId,
      fortuneName: data.fortuneName.present
          ? data.fortuneName.value
          : this.fortuneName,
      removedAt: data.removedAt.present ? data.removedAt.value : this.removedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertExclusion(')
          ..write('fortuneId: $fortuneId, ')
          ..write('fortuneName: $fortuneName, ')
          ..write('removedAt: $removedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fortuneId, fortuneName, removedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertExclusion &&
          other.fortuneId == this.fortuneId &&
          other.fortuneName == this.fortuneName &&
          other.removedAt == this.removedAt);
}

class AlertExclusionsCompanion extends UpdateCompanion<AlertExclusion> {
  final Value<String> fortuneId;
  final Value<String> fortuneName;
  final Value<DateTime> removedAt;
  final Value<int> rowid;
  const AlertExclusionsCompanion({
    this.fortuneId = const Value.absent(),
    this.fortuneName = const Value.absent(),
    this.removedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertExclusionsCompanion.insert({
    required String fortuneId,
    required String fortuneName,
    required DateTime removedAt,
    this.rowid = const Value.absent(),
  }) : fortuneId = Value(fortuneId),
       fortuneName = Value(fortuneName),
       removedAt = Value(removedAt);
  static Insertable<AlertExclusion> custom({
    Expression<String>? fortuneId,
    Expression<String>? fortuneName,
    Expression<DateTime>? removedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fortuneId != null) 'fortune_id': fortuneId,
      if (fortuneName != null) 'fortune_name': fortuneName,
      if (removedAt != null) 'removed_at': removedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertExclusionsCompanion copyWith({
    Value<String>? fortuneId,
    Value<String>? fortuneName,
    Value<DateTime>? removedAt,
    Value<int>? rowid,
  }) {
    return AlertExclusionsCompanion(
      fortuneId: fortuneId ?? this.fortuneId,
      fortuneName: fortuneName ?? this.fortuneName,
      removedAt: removedAt ?? this.removedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fortuneId.present) {
      map['fortune_id'] = Variable<String>(fortuneId.value);
    }
    if (fortuneName.present) {
      map['fortune_name'] = Variable<String>(fortuneName.value);
    }
    if (removedAt.present) {
      map['removed_at'] = Variable<DateTime>(removedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertExclusionsCompanion(')
          ..write('fortuneId: $fortuneId, ')
          ..write('fortuneName: $fortuneName, ')
          ..write('removedAt: $removedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GtinBrandChoicesTable extends GtinBrandChoices
    with TableInfo<$GtinBrandChoicesTable, GtinBrandChoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GtinBrandChoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gtinMeta = const VerificationMeta('gtin');
  @override
  late final GeneratedColumn<String> gtin = GeneratedColumn<String>(
    'gtin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choiceKeyMeta = const VerificationMeta(
    'choiceKey',
  );
  @override
  late final GeneratedColumn<String> choiceKey = GeneratedColumn<String>(
    'choice_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [gtin, choiceKey, brandId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gtin_brand_choices';
  @override
  VerificationContext validateIntegrity(
    Insertable<GtinBrandChoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gtin')) {
      context.handle(
        _gtinMeta,
        gtin.isAcceptableOrUnknown(data['gtin']!, _gtinMeta),
      );
    } else if (isInserting) {
      context.missing(_gtinMeta);
    }
    if (data.containsKey('choice_key')) {
      context.handle(
        _choiceKeyMeta,
        choiceKey.isAcceptableOrUnknown(data['choice_key']!, _choiceKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_choiceKeyMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brandIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gtin, choiceKey};
  @override
  GtinBrandChoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GtinBrandChoice(
      gtin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gtin'],
      )!,
      choiceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choice_key'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      )!,
    );
  }

  @override
  $GtinBrandChoicesTable createAlias(String alias) {
    return $GtinBrandChoicesTable(attachedDatabase, alias);
  }
}

class GtinBrandChoice extends DataClass implements Insertable<GtinBrandChoice> {
  final String gtin;
  final String choiceKey;
  final String brandId;
  const GtinBrandChoice({
    required this.gtin,
    required this.choiceKey,
    required this.brandId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gtin'] = Variable<String>(gtin);
    map['choice_key'] = Variable<String>(choiceKey);
    map['brand_id'] = Variable<String>(brandId);
    return map;
  }

  GtinBrandChoicesCompanion toCompanion(bool nullToAbsent) {
    return GtinBrandChoicesCompanion(
      gtin: Value(gtin),
      choiceKey: Value(choiceKey),
      brandId: Value(brandId),
    );
  }

  factory GtinBrandChoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GtinBrandChoice(
      gtin: serializer.fromJson<String>(json['gtin']),
      choiceKey: serializer.fromJson<String>(json['choiceKey']),
      brandId: serializer.fromJson<String>(json['brandId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gtin': serializer.toJson<String>(gtin),
      'choiceKey': serializer.toJson<String>(choiceKey),
      'brandId': serializer.toJson<String>(brandId),
    };
  }

  GtinBrandChoice copyWith({
    String? gtin,
    String? choiceKey,
    String? brandId,
  }) => GtinBrandChoice(
    gtin: gtin ?? this.gtin,
    choiceKey: choiceKey ?? this.choiceKey,
    brandId: brandId ?? this.brandId,
  );
  GtinBrandChoice copyWithCompanion(GtinBrandChoicesCompanion data) {
    return GtinBrandChoice(
      gtin: data.gtin.present ? data.gtin.value : this.gtin,
      choiceKey: data.choiceKey.present ? data.choiceKey.value : this.choiceKey,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GtinBrandChoice(')
          ..write('gtin: $gtin, ')
          ..write('choiceKey: $choiceKey, ')
          ..write('brandId: $brandId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gtin, choiceKey, brandId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GtinBrandChoice &&
          other.gtin == this.gtin &&
          other.choiceKey == this.choiceKey &&
          other.brandId == this.brandId);
}

class GtinBrandChoicesCompanion extends UpdateCompanion<GtinBrandChoice> {
  final Value<String> gtin;
  final Value<String> choiceKey;
  final Value<String> brandId;
  final Value<int> rowid;
  const GtinBrandChoicesCompanion({
    this.gtin = const Value.absent(),
    this.choiceKey = const Value.absent(),
    this.brandId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GtinBrandChoicesCompanion.insert({
    required String gtin,
    required String choiceKey,
    required String brandId,
    this.rowid = const Value.absent(),
  }) : gtin = Value(gtin),
       choiceKey = Value(choiceKey),
       brandId = Value(brandId);
  static Insertable<GtinBrandChoice> custom({
    Expression<String>? gtin,
    Expression<String>? choiceKey,
    Expression<String>? brandId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gtin != null) 'gtin': gtin,
      if (choiceKey != null) 'choice_key': choiceKey,
      if (brandId != null) 'brand_id': brandId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GtinBrandChoicesCompanion copyWith({
    Value<String>? gtin,
    Value<String>? choiceKey,
    Value<String>? brandId,
    Value<int>? rowid,
  }) {
    return GtinBrandChoicesCompanion(
      gtin: gtin ?? this.gtin,
      choiceKey: choiceKey ?? this.choiceKey,
      brandId: brandId ?? this.brandId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gtin.present) {
      map['gtin'] = Variable<String>(gtin.value);
    }
    if (choiceKey.present) {
      map['choice_key'] = Variable<String>(choiceKey.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GtinBrandChoicesCompanion(')
          ..write('gtin: $gtin, ')
          ..write('choiceKey: $choiceKey, ')
          ..write('brandId: $brandId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScansTable scans = $ScansTable(this);
  late final $ProductCacheEntriesTable productCacheEntries =
      $ProductCacheEntriesTable(this);
  late final $AlertExclusionsTable alertExclusions = $AlertExclusionsTable(
    this,
  );
  late final $GtinBrandChoicesTable gtinBrandChoices = $GtinBrandChoicesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    scans,
    productCacheEntries,
    alertExclusions,
    gtinBrandChoices,
  ];
}

typedef $$ScansTableCreateCompanionBuilder = ScansCompanion Function({
  Value<int> id,
  required DateTime scannedAt,
  required String gtin,
  Value<String?> productName,
  Value<String?> creator,
  Value<String?> category,
  Value<String> brandNames,
  Value<String> signaledFortuneIds,
  Value<String> signaledFortuneNames,
  required String libraryVersion,
  Value<String?> choice,
  required String issue,
  Value<String> chosenBrandIds,
});
typedef $$ScansTableUpdateCompanionBuilder = ScansCompanion Function({
  Value<int> id,
  Value<DateTime> scannedAt,
  Value<String> gtin,
  Value<String?> productName,
  Value<String?> creator,
  Value<String?> category,
  Value<String> brandNames,
  Value<String> signaledFortuneIds,
  Value<String> signaledFortuneNames,
  Value<String> libraryVersion,
  Value<String?> choice,
  Value<String> issue,
  Value<String> chosenBrandIds,
});

class $$ScansTableFilterComposer extends Composer<_$AppDatabase, $ScansTable> {
  $$ScansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gtin => $composableBuilder(
    column: $table.gtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signaledFortuneIds => $composableBuilder(
    column: $table.signaledFortuneIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signaledFortuneNames => $composableBuilder(
    column: $table.signaledFortuneNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryVersion => $composableBuilder(
    column: $table.libraryVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choice => $composableBuilder(
    column: $table.choice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issue => $composableBuilder(
    column: $table.issue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chosenBrandIds => $composableBuilder(
    column: $table.chosenBrandIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScansTableOrderingComposer
    extends Composer<_$AppDatabase, $ScansTable> {
  $$ScansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gtin => $composableBuilder(
    column: $table.gtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signaledFortuneIds => $composableBuilder(
    column: $table.signaledFortuneIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signaledFortuneNames => $composableBuilder(
    column: $table.signaledFortuneNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryVersion => $composableBuilder(
    column: $table.libraryVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choice => $composableBuilder(
    column: $table.choice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issue => $composableBuilder(
    column: $table.issue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chosenBrandIds => $composableBuilder(
    column: $table.chosenBrandIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScansTable> {
  $$ScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);

  GeneratedColumn<String> get gtin =>
      $composableBuilder(column: $table.gtin, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signaledFortuneIds => $composableBuilder(
    column: $table.signaledFortuneIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signaledFortuneNames => $composableBuilder(
    column: $table.signaledFortuneNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get libraryVersion => $composableBuilder(
    column: $table.libraryVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get choice =>
      $composableBuilder(column: $table.choice, builder: (column) => column);

  GeneratedColumn<String> get issue =>
      $composableBuilder(column: $table.issue, builder: (column) => column);

  GeneratedColumn<String> get chosenBrandIds => $composableBuilder(
    column: $table.chosenBrandIds,
    builder: (column) => column,
  );
}

class $$ScansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScansTable,
          Scan,
          $$ScansTableFilterComposer,
          $$ScansTableOrderingComposer,
          $$ScansTableAnnotationComposer,
          $$ScansTableCreateCompanionBuilder,
          $$ScansTableUpdateCompanionBuilder,
          (Scan, BaseReferences<_$AppDatabase, $ScansTable, Scan>),
          Scan,
          PrefetchHooks Function()
        > {
  $$ScansTableTableManager(_$AppDatabase db, $ScansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> scannedAt = const Value.absent(),
                Value<String> gtin = const Value.absent(),
                Value<String?> productName = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> brandNames = const Value.absent(),
                Value<String> signaledFortuneIds = const Value.absent(),
                Value<String> signaledFortuneNames = const Value.absent(),
                Value<String> libraryVersion = const Value.absent(),
                Value<String?> choice = const Value.absent(),
                Value<String> issue = const Value.absent(),
                Value<String> chosenBrandIds = const Value.absent(),
              }) => ScansCompanion(
                id: id,
                scannedAt: scannedAt,
                gtin: gtin,
                productName: productName,
                creator: creator,
                category: category,
                brandNames: brandNames,
                signaledFortuneIds: signaledFortuneIds,
                signaledFortuneNames: signaledFortuneNames,
                libraryVersion: libraryVersion,
                choice: choice,
                issue: issue,
                chosenBrandIds: chosenBrandIds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime scannedAt,
                required String gtin,
                Value<String?> productName = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> brandNames = const Value.absent(),
                Value<String> signaledFortuneIds = const Value.absent(),
                Value<String> signaledFortuneNames = const Value.absent(),
                required String libraryVersion,
                Value<String?> choice = const Value.absent(),
                required String issue,
                Value<String> chosenBrandIds = const Value.absent(),
              }) => ScansCompanion.insert(
                id: id,
                scannedAt: scannedAt,
                gtin: gtin,
                productName: productName,
                creator: creator,
                category: category,
                brandNames: brandNames,
                signaledFortuneIds: signaledFortuneIds,
                signaledFortuneNames: signaledFortuneNames,
                libraryVersion: libraryVersion,
                choice: choice,
                issue: issue,
                chosenBrandIds: chosenBrandIds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScansTable, Scan>(table),
                  BaseReferences<_$AppDatabase, $ScansTable, Scan>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScansTable,
      Scan,
      $$ScansTableFilterComposer,
      $$ScansTableOrderingComposer,
      $$ScansTableAnnotationComposer,
      $$ScansTableCreateCompanionBuilder,
      $$ScansTableUpdateCompanionBuilder,
      (Scan, BaseReferences<_$AppDatabase, $ScansTable, Scan>),
      Scan,
      PrefetchHooks Function()
    >;
typedef $$ProductCacheEntriesTableCreateCompanionBuilder =
    ProductCacheEntriesCompanion Function({
      required String gtin,
      Value<String?> productName,
      Value<String?> creator,
      required String category,
      required String brandNames,
      required DateTime fetchedAt,
      required String source,
      Value<int> rowid,
    });
typedef $$ProductCacheEntriesTableUpdateCompanionBuilder =
    ProductCacheEntriesCompanion Function({
      Value<String> gtin,
      Value<String?> productName,
      Value<String?> creator,
      Value<String> category,
      Value<String> brandNames,
      Value<DateTime> fetchedAt,
      Value<String> source,
      Value<int> rowid,
    });

class $$ProductCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductCacheEntriesTable> {
  $$ProductCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gtin => $composableBuilder(
    column: $table.gtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductCacheEntriesTable> {
  $$ProductCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gtin => $composableBuilder(
    column: $table.gtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductCacheEntriesTable> {
  $$ProductCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gtin =>
      $composableBuilder(column: $table.gtin, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$ProductCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductCacheEntriesTable,
          ProductCacheEntry,
          $$ProductCacheEntriesTableFilterComposer,
          $$ProductCacheEntriesTableOrderingComposer,
          $$ProductCacheEntriesTableAnnotationComposer,
          $$ProductCacheEntriesTableCreateCompanionBuilder,
          $$ProductCacheEntriesTableUpdateCompanionBuilder,
          (
            ProductCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $ProductCacheEntriesTable,
              ProductCacheEntry
            >,
          ),
          ProductCacheEntry,
          PrefetchHooks Function()
        > {
  $$ProductCacheEntriesTableTableManager(
    _$AppDatabase db,
    $ProductCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProductCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> gtin = const Value.absent(),
                Value<String?> productName = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> brandNames = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductCacheEntriesCompanion(
                gtin: gtin,
                productName: productName,
                creator: creator,
                category: category,
                brandNames: brandNames,
                fetchedAt: fetchedAt,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gtin,
                Value<String?> productName = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                required String category,
                required String brandNames,
                required DateTime fetchedAt,
                required String source,
                Value<int> rowid = const Value.absent(),
              }) => ProductCacheEntriesCompanion.insert(
                gtin: gtin,
                productName: productName,
                creator: creator,
                category: category,
                brandNames: brandNames,
                fetchedAt: fetchedAt,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductCacheEntriesTable, ProductCacheEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ProductCacheEntriesTable,
                    ProductCacheEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductCacheEntriesTable,
      ProductCacheEntry,
      $$ProductCacheEntriesTableFilterComposer,
      $$ProductCacheEntriesTableOrderingComposer,
      $$ProductCacheEntriesTableAnnotationComposer,
      $$ProductCacheEntriesTableCreateCompanionBuilder,
      $$ProductCacheEntriesTableUpdateCompanionBuilder,
      (
        ProductCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $ProductCacheEntriesTable,
          ProductCacheEntry
        >,
      ),
      ProductCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$AlertExclusionsTableCreateCompanionBuilder =
    AlertExclusionsCompanion Function({
      required String fortuneId,
      required String fortuneName,
      required DateTime removedAt,
      Value<int> rowid,
    });
typedef $$AlertExclusionsTableUpdateCompanionBuilder =
    AlertExclusionsCompanion Function({
      Value<String> fortuneId,
      Value<String> fortuneName,
      Value<DateTime> removedAt,
      Value<int> rowid,
    });

class $$AlertExclusionsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertExclusionsTable> {
  $$AlertExclusionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fortuneId => $composableBuilder(
    column: $table.fortuneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fortuneName => $composableBuilder(
    column: $table.fortuneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get removedAt => $composableBuilder(
    column: $table.removedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlertExclusionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertExclusionsTable> {
  $$AlertExclusionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fortuneId => $composableBuilder(
    column: $table.fortuneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fortuneName => $composableBuilder(
    column: $table.fortuneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get removedAt => $composableBuilder(
    column: $table.removedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlertExclusionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertExclusionsTable> {
  $$AlertExclusionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fortuneId =>
      $composableBuilder(column: $table.fortuneId, builder: (column) => column);

  GeneratedColumn<String> get fortuneName => $composableBuilder(
    column: $table.fortuneName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get removedAt =>
      $composableBuilder(column: $table.removedAt, builder: (column) => column);
}

class $$AlertExclusionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertExclusionsTable,
          AlertExclusion,
          $$AlertExclusionsTableFilterComposer,
          $$AlertExclusionsTableOrderingComposer,
          $$AlertExclusionsTableAnnotationComposer,
          $$AlertExclusionsTableCreateCompanionBuilder,
          $$AlertExclusionsTableUpdateCompanionBuilder,
          (
            AlertExclusion,
            BaseReferences<
              _$AppDatabase,
              $AlertExclusionsTable,
              AlertExclusion
            >,
          ),
          AlertExclusion,
          PrefetchHooks Function()
        > {
  $$AlertExclusionsTableTableManager(
    _$AppDatabase db,
    $AlertExclusionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertExclusionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertExclusionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertExclusionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fortuneId = const Value.absent(),
                Value<String> fortuneName = const Value.absent(),
                Value<DateTime> removedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertExclusionsCompanion(
                fortuneId: fortuneId,
                fortuneName: fortuneName,
                removedAt: removedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fortuneId,
                required String fortuneName,
                required DateTime removedAt,
                Value<int> rowid = const Value.absent(),
              }) => AlertExclusionsCompanion.insert(
                fortuneId: fortuneId,
                fortuneName: fortuneName,
                removedAt: removedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlertExclusionsTable, AlertExclusion>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AlertExclusionsTable,
                    AlertExclusion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlertExclusionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertExclusionsTable,
      AlertExclusion,
      $$AlertExclusionsTableFilterComposer,
      $$AlertExclusionsTableOrderingComposer,
      $$AlertExclusionsTableAnnotationComposer,
      $$AlertExclusionsTableCreateCompanionBuilder,
      $$AlertExclusionsTableUpdateCompanionBuilder,
      (
        AlertExclusion,
        BaseReferences<_$AppDatabase, $AlertExclusionsTable, AlertExclusion>,
      ),
      AlertExclusion,
      PrefetchHooks Function()
    >;
typedef $$GtinBrandChoicesTableCreateCompanionBuilder =
    GtinBrandChoicesCompanion Function({
      required String gtin,
      required String choiceKey,
      required String brandId,
      Value<int> rowid,
    });
typedef $$GtinBrandChoicesTableUpdateCompanionBuilder =
    GtinBrandChoicesCompanion Function({
      Value<String> gtin,
      Value<String> choiceKey,
      Value<String> brandId,
      Value<int> rowid,
    });

class $$GtinBrandChoicesTableFilterComposer
    extends Composer<_$AppDatabase, $GtinBrandChoicesTable> {
  $$GtinBrandChoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gtin => $composableBuilder(
    column: $table.gtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choiceKey => $composableBuilder(
    column: $table.choiceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GtinBrandChoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $GtinBrandChoicesTable> {
  $$GtinBrandChoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gtin => $composableBuilder(
    column: $table.gtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choiceKey => $composableBuilder(
    column: $table.choiceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GtinBrandChoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GtinBrandChoicesTable> {
  $$GtinBrandChoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gtin =>
      $composableBuilder(column: $table.gtin, builder: (column) => column);

  GeneratedColumn<String> get choiceKey =>
      $composableBuilder(column: $table.choiceKey, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);
}

class $$GtinBrandChoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GtinBrandChoicesTable,
          GtinBrandChoice,
          $$GtinBrandChoicesTableFilterComposer,
          $$GtinBrandChoicesTableOrderingComposer,
          $$GtinBrandChoicesTableAnnotationComposer,
          $$GtinBrandChoicesTableCreateCompanionBuilder,
          $$GtinBrandChoicesTableUpdateCompanionBuilder,
          (
            GtinBrandChoice,
            BaseReferences<
              _$AppDatabase,
              $GtinBrandChoicesTable,
              GtinBrandChoice
            >,
          ),
          GtinBrandChoice,
          PrefetchHooks Function()
        > {
  $$GtinBrandChoicesTableTableManager(
    _$AppDatabase db,
    $GtinBrandChoicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GtinBrandChoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GtinBrandChoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GtinBrandChoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gtin = const Value.absent(),
                Value<String> choiceKey = const Value.absent(),
                Value<String> brandId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GtinBrandChoicesCompanion(
                gtin: gtin,
                choiceKey: choiceKey,
                brandId: brandId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gtin,
                required String choiceKey,
                required String brandId,
                Value<int> rowid = const Value.absent(),
              }) => GtinBrandChoicesCompanion.insert(
                gtin: gtin,
                choiceKey: choiceKey,
                brandId: brandId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GtinBrandChoicesTable, GtinBrandChoice>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GtinBrandChoicesTable,
                    GtinBrandChoice
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GtinBrandChoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GtinBrandChoicesTable,
      GtinBrandChoice,
      $$GtinBrandChoicesTableFilterComposer,
      $$GtinBrandChoicesTableOrderingComposer,
      $$GtinBrandChoicesTableAnnotationComposer,
      $$GtinBrandChoicesTableCreateCompanionBuilder,
      $$GtinBrandChoicesTableUpdateCompanionBuilder,
      (
        GtinBrandChoice,
        BaseReferences<_$AppDatabase, $GtinBrandChoicesTable, GtinBrandChoice>,
      ),
      GtinBrandChoice,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScansTableTableManager get scans =>
      $$ScansTableTableManager(_db, _db.scans);
  $$ProductCacheEntriesTableTableManager get productCacheEntries =>
      $$ProductCacheEntriesTableTableManager(_db, _db.productCacheEntries);
  $$AlertExclusionsTableTableManager get alertExclusions =>
      $$AlertExclusionsTableTableManager(_db, _db.alertExclusions);
  $$GtinBrandChoicesTableTableManager get gtinBrandChoices =>
      $$GtinBrandChoicesTableTableManager(_db, _db.gtinBrandChoices);
}
