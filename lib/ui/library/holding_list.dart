import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';

class HoldingList extends StatelessWidget {
  const HoldingList({required this.library, required this.holdings, super.key});

  final Library library;
  final List<Holding> holdings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final holding in holdings)
          _HoldingTile(library: library, holding: holding, depth: 0),
      ],
    );
  }
}

class _HoldingTile extends StatelessWidget {
  const _HoldingTile({
    required this.library,
    required this.holding,
    required this.depth,
  });

  final Library library;
  final Holding holding;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = switch (holding.owner.kind) {
      OwnerKind.company => library.company(holding.owner.id).name,
      OwnerKind.fortune => library.fortune(holding.owner.id).name,
    };
    final shares = shareLine(
      capital: holding.capitalPercent,
      voting: holding.votingPercent,
      linkType: holding.linkType,
    );
    return Padding(
      padding: EdgeInsets.only(left: 16.0 * depth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(name),
            subtitle: Text('$shares\n${frenchDate(holding.factDate)}'),
          ),
          if (holding.stoppedForDepth)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.chainCut),
            ),
          if (holding.stoppedForCycle)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.alreadySeen),
            ),
          for (final next in holding.above)
            _HoldingTile(library: library, holding: next, depth: depth + 1),
        ],
      ),
    );
  }
}
