import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/app_version.dart';
import 'package:transparence/application/notebook_lines.dart';
import 'package:transparence/application/player_stats.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/game/rank_card.dart';
import 'package:transparence/ui/library/fiche_chrome.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/motion/entrance.dart';
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
              Entrance(
                child: HubHeader(
                  title: l10n.navYou,
                  subtitle: l10n.notebookSub,
                ),
              ),
              Entrance(
                delay: const Duration(milliseconds: 80),
                slide: 0.08,
                scaleFrom: 0.96,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: rank.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (value) => RankCard(rank: value),
                  ),
                ),
              ),
              Entrance(
                delay: const Duration(milliseconds: 150),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                  child: Text(
                    l10n.notebookTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
              Entrance(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: notebook.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (lines) {
                      if (lines.isEmpty) {
                        return CustomPaint(
                          painter: _DashBorderPainter(
                            color: TransparenceColors.ink,
                            radius: TransparenceRadii.lg,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                            child: Text(
                              l10n.notebookEmpty,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: TransparenceColors.mute,
                              ),
                            ),
                          ),
                        );
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = (constraints.maxWidth - 12) / 2;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final line in lines)
                                SizedBox(
                                  width: width,
                                  child: _FortuneTile(
                                    name: line.name,
                                    countLabel: l10n.notebookLine(
                                      line.name,
                                      line.count,
                                    ),
                                    count: line.count,
                                    onTap: () => _open(
                                      context,
                                      FortunePage(fortuneId: line.fortuneId),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Entrance(
                delay: const Duration(milliseconds: 280),
                child: Padding(
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

class _FortuneTile extends StatelessWidget {
  const _FortuneTile({
    required this.name,
    required this.countLabel,
    required this.count,
    required this.onTap,
  });

  final String name;
  final String countLabel;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (count / 10).clamp(0.08, 1.0);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: TransparenceRadii.tile,
        child: Ink(
          decoration: BoxDecoration(
            color: TransparenceTiles.fortune,
            borderRadius: TransparenceRadii.tile,
            boxShadow: TransparenceShadows.stamp,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontVariations: const [FontVariation('wght', 800)],
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  countLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: TransparenceRadii.all,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.28),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashBorderPainter extends CustomPainter {
  _DashBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 7.0;
      const gap = 5.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
