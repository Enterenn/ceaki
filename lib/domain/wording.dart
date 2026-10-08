import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/percent.dart';
import 'package:transparence/domain/resolve.dart';

const grandeFortuneTitle = 'Grande fortune';

const noDocumentedFortuneLabel = 'Pas de grande fortune repérée';

const currentOwnerUndocumentedLabel = 'Propriétaire actuel non documenté';

const _months = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

final class FortuneBanner {
  const FortuneBanner({
    required this.fortuneId,
    required this.title,
    required this.punch,
    required this.detail,
  });

  final String fortuneId;
  final String title;

  /// Short decision line shown first.
  final String punch;

  /// Ownership figures, shown under « Pourquoi ? ».
  final String detail;

  String get body => detail.isEmpty ? punch : '$punch $detail';
}

String frenchDate(String iso) {
  final parts = iso.split('-');
  final day = int.parse(parts[2]);
  final month = _months[int.parse(parts[1]) - 1];
  return '$day $month ${parts[0]}';
}

String sectorLabel(String sector) {
  return switch (sector) {
    'edition' => 'édition',
    'presse' => 'presse',
    'jeu' => 'jeu de société',
    'telecom' => 'télécom',
    'media' => 'média',
    'alimentaire' => 'alimentaire',
    'hygiene' => 'hygiène',
    'distribution' => 'distribution',
    'luxe' => 'luxe',
    _ => sector,
  };
}

String linkTypeLabel(LinkType type) {
  return switch (type) {
    LinkType.subsidiary => 'filiale',
    LinkType.control => 'contrôle',
    LinkType.referenceShareholder => 'actionnaire de référence',
    LinkType.stake => 'participation',
  };
}

String shareLine({
  required Percent? capital,
  required Percent? voting,
  required LinkType linkType,
}) {
  final shares = _sharePhrase(capital, voting);
  final type = linkTypeLabel(linkType);
  if (shares == null) return type;
  return '$shares · $type';
}

String ownershipFigures(Ownership link) {
  return shareLine(
    capital: link.capitalPercent,
    voting: link.votingPercent,
    linkType: link.linkType,
  );
}

String labelFor(ChainState state) {
  return switch (state) {
    ChainState.signaled => grandeFortuneTitle,
    ChainState.alertMuted => '',
    ChainState.noDocumentedFortune => noDocumentedFortuneLabel,
    ChainState.currentOwnerUndocumented => currentOwnerUndocumentedLabel,
  };
}

List<FortuneBanner> bannersFor({
  required Library library,
  required BrandChain chain,
  required Set<String> excludedFortuneIds,
}) {
  return [
    for (final fortuneId in chain.chain.fortuneIds)
      if (!excludedFortuneIds.contains(fortuneId))
        FortuneBanner(
          fortuneId: fortuneId,
          title: library.fortune(fortuneId).name,
          punch: _bannerPunch(library.fortune(fortuneId).name),
          detail: _bannerDetail(library, chain, fortuneId),
        ),
  ];
}

List<String> documentedOwnerNames(Library library, List<BrandChain> chains) {
  final names = <String>[];
  for (final chain in chains) {
    for (final holding in chain.chain.owners) {
      final name = switch (holding.owner.kind) {
        OwnerKind.company => library.company(holding.owner.id).name,
        OwnerKind.fortune => library.fortune(holding.owner.id).name,
      };
      if (!names.contains(name)) names.add(name);
    }
  }
  return names;
}

String putBackLine(List<String> fortuneNames) {
  if (fortuneNames.isEmpty) {
    throw ArgumentError.value(fortuneNames, 'fortuneNames');
  }
  final subject = fortuneNames.length == 1
      ? fortuneWithArticle(fortuneNames.single)
      : '${fortuneNames.sublist(0, fortuneNames.length - 1).map(fortuneWithArticle).join(', ')} et ${fortuneWithArticle(fortuneNames.last)}';
  final verb = fortuneNames.length == 1 ? "n'aura pas" : "n'auront pas";
  return 'Reposé. $subject $verb celui-ci.';
}

/// Adds a French article when the fortune label starts with « famille ».
String fortuneWithArticle(String fortuneName) {
  final name = fortuneName.trim();
  final lower = name.toLowerCase();
  if (lower.startsWith('la ') ||
      lower.startsWith('le ') ||
      lower.startsWith('les ')) {
    return name;
  }
  if (lower.startsWith('famille ')) return 'la $name';
  return name;
}

String _bannerPunch(String fortuneName) {
  return 'Acheter ça, c’est mettre des sous dans la poche de ${fortuneWithArticle(fortuneName)}.';
}

String _bannerDetail(Library library, BrandChain chain, String fortuneId) {
  final hops = pathToFortune(chain.chain, fortuneId).reversed.toList();
  final clauses = <String>[];
  final dates = <String>[];

  for (final hop in hops) {
    final shares = _sharePhrase(hop.capitalPercent, hop.votingPercent);
    final owned = library.company(hop.ownedCompanyId).name;
    if (hop.owner.kind == OwnerKind.fortune && shares == null) continue;
    final owner = _ownerName(library, hop.owner);
    final action = shares == null
        ? 'a un lien « ${linkTypeLabel(hop.linkType)} » vers $owned'
        : 'détient $shares de $owned';
    clauses.add(clauses.isEmpty ? '$owner $action' : action);
    dates.add(hop.factDate);
  }

  final sentence = StringBuffer('${chain.brand.name} y est rattaché.');
  if (clauses.isNotEmpty) {
    final sameDate = dates.toSet().length == 1;
    final rendered = [
      for (var i = 0; i < clauses.length; i++)
        sameDate
            ? clauses[i]
            : '${clauses[i]} (chiffres au ${frenchDate(dates[i])})',
    ];
    final suffix = sameDate ? ' (chiffres au ${frenchDate(dates.first)})' : '';
    sentence.write(' ${_joinClauses(rendered)}$suffix.');
  }
  return sentence.toString();
}

String _joinClauses(List<String> clauses) {
  if (clauses.length == 1) return clauses.single;
  return '${clauses.first}, qui ${clauses.skip(1).join(', qui ')}';
}

String _ownerName(Library library, OwnerRef owner) {
  return switch (owner.kind) {
    OwnerKind.company => library.company(owner.id).name,
    OwnerKind.fortune => library.fortune(owner.id).name,
  };
}

String? _sharePhrase(Percent? capital, Percent? voting) {
  final parts = <String>[
    if (capital != null) '${capital.french} % du capital',
    if (voting != null) '${voting.french} % des droits de vote',
  ];
  if (parts.isEmpty) return null;
  return parts.join(' et ');
}
