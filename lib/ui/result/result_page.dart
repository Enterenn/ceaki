import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/application/scan_view.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/notebook.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/library/link_tile.dart';
import 'package:transparence/application/player_stats.dart';
import 'package:transparence/ui/game/esquive_burst.dart';
import 'package:transparence/ui/result/fortune_banner.dart';
import 'package:transparence/ui/result/path_chain.dart';
import 'package:transparence/ui/theme.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({required this.scanId, super.key});

  final int scanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final view = ref.watch(scanViewProvider(scanId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navScanner)),
      body: view.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.libraryError)),
        data: (scan) => _ResultBody(scanId: scanId, scan: scan),
      ),
    );
  }
}

class _ResultBody extends ConsumerWidget {
  const _ResultBody({required this.scanId, required this.scan});

  final int scanId;
  final ScanView scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final library = ref.watch(capitalLibraryProvider).requireValue;
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              for (final banner in scan.banners) ...[
                FortuneBannerView(banner: banner),
                const SizedBox(height: 16),
              ],
              if (scan.banners.isEmpty)
                for (final name in documentedOwnerNames(library, scan.chains))
                  Text(name, style: theme.textTheme.titleLarge),
              if (scan.state == ChainState.alertMuted)
                Text(l10n.alertOff, style: theme.textTheme.titleMedium),
              if (scan.state == ChainState.noDocumentedFortune)
                Text(
                  noDocumentedFortuneLabel,
                  style: theme.textTheme.titleMedium,
                ),
              if (scan.state == ChainState.currentOwnerUndocumented)
                Text(
                  currentOwnerUndocumentedLabel,
                  style: theme.textTheme.titleMedium,
                ),
              if (scan.title != null)
                Text(scan.title!, style: theme.textTheme.titleLarge),
              if (scan.creator != null) ...[
                const SizedBox(height: 4),
                Text(scan.creator!),
              ],
              if (scan.brandLabel != null) ...[
                const SizedBox(height: 4),
                Text(scan.brandLabel!),
              ],
              if (scan.category == 'jeu' || scan.category == 'livre') ...[
                const SizedBox(height: 4),
                Text(
                  scan.category == 'jeu'
                      ? l10n.categoryGame
                      : l10n.categoryBook,
                ),
              ],
              const SizedBox(height: 8),
              Text(scan.gtin, style: theme.textTheme.bodySmall),
              if (scan.issue == ScanIssue.productUnknown)
                Text(l10n.productUnknown),
              if (scan.issue == ScanIssue.offline) Text(l10n.offlineProduct),
              if (scan.issue == ScanIssue.notABook) Text(l10n.notABook),
              if (scan.unmatched.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(l10n.brandUnmatched),
                Text(l10n.gs1Prefix),
              ],
              for (final chain in scan.chains) ...[
                const SizedBox(height: 16),
                Text(
                  library.company(chain.chain.companyId).name,
                  style: theme.textTheme.titleMedium,
                ),
                PathChain(
                  library: library,
                  owners: chain.chain.owners,
                  path: _path(chain),
                ),
                for (final link in chain.chain.historical)
                  LinkTile(
                    title: _ownerName(library, link.owner),
                    link: link,
                    source: _source(library, link.sourceId),
                  ),
                ListTile(
                  title: Text(chain.brand.name),
                  subtitle: Text(l10n.sectionBrands),
                  onTap: () =>
                      _open(context, BrandPage(brandId: chain.brand.id)),
                ),
                ListTile(
                  title: Text(library.company(chain.chain.companyId).name),
                  subtitle: Text(l10n.sectionCompanies),
                  onTap: () => _open(
                    context,
                    CompanyPage(companyId: chain.chain.companyId),
                  ),
                ),
              ],
              for (final id in scan.fortuneIds)
                ListTile(
                  title: Text(library.fortune(id).name),
                  subtitle: Text(l10n.sectionFortunes),
                  onTap: () => _open(context, FortunePage(fortuneId: id)),
                ),
              if (scan.choices.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.chooseBrand, style: theme.textTheme.titleMedium),
                for (final choice in scan.choices)
                  for (final brand in choice.brands)
                    ListTile(
                      title: Text(brand.name),
                      subtitle: Text(
                        '${brand.sectors.map(sectorLabel).join(', ')} · ${library.company(brand.companyId).name}',
                      ),
                      onTap: () => ref
                          .read(scanBookProvider)
                          .chooseBrand(
                            scanId: scanId,
                            key: choice.key,
                            brandId: brand.id,
                            library: library,
                          ),
                    ),
              ],
              for (final source in scan.sources)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => openHttps(context, source.url),
                    child: Text(source.title),
                  ),
                ),
            ],
          ),
        ),
        if (scan.choice == ScanChoice.putBack && scan.fortuneNames.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: EsquiveBurst(
              line: putBackLine(scan.fortuneNames),
              rankTitle: ref.watch(playerRankProvider).asData?.value.title,
            ),
          )
        else if (scan.choice == null &&
            scan.state == ChainState.signaled &&
            scan.choices.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: TransparenceColors.lime,
                    foregroundColor: TransparenceColors.ink,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () async {
                    final saved = await ref
                        .read(scanBookProvider)
                        .putBack(scanId, library);
                    if (saved) await HapticFeedback.mediumImpact();
                  },
                  child: Text(l10n.putBack),
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () => ref.read(scanBookProvider).buyAnyway(scanId),
                  child: Text(l10n.buyAnyway),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

List<Holding> _path(BrandChain chain) {
  final ids = chain.chain.fortuneIds;
  if (ids.isEmpty) return const [];
  return pathToFortune(chain.chain, ids.first);
}

Source? _source(Library library, String? id) {
  if (id == null) return null;
  return library.sourceOrNull(id);
}

String _ownerName(Library library, OwnerRef owner) {
  return switch (owner.kind) {
    OwnerKind.company => library.company(owner.id).name,
    OwnerKind.fortune => library.fortune(owner.id).name,
  };
}

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}
