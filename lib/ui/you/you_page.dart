import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/app_version.dart';
import 'package:transparence/application/notebook_lines.dart';
import 'package:transparence/application/player_stats.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/game/rank_card.dart';
import 'package:transparence/ui/library/fiche_chrome.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/shell/hub_header.dart';
import 'package:transparence/ui/theme.dart';
import 'package:transparence/ui/you/about_page.dart';
import 'package:transparence/ui/you/data_page.dart';
import 'package:transparence/ui/you/history_page.dart';

/// Carnet hub — reposés, paliers soft, liens.
class YouPage extends ConsumerWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rank = ref.watch(playerRankProvider);
    final notebook = ref.watch(notebookProvider);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            children: [
              HubHeader(
                title: l10n.navYou,
                subtitle: l10n.notebookSub,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: rank.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (value) => RankCard(rank: value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                child: Text(
                  l10n.notebookTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: notebook.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (lines) {
                    if (lines.isEmpty) {
                      return FichePanel(
                        margin: EdgeInsets.zero,
                        accent: TransparenceColors.mist,
                        color: TransparenceColors.mist,
                        lifted: false,
                        child: Text(
                          l10n.notebookEmpty,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: TransparenceColors.mute,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final line in lines) ...[
                          _NotebookRow(
                            countLabel:
                                l10n.notebookLine(line.name, line.count),
                            count: line.count,
                            onTap: () => _open(
                              context,
                              FortunePage(fortuneId: line.fortuneId),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                child: Column(
                  children: [
                    FicheNavRow(
                      title: l10n.scanHistoryTitle,
                      subtitle: l10n.profileHistorySub,
                      onTap: () => _open(context, const HistoryPage()),
                    ),
                    FicheNavRow(
                      title: l10n.profileDataTitle,
                      subtitle: l10n.profileDataSub,
                      onTap: () => _open(context, const DataPage()),
                    ),
                    FicheNavRow(
                      title: l10n.profileAboutTitle,
                      subtitle: l10n.profileAboutSub,
                      onTap: () => _open(context, const AboutPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Center(
              child: Text(
                l10n.appVersionValue(publishedAppVersion),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: TransparenceColors.mute,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _NotebookRow extends StatelessWidget {
  const _NotebookRow({
    required this.countLabel,
    required this.count,
    required this.onTap,
  });

  final String countLabel;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: TransparenceRadii.all,
        child: FichePanel(
          accent: TransparenceColors.coral,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            children: [
              Expanded(
                child: Text(countLabel, style: theme.textTheme.titleMedium),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: TransparenceColors.coral.withValues(alpha: 0.12),
                  borderRadius: TransparenceRadii.all,
                  border: Border.all(
                    color: TransparenceColors.coral.withValues(alpha: 0.4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    '$count',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: TransparenceColors.coral,
                      fontVariations: const [FontVariation('wght', 700)],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 18,
                color: TransparenceColors.mute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
