import 'package:flutter/material.dart';
import 'package:transparence/domain/player_rank.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/fiche_chrome.dart';
import 'package:transparence/ui/theme.dart';

/// Soft milestone card — paliers 1 / 10 / 50 without RPG chrome.
class RankCard extends StatelessWidget {
  const RankCard({required this.rank, super.key});

  final PlayerRank rank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return FichePanel(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rankEsquives(rank.esquives),
            style: theme.textTheme.titleMedium?.copyWith(
              fontVariations: const [FontVariation('wght', 700)],
            ),
          ),
          if (rank.hasMilestone) ...[
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: TransparenceColors.lime,
                borderRadius: TransparenceRadii.all,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  rank.title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: TransparenceColors.ink,
                    fontVariations: const [FontVariation('wght', 700)],
                  ),
                ),
              ),
            ),
          ],
          if (!rank.isMax) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: TransparenceRadii.all,
              child: LinearProgressIndicator(
                value: rank.progress,
                minHeight: 4,
                backgroundColor: TransparenceColors.mist,
                color: TransparenceColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.rankNextAt(rank.nextAt!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: TransparenceColors.mute,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
