import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/app_version.dart';
import 'package:transparence/application/notebook_lines.dart';
import 'package:transparence/application/player_stats.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/game/rank_card.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/theme.dart';

class YouPage extends ConsumerWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notebook = ref.watch(notebookProvider);
    final rank = ref.watch(playerRankProvider);
    final appVersion = ref.watch(appVersionProvider);
    final theme = Theme.of(context);
    return LibraryView(
      builder: (context, library) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.notebookTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: 56,
              height: 6,
              color: TransparenceColors.lime,
            ),
            const SizedBox(height: 20),
            rank.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (value) => RankCard(rank: value),
            ),
            const SizedBox(height: 24),
            notebook.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => Text(l10n.libraryError),
              data: (lines) {
                if (lines.isEmpty) {
                  return Text(
                    l10n.notebookEmpty,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          l10n.notebookLine(line.name, line.count),
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 20),
            Text(l10n.aboutPurpose, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text(
              l10n.aboutLimit,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: TransparenceColors.mute,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.appVersionLabel.toUpperCase(),
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              appVersion.when(
                loading: () => l10n.appVersionValue('0.1.1'),
                error: (_, _) => l10n.appVersionValue('0.1.1'),
                data: l10n.appVersionValue,
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.libraryVersionLabel.toUpperCase(),
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '${library.version} · ${library.updatedOn}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
