import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/percent.dart';

final class Holding {
  const Holding({
    required this.owner,
    required this.ownedCompanyId,
    required this.capitalPercent,
    required this.votingPercent,
    required this.linkType,
    required this.factDate,
    required this.sourceId,
    required this.note,
    required this.above,
    required this.stoppedForDepth,
    required this.stoppedForCycle,
  });

  final OwnerRef owner;
  final String ownedCompanyId;
  final Percent? capitalPercent;
  final Percent? votingPercent;
  final LinkType linkType;
  final String factDate;
  final String? sourceId;
  final String? note;
  final List<Holding> above;
  final bool stoppedForDepth;
  final bool stoppedForCycle;
}

final class CompanyChain {
  const CompanyChain({
    required this.companyId,
    required this.owners,
    required this.historical,
  });

  final String companyId;
  final List<Holding> owners;
  final List<Ownership> historical;

  bool get hasActiveOwner => owners.isNotEmpty;

  List<String> get fortuneIds {
    final ids = <String>[];
    void walk(Holding holding) {
      if (holding.owner.kind == OwnerKind.fortune &&
          !ids.contains(holding.owner.id)) {
        ids.add(holding.owner.id);
      }
      for (final next in holding.above) {
        walk(next);
      }
    }

    for (final owner in owners) {
      walk(owner);
    }
    return ids;
  }
}

final class BrandChain {
  const BrandChain({required this.brand, required this.chain});

  final Brand brand;
  final CompanyChain chain;
}

enum ChainState {
  signaled,
  alertMuted,
  noDocumentedFortune,
  currentOwnerUndocumented,
}

ChainState chainState(CompanyChain chain, Set<String> excludedFortuneIds) {
  final reached = chain.fortuneIds;
  if (reached.isEmpty) {
    return chain.hasActiveOwner
        ? ChainState.noDocumentedFortune
        : ChainState.currentOwnerUndocumented;
  }
  final signaled = reached.where((id) => !excludedFortuneIds.contains(id));
  return signaled.isEmpty ? ChainState.alertMuted : ChainState.signaled;
}

CompanyChain resolveCompany(
  Library library,
  String companyId, {
  int maxHops = 8,
}) {
  final visited = <String>{companyId};
  return CompanyChain(
    companyId: companyId,
    owners: [
      for (final link in library.ownersOf(companyId, LinkStatus.active))
        _expand(library, link, 1, maxHops, visited),
    ],
    historical: library.ownersOf(companyId, LinkStatus.historical),
  );
}

BrandChain resolveBrand(Library library, Brand brand, {int maxHops = 8}) {
  return BrandChain(
    brand: brand,
    chain: resolveCompany(library, brand.companyId, maxHops: maxHops),
  );
}

final class BrandLookup {
  const BrandLookup({
    required this.rawName,
    required this.key,
    required this.brands,
  });

  final String rawName;
  final String key;
  final List<Brand> brands;
}

final class ResolvedNames {
  const ResolvedNames({
    required this.chains,
    required this.choices,
    required this.unmatched,
  });

  final List<BrandChain> chains;
  final List<BrandLookup> choices;
  final List<BrandLookup> unmatched;
}

ResolvedNames resolveBrandNames(
  Library library,
  List<String> names, {
  Map<String, String> chosenIds = const {},
}) {
  final chains = <BrandChain>[];
  final choices = <BrandLookup>[];
  final unmatched = <BrandLookup>[];

  for (final name in names) {
    final key = normalizeBrandName(name);
    final lookup = BrandLookup(
      rawName: name,
      key: key,
      brands: library.brandsForKey(key),
    );
    if (lookup.brands.isEmpty) {
      unmatched.add(lookup);
      continue;
    }
    if (lookup.brands.length == 1) {
      chains.add(resolveBrand(library, lookup.brands.single));
      continue;
    }
    final chosenId = chosenIds[key];
    Brand? chosen;
    for (final brand in lookup.brands) {
      if (brand.id == chosenId) {
        chosen = brand;
        break;
      }
    }
    if (chosen == null) {
      choices.add(lookup);
    } else {
      chains.add(resolveBrand(library, chosen));
    }
  }

  return ResolvedNames(chains: chains, choices: choices, unmatched: unmatched);
}

List<Holding> pathToFortune(CompanyChain chain, String fortuneId) {
  for (final owner in chain.owners) {
    final path = _path(owner, fortuneId);
    if (path != null) return path;
  }
  return const [];
}

Holding _expand(
  Library library,
  Ownership link,
  int hop,
  int maxHops,
  Set<String> visited,
) {
  final owner = link.owner;
  var above = const <Holding>[];
  var stoppedForDepth = false;
  var stoppedForCycle = false;

  if (owner.kind == OwnerKind.company) {
    if (visited.contains(owner.id)) {
      stoppedForCycle = true;
    } else if (hop >= maxHops) {
      stoppedForDepth = library
          .ownersOf(owner.id, LinkStatus.active)
          .isNotEmpty;
    } else {
      visited.add(owner.id);
      above = [
        for (final next in library.ownersOf(owner.id, LinkStatus.active))
          _expand(library, next, hop + 1, maxHops, visited),
      ];
    }
  }

  return Holding(
    owner: owner,
    ownedCompanyId: link.ownedCompanyId,
    capitalPercent: link.capitalPercent,
    votingPercent: link.votingPercent,
    linkType: link.linkType,
    factDate: link.factDate,
    sourceId: link.sourceId,
    note: link.note,
    above: above,
    stoppedForDepth: stoppedForDepth,
    stoppedForCycle: stoppedForCycle,
  );
}

List<Holding>? _path(Holding node, String fortuneId) {
  if (node.owner.kind == OwnerKind.fortune && node.owner.id == fortuneId) {
    return [node];
  }
  for (final next in node.above) {
    final rest = _path(next, fortuneId);
    if (rest != null) return [node, ...rest];
  }
  return null;
}
