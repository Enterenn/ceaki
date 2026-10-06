import 'dart:convert';

import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/percent.dart';

enum OwnerKind { company, fortune }

enum LinkType { subsidiary, control, referenceShareholder, stake }

enum LinkStatus { active, historical }

final class OwnerRef {
  const OwnerRef(this.kind, this.id);

  final OwnerKind kind;
  final String id;
}

final class Source {
  const Source({
    required this.id,
    required this.title,
    required this.url,
    required this.publisher,
  });

  final String id;
  final String title;
  final String url;
  final String publisher;
}

final class Fortune {
  const Fortune({
    required this.id,
    required this.name,
    required this.aliases,
    required this.summary,
  });

  final String id;
  final String name;
  final List<String> aliases;
  final String summary;
}

final class Company {
  const Company({
    required this.id,
    required this.name,
    required this.aliases,
    required this.country,
    required this.siren,
    required this.role,
  });

  final String id;
  final String name;
  final List<String> aliases;
  final String country;
  final String? siren;
  final String role;
}

final class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.aliases,
    required this.sectors,
    required this.companyId,
    this.logoAsset,
    this.logoUrl,
    this.logoSource,
  });

  final String id;
  final String name;
  final List<String> aliases;
  final List<String> sectors;
  final String companyId;

  /// Local asset path, e.g. `assets/logos/grasset.png`.
  final String? logoAsset;

  /// Optional remote logo (https only); cached locally, never tracked.
  final String? logoUrl;

  /// Licence / provenance note for an embedded or remote logo.
  final String? logoSource;
}

final class Ownership {
  const Ownership({
    required this.ownedCompanyId,
    required this.owner,
    required this.capitalPercent,
    required this.votingPercent,
    required this.linkType,
    required this.factDate,
    required this.sourceId,
    required this.status,
    required this.note,
  });

  final String ownedCompanyId;
  final OwnerRef owner;
  final Percent? capitalPercent;
  final Percent? votingPercent;
  final LinkType linkType;
  final String factDate;
  final String? sourceId;
  final LinkStatus status;
  final String? note;
}

final class Library {
  Library({
    required this.version,
    required this.updatedOn,
    required this.sectors,
    required this.sources,
    required this.fortunes,
    required this.companies,
    required this.brands,
    required this.ownerships,
  }) : _brandsByKey = _indexBrands(brands),
       _byOwned = _groupOwned(ownerships),
       _byOwner = _groupOwner(ownerships),
       _companies = {for (final company in companies) company.id: company},
       _fortunes = {for (final fortune in fortunes) fortune.id: fortune},
       _sources = {for (final source in sources) source.id: source};

  final String version;
  final String updatedOn;
  final List<String> sectors;
  final List<Source> sources;
  final List<Fortune> fortunes;
  final List<Company> companies;
  final List<Brand> brands;
  final List<Ownership> ownerships;

  final Map<String, List<Brand>> _brandsByKey;
  final Map<String, List<Ownership>> _byOwned;
  final Map<String, List<Ownership>> _byOwner;
  final Map<String, Company> _companies;
  final Map<String, Fortune> _fortunes;
  final Map<String, Source> _sources;

  factory Library.parse(String source) {
    final root = _asMap(jsonDecode(source), 'library');
    return Library(
      version: _string(root, 'version'),
      updatedOn: _string(root, 'updatedOn'),
      sectors: _stringList(root['sectors'], 'sectors'),
      sources: _list(root, 'sources', _source),
      fortunes: _list(root, 'fortunes', _fortune),
      companies: _list(root, 'companies', _company),
      brands: _list(root, 'brands', _brand),
      ownerships: _list(root, 'ownerships', _ownership),
    );
  }

  Company company(String id) => _companies[id] ?? (throw StateError(id));

  Fortune fortune(String id) => _fortunes[id] ?? (throw StateError(id));

  Source source(String id) => _sources[id] ?? (throw StateError(id));

  Company? companyOrNull(String id) => _companies[id];

  Fortune? fortuneOrNull(String id) => _fortunes[id];

  Source? sourceOrNull(String id) => _sources[id];

  List<Brand> brandsForKey(String key) =>
      List.unmodifiable(_brandsByKey[key] ?? const []);

  List<Ownership> ownersOf(String companyId, LinkStatus status) {
    return [
      for (final link in _byOwned[companyId] ?? const <Ownership>[])
        if (link.status == status) link,
    ];
  }

  List<Ownership> holdingsOf(OwnerKind kind, String id, LinkStatus status) {
    final key = '${kind.name}:$id';
    return [
      for (final link in _byOwner[key] ?? const <Ownership>[])
        if (link.status == status) link,
    ];
  }
}

final class FortunePortfolio {
  const FortunePortfolio({required this.companies, required this.brands});

  final List<Company> companies;
  final List<Brand> brands;
}

FortunePortfolio descendFromFortune(
  Library library,
  String fortuneId, {
  int maxHops = 8,
}) {
  final seenDepth = <String, int>{};
  final queue = <(String, int)>[
    for (final link in library.holdingsOf(
      OwnerKind.fortune,
      fortuneId,
      LinkStatus.active,
    ))
      (link.ownedCompanyId, 1),
  ];
  var cursor = 0;
  while (cursor < queue.length) {
    final (id, depth) = queue[cursor++];
    final previous = seenDepth[id];
    if (previous != null && previous <= depth) continue;
    seenDepth[id] = depth;
    if (depth >= maxHops) continue;
    for (final link in library.holdingsOf(
      OwnerKind.company,
      id,
      LinkStatus.active,
    )) {
      queue.add((link.ownedCompanyId, depth + 1));
    }
  }

  final companies = [for (final id in seenDepth.keys) library.company(id)]
    ..sort((a, b) => a.name.compareTo(b.name));
  final brands =
      library.brands
          .where((brand) => seenDepth.containsKey(brand.companyId))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  return FortunePortfolio(companies: companies, brands: brands);
}

List<String> schemaIssues(Library library) {
  final issues = <String>[];

  void unique(String label, Iterable<String> ids) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) issues.add('$label en double : $id');
    }
  }

  unique('fortune', library.fortunes.map((item) => item.id));
  unique('société', library.companies.map((item) => item.id));
  unique('marque', library.brands.map((item) => item.id));
  unique('source', library.sources.map((item) => item.id));

  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(library.updatedOn) ||
      !_realDate(library.updatedOn)) {
    issues.add('updatedOn illisible');
  }

  for (final source in library.sources) {
    final uri = Uri.tryParse(source.url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      issues.add('source ${source.id} sans url https');
    }
  }

  for (final company in library.companies) {
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(company.country)) {
      issues.add('pays illisible : ${company.id}');
    }
  }

  for (final brand in library.brands) {
    if (library.companyOrNull(brand.companyId) == null) {
      issues.add('marque ${brand.id} vers une société absente');
    }
    for (final sector in brand.sectors) {
      if (!library.sectors.contains(sector)) {
        issues.add('secteur inconnu : $sector');
      }
    }
    final asset = brand.logoAsset;
    if (asset != null && !asset.startsWith('assets/logos/')) {
      issues.add('logoAsset hors assets/logos : ${brand.id}');
    }
    final url = brand.logoUrl;
    if (url != null) {
      final uri = Uri.tryParse(url);
      if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
        issues.add('logoUrl non https : ${brand.id}');
      }
    }
  }

  for (final link in library.ownerships) {
    if (library.companyOrNull(link.ownedCompanyId) == null) {
      issues.add('société détenue absente : ${link.ownedCompanyId}');
    }
    final ownerExists = switch (link.owner.kind) {
      OwnerKind.company => library.companyOrNull(link.owner.id) != null,
      OwnerKind.fortune => library.fortuneOrNull(link.owner.id) != null,
    };
    if (!ownerExists) issues.add('détenteur absent : ${link.owner.id}');
    if (!_realDate(link.factDate)) {
      issues.add('date impossible : ${link.factDate}');
    }
    if (link.status == LinkStatus.active &&
        (link.sourceId == null ||
            library.sourceOrNull(link.sourceId!) == null)) {
      issues.add('lien actif sans source : ${link.ownedCompanyId}');
    }
    if (link.sourceId != null && library.sourceOrNull(link.sourceId!) == null) {
      issues.add('source inconnue : ${link.sourceId}');
    }
  }

  return issues;
}

Map<String, List<Brand>> _indexBrands(List<Brand> brands) {
  final index = <String, List<Brand>>{};
  for (final brand in brands) {
    final keys = {
      normalizeBrandName(brand.name),
      for (final alias in brand.aliases) normalizeBrandName(alias),
    };
    for (final key in keys) {
      if (key.isEmpty) continue;
      final matches = index.putIfAbsent(key, () => []);
      if (matches.every((item) => item.id != brand.id)) matches.add(brand);
    }
  }
  return index;
}

Map<String, List<Ownership>> _groupOwned(List<Ownership> links) {
  final grouped = <String, List<Ownership>>{};
  for (final link in links) {
    grouped.putIfAbsent(link.ownedCompanyId, () => []).add(link);
  }
  return grouped;
}

Map<String, List<Ownership>> _groupOwner(List<Ownership> links) {
  final grouped = <String, List<Ownership>>{};
  for (final link in links) {
    final key = '${link.owner.kind.name}:${link.owner.id}';
    grouped.putIfAbsent(key, () => []).add(link);
  }
  return grouped;
}

bool _realDate(String value) {
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return false;
  final parts = value.split('-');
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return false;
  return parsed.year == int.parse(parts[0]) &&
      parsed.month == int.parse(parts[1]) &&
      parsed.day == int.parse(parts[2]);
}

Map<String, dynamic> _asMap(Object? value, String path) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry('$key', item));
  }
  throw FormatException(path);
}

String _string(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException(key);
}

String? _optionalString(Map<String, dynamic> map, String key) {
  if (!map.containsKey(key)) throw FormatException(key);
  final value = map[key];
  if (value == null) return null;
  if (value is String) return value;
  throw FormatException(key);
}

/// Optional field that may be omitted from JSON entirely.
String? _maybeString(Map<String, dynamic> map, String key) {
  if (!map.containsKey(key)) return null;
  final value = map[key];
  if (value == null) return null;
  if (value is String) {
    return value.isEmpty ? null : value;
  }
  throw FormatException(key);
}

List<String> _stringList(Object? value, String path) {
  if (value is! List) throw FormatException(path);
  return [
    for (final item in value)
      if (item is String) item else throw FormatException(path),
  ];
}

List<T> _list<T>(
  Map<String, dynamic> map,
  String key,
  T Function(Map<String, dynamic> json) read,
) {
  final value = map[key];
  if (value is! List) throw FormatException(key);
  return [for (final item in value) read(_asMap(item, key))];
}

Source _source(Map<String, dynamic> json) {
  return Source(
    id: _string(json, 'id'),
    title: _string(json, 'title'),
    url: _string(json, 'url'),
    publisher: _string(json, 'publisher'),
  );
}

Fortune _fortune(Map<String, dynamic> json) {
  return Fortune(
    id: _string(json, 'id'),
    name: _string(json, 'name'),
    aliases: _stringList(json['aliases'], 'aliases'),
    summary: _string(json, 'summary'),
  );
}

Company _company(Map<String, dynamic> json) {
  return Company(
    id: _string(json, 'id'),
    name: _string(json, 'name'),
    aliases: _stringList(json['aliases'], 'aliases'),
    country: _string(json, 'country'),
    siren: _optionalString(json, 'siren'),
    role: _string(json, 'role'),
  );
}

Brand _brand(Map<String, dynamic> json) {
  return Brand(
    id: _string(json, 'id'),
    name: _string(json, 'name'),
    aliases: _stringList(json['aliases'], 'aliases'),
    sectors: _stringList(json['sectors'], 'sectors'),
    companyId: _string(json, 'companyId'),
    logoAsset: _maybeString(json, 'logoAsset'),
    logoUrl: _maybeString(json, 'logoUrl'),
    logoSource: _maybeString(json, 'logoSource'),
  );
}

Ownership _ownership(Map<String, dynamic> json) {
  final owner = _asMap(json['owner'], 'owner');
  final kind = switch (owner['type']) {
    'company' => OwnerKind.company,
    'fortune' => OwnerKind.fortune,
    _ => throw const FormatException('owner.type'),
  };
  return Ownership(
    ownedCompanyId: _string(json, 'ownedCompanyId'),
    owner: OwnerRef(kind, _string(owner, 'id')),
    capitalPercent: _percent(json, 'capitalPercent'),
    votingPercent: _percent(json, 'votingPercent'),
    linkType: _linkType(_string(json, 'linkType')),
    factDate: _string(json, 'factDate'),
    sourceId: _optionalString(json, 'sourceId'),
    status: _status(_string(json, 'status')),
    note: _optionalString(json, 'note'),
  );
}

Percent? _percent(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key)) throw FormatException(key);
  final value = json[key];
  if (value == null) return null;
  return Percent.parse(value, key);
}

LinkType _linkType(String value) {
  return switch (value) {
    'subsidiary' => LinkType.subsidiary,
    'control' => LinkType.control,
    'reference_shareholder' => LinkType.referenceShareholder,
    'stake' => LinkType.stake,
    _ => throw FormatException(value),
  };
}

LinkStatus _status(String value) {
  return switch (value) {
    'active' => LinkStatus.active,
    'historical' => LinkStatus.historical,
    _ => throw FormatException(value),
  };
}
