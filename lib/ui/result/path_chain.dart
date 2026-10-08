import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/holding_list.dart';
import 'package:transparence/ui/theme.dart';

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
    if (path.isEmpty) {
      return HoldingList(library: library, holdings: owners);
    }
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
        for (var i = 0; i < primary.length; i++) ...[
          _OwnerTile(library: library, holding: primary[i], depth: 0),
          _NestedPath(
            library: library,
            owners: primary[i].above,
            path: path.skip(1).toList(),
            depth: 1,
          ),
        ],
        if (others.isNotEmpty)
          _OtherShareholders(library: library, holdings: others),
      ],
    );
  }
}

class _NestedPath extends StatelessWidget {
  const _NestedPath({
    required this.library,
    required this.owners,
    required this.path,
    required this.depth,
  });

  final Library library;
  final List<Holding> owners;
  final List<Holding> path;
  final int depth;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return Column(
        children: [
          for (var i = 0; i < owners.length; i++)
            _OwnerBranch(
              library: library,
              holding: owners[i],
              depth: depth,
              isLast: i == owners.length - 1,
            ),
        ],
      );
    }
    final head = path.first;
    final primary = [
      for (final owner in owners)
        if (owner.owner.id == head.owner.id) owner,
    ];
    final others = [
      for (final owner in owners)
        if (owner.owner.id != head.owner.id) owner,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < primary.length; i++)
          _OwnerBranch(
            library: library,
            holding: primary[i],
            depth: depth,
            isLast: i == primary.length - 1 && others.isEmpty,
            child: _NestedPath(
              library: library,
              owners: primary[i].above,
              path: path.skip(1).toList(),
              depth: depth + 1,
            ),
          ),
        if (others.isNotEmpty)
          _OtherShareholders(library: library, holdings: others),
      ],
    );
  }
}

class _OwnerBranch extends StatelessWidget {
  const _OwnerBranch({
    required this.library,
    required this.holding,
    required this.depth,
    required this.isLast,
    this.child,
  });

  final Library library;
  final Holding holding;
  final int depth;
  final bool isLast;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (depth > 0)
            SizedBox(
              width: 22,
              child: CustomPaint(
                painter: _PathGuidePainter(
                  color: TransparenceColors.ink.withValues(alpha: 0.28),
                  drawContinuation: !isLast,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OwnerTile(library: library, holding: holding, depth: depth),
                if (child != null) child!,
                if (child == null)
                  for (var i = 0; i < holding.above.length; i++)
                    _OwnerBranch(
                      library: library,
                      holding: holding.above[i],
                      depth: depth + 1,
                      isLast: i == holding.above.length - 1,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerTile extends StatelessWidget {
  const _OwnerTile({
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
    final theme = Theme.of(context);
    final name = switch (holding.owner.kind) {
      OwnerKind.company => library.company(holding.owner.id).name,
      OwnerKind.fortune => library.fortune(holding.owner.id).name,
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(depth == 0 ? 16 : 4, 6, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            shareLine(
              capital: holding.capitalPercent,
              voting: holding.votingPercent,
              linkType: holding.linkType,
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: TransparenceColors.mute,
            ),
          ),
          Text(
            frenchDate(holding.factDate),
            style: theme.textTheme.bodySmall?.copyWith(
              color: TransparenceColors.mute,
            ),
          ),
          if (holding.stoppedForDepth) ...[
            const SizedBox(height: 4),
            Text(l10n.chainCut),
          ],
          if (holding.stoppedForCycle) ...[
            const SizedBox(height: 4),
            Text(l10n.alreadySeen),
          ],
        ],
      ),
    );
  }
}

class _PathGuidePainter extends CustomPainter {
  _PathGuidePainter({
    required this.color,
    required this.drawContinuation,
  });

  final Color color;
  final bool drawContinuation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final x = size.width * 0.35;
    const midY = 22.0;
    canvas.drawLine(Offset(x, 0), Offset(x, midY), paint);
    if (drawContinuation) {
      canvas.drawLine(Offset(x, midY), Offset(x, size.height), paint);
    }
    canvas.drawLine(Offset(x, midY), Offset(size.width - 2, midY), paint);
  }

  @override
  bool shouldRepaint(covariant _PathGuidePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawContinuation != drawContinuation;
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
