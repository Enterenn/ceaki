import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/holding_list.dart';

class PathChain extends StatelessWidget {
  const PathChain({
    required this.library,
    required this.owners,
    required this.path,
    super.key,
  });

  final Library library;
  final List<Holding> owners;
  final List<Holding> path;

  @override
  Widget build(BuildContext context) {
    final head = path.isEmpty ? null : path.first;
    final primary = [
      for (final owner in owners)
        if (head != null && owner.owner.id == head.owner.id) owner,
    ];
    final others = [
      for (final owner in owners)
        if (head == null || owner.owner.id != head.owner.id) owner,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final holding in primary) ...[
          _OwnerTile(library: library, holding: holding),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: PathChain(
              library: library,
              owners: holding.above,
              path: path.skip(1).toList(),
            ),
          ),
        ],
        if (others.isNotEmpty)
          _OtherShareholders(library: library, holdings: others),
      ],
    );
  }
}

class _OwnerTile extends StatelessWidget {
  const _OwnerTile({required this.library, required this.holding});

  final Library library;
  final Holding holding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = switch (holding.owner.kind) {
      OwnerKind.company => library.company(holding.owner.id).name,
      OwnerKind.fortune => library.fortune(holding.owner.id).name,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(name),
          subtitle: Text(
            '${shareLine(capital: holding.capitalPercent, voting: holding.votingPercent, linkType: holding.linkType)}\n${frenchDate(holding.factDate)}',
          ),
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
      ],
    );
  }
}

class _OtherShareholders extends StatefulWidget {
  const _OtherShareholders({required this.library, required this.holdings});

  final Library library;
  final List<Holding> holdings;

  @override
  State<_OtherShareholders> createState() => _OtherShareholdersState();
}

class _OtherShareholdersState extends State<_OtherShareholders> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => setState(() => _open = !_open),
          child: Text(AppLocalizations.of(context).otherShareholders),
        ),
        if (_open)
          HoldingList(library: widget.library, holdings: widget.holdings),
      ],
    );
  }
}
