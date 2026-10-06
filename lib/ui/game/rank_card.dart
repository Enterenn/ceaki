import 'package:flutter/material.dart';
import 'package:transparence/domain/player_rank.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/theme.dart';

/// Quiet progress strip — levels without the arcade chrome.
class RankCard extends StatelessWidget {
  const RankCard({required this.rank, super.key});

  final PlayerRank rank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rank.title,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.rankEsquives(rank.esquives),
          style: theme.textTheme.bodySmall?.copyWith(
            color: TransparenceColors.mute,
          ),
        ),
        if (!rank.isMax) ...[
          const SizedBox(height: 10),
          ClipRRect(
            child: LinearProgressIndicator(
              value: rank.progress,
              minHeight: 3,
              backgroundColor: TransparenceColors.mist,
              color: TransparenceColors.ink,
            ),
          ),
        ],
      ],
    );
  }
}
