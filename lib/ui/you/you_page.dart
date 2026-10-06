import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/app_version.dart';
import 'package:transparence/application/player_stats.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/game/rank_card.dart';
import 'package:transparence/ui/theme.dart';
import 'package:transparence/ui/you/about_page.dart';
import 'package:transparence/ui/you/data_page.dart';
import 'package:transparence/ui/you/history_page.dart';

/// Profil hub — overview + links to focused subpages.
class YouPage extends ConsumerWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rank = ref.watch(playerRankProvider);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.navYou, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Container(
                      width: 56,
                      height: 6,
                      color: TransparenceColors.lime,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              rank.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (value) => RankCard(rank: value),
              ),
              const SizedBox(height: 28),
              _ProfileLink(
                title: l10n.scanHistoryTitle,
                subtitle: l10n.profileHistorySub,
                onTap: () => _open(context, const HistoryPage()),
              ),
              _ProfileLink(
                title: l10n.profileDataTitle,
                subtitle: l10n.profileDataSub,
                onTap: () => _open(context, const DataPage()),
              ),
              _ProfileLink(
                title: l10n.profileAboutTitle,
                subtitle: l10n.profileAboutSub,
                onTap: () => _open(context, const AboutPage()),
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

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: TransparenceColors.mute,
            ),
          ],
        ),
      ),
    );
  }
}
