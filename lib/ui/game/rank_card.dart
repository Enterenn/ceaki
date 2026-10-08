import 'package:flutter/material.dart';
import 'package:transparence/domain/player_rank.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/chrome/stamp_tag.dart';
import 'package:transparence/ui/theme.dart';

/// Soft milestone — lime B block with a thick progress bar.
class RankCard extends StatelessWidget {
  const RankCard({required this.rank, super.key});

  final PlayerRank rank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: TransparenceTiles.rank,
        borderRadius: TransparenceRadii.tile,
        boxShadow: TransparenceShadows.stampStrong,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rankEsquives(rank.esquives),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: TransparenceColors.ink,
                fontVariations: const [FontVariation('wght', 800)],
                letterSpacing: -0.4,
              ),
            ),
            if (rank.hasMilestone) ...[
              const SizedBox(height: 12),
              StampTag(
                label: rank.title,
                background: TransparenceColors.ink,
                foreground: TransparenceColors.lime,
              ),
            ],
            if (!rank.isMax) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: TransparenceRadii.all,
                child: LinearProgressIndicator(
                  value: rank.progress,
                  minHeight: 10,
                  backgroundColor: TransparenceColors.ink.withValues(alpha: 0.12),
                  color: TransparenceColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.rankNextAt(rank.nextAt!),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: TransparenceColors.ink.withValues(alpha: 0.65),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
