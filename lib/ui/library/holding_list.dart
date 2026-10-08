import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/theme.dart';

class HoldingList extends StatelessWidget {
  const HoldingList({required this.library, required this.holdings, super.key});

  final Library library;
  final List<Holding> holdings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < holdings.length; i++)
          _HoldingTile(
            library: library,
            holding: holdings[i],
            depth: 0,
            isLast: i == holdings.length - 1,
          ),
      ],
    );
  }
}

class _HoldingTile extends StatelessWidget {
  const _HoldingTile({
    required this.library,
    required this.holding,
    required this.depth,
    required this.isLast,
  });

  final Library library;
  final Holding holding;
  final int depth;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = switch (holding.owner.kind) {
      OwnerKind.company => library.company(holding.owner.id).name,
      OwnerKind.fortune => library.fortune(holding.owner.id).name,
    };
    final shares = shareLine(
      capital: holding.capitalPercent,
      voting: holding.votingPercent,
      linkType: holding.linkType,
    );
    final above = holding.above;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (depth > 0)
            SizedBox(
              width: 22,
              child: CustomPaint(
                painter: _TreeGuidePainter(
                  color: TransparenceColors.ink.withValues(alpha: 0.28),
                  drawContinuation: !isLast,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(depth == 0 ? 16 : 4, 6, 16, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        shares,
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
                    ],
                  ),
                ),
                if (holding.stoppedForDepth)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(l10n.chainCut),
                  ),
                if (holding.stoppedForCycle)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(l10n.alreadySeen),
                  ),
                for (var i = 0; i < above.length; i++)
                  _HoldingTile(
                    library: library,
                    holding: above[i],
                    depth: depth + 1,
                    isLast: i == above.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical guide + elbow into the row — reads nested ownership levels.
class _TreeGuidePainter extends CustomPainter {
  _TreeGuidePainter({
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
    final midY = 22.0;
    // Stem from top to elbow (and optionally below for siblings).
    canvas.drawLine(Offset(x, 0), Offset(x, midY), paint);
    if (drawContinuation) {
      canvas.drawLine(Offset(x, midY), Offset(x, size.height), paint);
    }
    // Elbow toward the label.
    canvas.drawLine(Offset(x, midY), Offset(size.width - 2, midY), paint);
  }

  @override
  bool shouldRepaint(covariant _TreeGuidePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawContinuation != drawContinuation;
  }
}
