import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_history.dart';
import 'package:transparence/application/shell_tab.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/result/result_page.dart';
import 'package:transparence/ui/theme.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final history = ref.watch(scanHistoryProvider);

    return Scaffold(
      backgroundColor: TransparenceColors.paper,
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.libraryError)),
        data: (scans) {
          final filtered = filterScanHistory(scans, _query.text);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: TransparenceColors.ink,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: TransparenceColors.paper,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.scanHistoryTitle,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: TransparenceColors.paper,
                                    ),
                                  ),
                                ),
                                Text(
                                  l10n.scanHistoryCount(scans.length),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: TransparenceColors.lime,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              width: 48,
                              height: 5,
                              color: TransparenceColors.lime,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              l10n.scanHistorySub,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: TransparenceColors.paper.withValues(
                                  alpha: 0.72,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (scans.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: TextField(
                      controller: _query,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: l10n.scanHistorySearch,
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (scans.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.scanHistoryEmpty,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: TransparenceColors.mute,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: TransparenceColors.lime,
                            foregroundColor: TransparenceColors.ink,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(shellTabProvider.notifier).select(0);
                          },
                          child: Text(l10n.scanHistoryEmptyCta),
                        ),
                      ],
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      l10n.scanHistoryNoMatch,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: TransparenceColors.mute,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                  sliver: SliverList.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final scan = filtered[index];
                      return _ScanTile(
                        scan: scan,
                        l10n: l10n,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ResultPage(scanId: scan.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ScanTile extends StatelessWidget {
  const _ScanTile({
    required this.scan,
    required this.l10n,
    required this.onTap,
  });

  final Scan scan;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = _primaryBrand(scan);
    final markName = brand ?? historyTitle(scan);
    final status = _statusLabel(scan, l10n);
    final accent = _statusColor(scan);

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                  child: Row(
                    children: [
                      BrandMark(name: markName, size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              historyTitle(scan),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontVariations: const [
                                  FontVariation('wght', 650),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                ?brand,
                                _shortDate(scan.scannedAt),
                              ].join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: TransparenceColors.mute,
                              ),
                            ),
                            if (status != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                status.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: accent,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _primaryBrand(Scan scan) {
  final brands = splitFields(scan.brandNames)
      .map(displayBrandName)
      .where((name) => name.isNotEmpty);
  if (brands.isEmpty) return null;
  return brands.first;
}

String? _statusLabel(Scan scan, AppLocalizations l10n) {
  return switch (scan.choice) {
    'put_back' => l10n.scanHistoryPutBack,
    'bought' => l10n.scanHistoryBought,
    _ => null,
  };
}

Color _statusColor(Scan scan) {
  if (scan.choice == 'put_back') return TransparenceColors.coral;
  if (scan.choice == 'bought') return TransparenceColors.mute;
  if (scan.signaledFortuneIds.isNotEmpty) return TransparenceColors.coral;
  return TransparenceColors.lime;
}

String _shortDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}
