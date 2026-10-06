import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/notebook.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';

enum ScanIssue { resolved, brandUnknown, productUnknown, offline }

final class ScanView {
  const ScanView({
    required this.issue,
    required this.gtin,
    required this.title,
    required this.creator,
    required this.brandLabel,
    required this.category,
    required this.banners,
    required this.chains,
    required this.choices,
    required this.unmatched,
    required this.fortuneIds,
    required this.fortuneNames,
    required this.choice,
    required this.sources,
    required this.state,
  });

  final ScanIssue issue;
  final String gtin;
  final String? title;
  final String? creator;
  final String? brandLabel;
  final String? category;
  final List<FortuneBanner> banners;
  final List<BrandChain> chains;
  final List<BrandLookup> choices;
  final List<BrandLookup> unmatched;
  final List<String> fortuneIds;
  final List<String> fortuneNames;
  final ScanChoice? choice;
  final List<Source> sources;
  final ChainState? state;
}

final class Attachment {
  const Attachment({
    required this.issue,
    required this.resolved,
    required this.fortuneIds,
    required this.fortuneNames,
  });

  final ScanIssue issue;
  final ResolvedNames resolved;
  final List<String> fortuneIds;
  final List<String> fortuneNames;
}

Attachment attachmentOf({
  required Library library,
  required List<String> names,
  required Map<String, String> chosenIds,
  required ScanIssue issue,
  required Set<String> excludedFortuneIds,
}) {
  final resolved = names.isEmpty
      ? const ResolvedNames(chains: [], choices: [], unmatched: [])
      : resolveBrandNames(library, names, chosenIds: chosenIds);
  final signaled = _signaled(library, resolved.chains, excludedFortuneIds);
  return Attachment(
    issue: _issue(issue, resolved, names),
    resolved: resolved,
    fortuneIds: signaled.$1,
    fortuneNames: signaled.$2,
  );
}

ScanView describeScan(
  Library library,
  Scan scan, {
  required Set<String> excludedFortuneIds,
}) {
  final stored = _storedIssue(scan.issue);
  final names = splitFields(scan.brandNames);
  final attachment = attachmentOf(
    library: library,
    names: names,
    chosenIds: decodeChoices(scan.chosenBrandIds),
    issue: stored == ScanIssue.brandUnknown ? ScanIssue.resolved : stored,
    excludedFortuneIds: excludedFortuneIds,
  );
  final choice = switch (scan.choice) {
    'put_back' => ScanChoice.putBack,
    'bought' => ScanChoice.bought,
    _ => null,
  };
  final remembered = choice == ScanChoice.putBack;
  final chains = attachment.resolved.chains;
  return ScanView(
    issue: attachment.issue,
    gtin: scan.gtin,
    title: _text(scan.productName),
    creator: _text(scan.creator),
    brandLabel: _brandLabel(chains, names),
    category: scan.category,
    banners: [
      for (final chain in chains)
        ...bannersFor(
          library: library,
          chain: chain,
          excludedFortuneIds: excludedFortuneIds,
        ),
    ],
    chains: chains,
    choices: attachment.resolved.choices,
    unmatched: attachment.resolved.unmatched,
    fortuneIds: remembered
        ? splitFields(scan.signaledFortuneIds)
        : attachment.fortuneIds,
    fortuneNames: remembered
        ? splitFields(scan.signaledFortuneNames)
        : attachment.fortuneNames,
    choice: choice,
    sources: _sources(library, chains),
    state: _state(chains, excludedFortuneIds),
  );
}

ScanIssue _storedIssue(String name) {
  if (name == 'notABook') return ScanIssue.productUnknown;
  return ScanIssue.values.byName(name);
}

ScanIssue _issue(ScanIssue issue, ResolvedNames resolved, List<String> names) {
  final known = issue == ScanIssue.resolved && names.isNotEmpty;
  if (known && resolved.chains.isEmpty && resolved.choices.isEmpty) {
    return ScanIssue.brandUnknown;
  }
  return issue;
}

(List<String>, List<String>) _signaled(
  Library library,
  List<BrandChain> chains,
  Set<String> excludedFortuneIds,
) {
  final ids = <String>[];
  final names = <String>[];
  for (final chain in chains) {
    if (chainState(chain.chain, excludedFortuneIds) != ChainState.signaled) {
      continue;
    }
    for (final id in chain.chain.fortuneIds) {
      if (excludedFortuneIds.contains(id) || ids.contains(id)) continue;
      ids.add(id);
      names.add(library.fortune(id).name);
    }
  }
  return (ids, names);
}

ChainState? _state(List<BrandChain> chains, Set<String> excludedFortuneIds) {
  ChainState? state;
  for (final chain in chains) {
    final next = chainState(chain.chain, excludedFortuneIds);
    if (next == ChainState.signaled) return next;
    state ??= next;
  }
  return state;
}

String? _brandLabel(List<BrandChain> chains, List<String> names) {
  if (chains.isNotEmpty) {
    return chains.map((chain) => chain.brand.name).join(', ');
  }
  if (names.isEmpty) return null;
  return names.map(displayBrandName).where((name) => name.isNotEmpty).join(', ');
}

List<Source> _sources(Library library, List<BrandChain> chains) {
  final ids = <String>[];
  void add(String? id) {
    if (id != null && !ids.contains(id)) ids.add(id);
  }

  void walk(Holding holding) {
    add(holding.sourceId);
    for (final next in holding.above) {
      walk(next);
    }
  }

  for (final chain in chains) {
    for (final owner in chain.chain.owners) {
      walk(owner);
    }
    for (final link in chain.chain.historical) {
      add(link.sourceId);
    }
  }
  return [for (final id in ids) ?library.sourceOrNull(id)];
}

String? _text(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value.trim();
}
