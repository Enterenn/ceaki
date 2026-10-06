import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/player_stats.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/application/scan_view.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/notebook.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/game/esquive_burst.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/library/link_tile.dart';
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
    return view.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.navScanner)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.navScanner)),
        body: Center(child: Text(l10n.libraryError)),
      ),
      data: (scan) => Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle(scan, l10n)),
        ),
        body: _ResultBody(scanId: scanId, scan: scan),
      ),
    );
  }
}

String _appBarTitle(ScanView scan, AppLocalizations l10n) {
  final brand = scan.brandLabel?.trim();
  if (brand != null && brand.isNotEmpty) return brand;
  final title = scan.title?.trim();
  if (title != null && title.isNotEmpty) return title;
  return l10n.navScanner;
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
    final hasDetail =
        scan.chains.isNotEmpty ||
        scan.fortuneIds.isNotEmpty ||
        scan.choices.isNotEmpty ||
        scan.sources.isNotEmpty ||
        scan.unmatched.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        final library = ref.read(capitalLibraryProvider).requireValue;
        await ref.read(scanBookProvider).refresh(scanId, library);
      },
      child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      children: [
        // 1. Alerte / état
        for (final banner in scan.banners)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: FortuneBannerView(banner: banner),
          ),
        if (scan.banners.isEmpty && scan.state != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _StatusStrip(scan: scan, library: library, l10n: l10n),
          ),

        // 2. Produit
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: _ProductBlock(
            scan: scan,
            brands: [for (final chain in scan.chains) chain.brand],
            l10n: l10n,
            theme: theme,
          ),
        ),

        // 3. Actions
        if (scan.choice == ScanChoice.putBack &&
            scan.fortuneNames.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: EsquiveBurst(
              line: putBackLine(scan.fortuneNames),
              rankTitle: ref.watch(playerRankProvider).asData?.value.title,
              brands: [for (final chain in scan.chains) chain.brand],
            ),
          )
        else if (scan.choice == null &&
            scan.state == ChainState.signaled &&
            scan.choices.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: _DecisionActions(
              onPutBack: () async {
                final saved = await ref
                    .read(scanBookProvider)
                    .putBack(scanId, library);
                if (saved) await HapticFeedback.mediumImpact();
              },
              onBuy: () => ref.read(scanBookProvider).buyAnyway(scanId),
              putBackLabel: l10n.putBack,
              buyLabel: l10n.buyAnyway,
            ),
          ),

        if (scan.choices.isNotEmpty) ...[
          const SizedBox(height: 28),
          _SectionLabel(l10n.chooseBrand),
          for (final choice in scan.choices)
            for (final brand in choice.brands)
              _NavRow(
                title: brand.name,
                subtitle:
                    '${brand.sectors.map(sectorLabel).join(', ')} · ${library.company(brand.companyId).name}',
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
        if (scan.chosenBrandKeys.isNotEmpty && scan.choices.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => ref.read(scanBookProvider).clearBrandChoice(
                      scanId: scanId,
                      library: library,
                    ),
                child: Text(l10n.changeBrandChoice),
              ),
            ),
          ),

        // 4. Détail
        if (hasDetail) ...[
          const SizedBox(height: 32),
          _SectionLabel(l10n.chain),
          if (scan.unmatched.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.brandUnmatched, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    l10n.gs1Prefix,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                ],
              ),
            ),
          for (final chain in scan.chains) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                library.company(chain.chain.companyId).name,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: PathChain(
                library: library,
                owners: chain.chain.owners,
                path: _path(chain),
              ),
            ),
            for (final link in chain.chain.historical)
              LinkTile(
                title: _ownerName(library, link.owner),
                link: link,
                source: _source(library, link.sourceId),
              ),
            _NavRow(
              title: chain.brand.name,
              subtitle: l10n.sectionBrands,
              onTap: () => _open(context, BrandPage(brandId: chain.brand.id)),
            ),
            _NavRow(
              title: library.company(chain.chain.companyId).name,
              subtitle: l10n.sectionCompanies,
              onTap: () => _open(
                context,
                CompanyPage(companyId: chain.chain.companyId),
              ),
            ),
          ],
          for (final id in scan.fortuneIds)
            _NavRow(
              title: library.fortune(id).name,
              subtitle: l10n.sectionFortunes,
              onTap: () => _open(context, FortunePage(fortuneId: id)),
            ),
          if (scan.sources.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final source in scan.sources)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => openHttps(context, source.url),
                    child: Text(source.title),
                  ),
                ),
              ),
          ],
        ],
      ],
    ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({
    required this.scan,
    required this.library,
    required this.l10n,
  });

  final ScanView scan;
  final Library library;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = scan.state == ChainState.alertMuted
        ? TransparenceColors.coral
        : TransparenceColors.ink;
    final label = switch (scan.state) {
      ChainState.alertMuted => l10n.alertOff,
      ChainState.noDocumentedFortune => noDocumentedFortuneLabel,
      ChainState.currentOwnerUndocumented => currentOwnerUndocumentedLabel,
      _ => null,
    };
    final owners = documentedOwnerNames(library, scan.chains);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: TransparenceColors.mist,
        border: Border(left: BorderSide(color: accent, width: 6)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accent,
                  letterSpacing: 1.1,
                ),
              ),
            for (final name in owners) ...[
              if (label != null) const SizedBox(height: 8),
              Text(name, style: theme.textTheme.titleLarge),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductBlock extends StatelessWidget {
  const _ProductBlock({
    required this.scan,
    required this.brands,
    required this.l10n,
    required this.theme,
  });

  final ScanView scan;
  final List<Brand> brands;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final category = switch (scan.category) {
      'jeu' => l10n.categoryGame,
      'livre' => l10n.categoryBook,
      'alimentaire' => l10n.categoryFood,
      'beaute' => l10n.categoryBeauty,
      'animalerie' => l10n.categoryPet,
      'produit' || 'autre' => l10n.categoryProduct,
      _ => null,
    };

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: TransparenceColors.lime, width: 6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: TransparenceColors.lime,
                child: Text(
                  category.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: TransparenceColors.ink,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (scan.title != null)
              Text(scan.title!, style: theme.textTheme.headlineSmall),
            if (scan.creator != null) ...[
              const SizedBox(height: 6),
              Text(
                scan.creator!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: TransparenceColors.mute,
                ),
              ),
            ],
            if (brands.isNotEmpty) ...[
              const SizedBox(height: 14),
              for (final brand in brands) ...[
                Row(
                  children: [
                    BrandMark.forBrand(brand, size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        brand.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontVariations: const [FontVariation('wght', 700)],
                        ),
                      ),
                    ),
                  ],
                ),
                if (brand != brands.last) const SizedBox(height: 10),
              ],
            ] else if (scan.brandLabel != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  BrandMark(name: scan.brandLabel!, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      scan.brandLabel!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontVariations: const [FontVariation('wght', 700)],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Text(
              scan.gtin,
              style: theme.textTheme.bodySmall?.copyWith(
                color: TransparenceColors.mute,
                letterSpacing: 0.4,
              ),
            ),
            if (scan.issue == ScanIssue.productUnknown) ...[
              const SizedBox(height: 8),
              Text(l10n.productUnknown),
            ],
            if (scan.issue == ScanIssue.offline) ...[
              const SizedBox(height: 8),
              Text(l10n.offlineProduct),
            ],
          ],
        ),
      ),
    );
  }
}

class _DecisionActions extends StatelessWidget {
  const _DecisionActions({
    required this.onPutBack,
    required this.onBuy,
    required this.putBackLabel,
    required this.buyLabel,
  });

  final Future<void> Function() onPutBack;
  final VoidCallback onBuy;
  final String putBackLabel;
  final String buyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: TransparenceColors.lime,
            foregroundColor: TransparenceColors.ink,
            minimumSize: const Size.fromHeight(58),
          ),
          onPressed: onPutBack,
          child: Text(
            putBackLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              color: TransparenceColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: TransparenceColors.ink,
            minimumSize: const Size.fromHeight(52),
            side: const BorderSide(color: TransparenceColors.ink, width: 2),
          ),
          onPressed: onBuy,
          child: Text(buyLabel),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(width: 10, height: 10, color: TransparenceColors.lime),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.2,
              color: TransparenceColors.mute,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: TransparenceColors.mist, width: 2),
            ),
          ),
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
                Icons.arrow_forward,
                size: 18,
                color: TransparenceColors.ink,
              ),
            ],
          ),
        ),
      ),
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
