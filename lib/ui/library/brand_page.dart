import 'package:flutter/material.dart';
import 'package:transparence/domain/archive.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/fiche_chrome.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/library/holding_list.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/library/link_tile.dart';
import 'package:transparence/ui/theme.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({required this.brandId, super.key});

  final String brandId;

  @override
  Widget build(BuildContext context) {
    return LibraryView(
      builder: (context, library) {
        final l10n = AppLocalizations.of(context);
        final brand = _findBrand(library, brandId);
        if (brand == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.missingEntry)),
          );
        }
        final chain = resolveBrand(library, brand);
        final company = library.company(brand.companyId);
        final tone = archiveToneFor(chain.chain);
        final sources = _sources(library, chain);
        final fortuneIds = chain.chain.fortuneIds;
        return Scaffold(
          appBar: AppBar(title: Text(brand.name)),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandMark.forBrand(brand, size: 72),
                    const SizedBox(width: 16),
                    Expanded(child: _ToneBanner(tone: tone)),
                  ],
                ),
              ),
              if (brand.logoSource != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    brand.logoSource!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                ),
              if (brand.aliases.isNotEmpty) ...[
                FicheSection(l10n.aliases),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text(
                    brand.aliases.join(' · '),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final sector in brand.sectors)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        color: TransparenceColors.lime,
                        child: Text(
                          sectorLabel(sector).toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: TransparenceColors.ink),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FicheNavRow(
                title: company.name,
                subtitle: company.role,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CompanyPage(companyId: company.id),
                    ),
                  );
                },
              ),
              FicheSection(l10n.chain),
              HoldingList(library: library, holdings: chain.chain.owners),
              for (final link in chain.chain.historical)
                LinkTile(
                  title: _ownerName(library, link.owner),
                  link: link,
                  source: link.sourceId == null
                      ? null
                      : library.sourceOrNull(link.sourceId!),
                ),
              if (fortuneIds.isNotEmpty) ...[
                FicheSection(l10n.sectionFortunes),
                for (final id in fortuneIds)
                  FicheNavRow(
                    title: library.fortune(id).name,
                    subtitle: l10n.sectionFortunes,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => FortunePage(fortuneId: id),
                        ),
                      );
                    },
                  ),
              ],
              if (sources.isNotEmpty) ...[
                FicheSection(l10n.archiveSources),
                for (final source in sources)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        onPressed: () => openHttps(context, source.url),
                        child: Text(source.title),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Shown when a scanned name never matched a documented brand.
class UnresolvedBrandPage extends StatelessWidget {
  const UnresolvedBrandPage({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandMark(name: name, size: 64),
              const SizedBox(width: 14),
              const Expanded(child: _ToneBanner(tone: ArchiveTone.unknown)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.archiveUnresolvedBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TransparenceColors.mute,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToneBanner extends StatelessWidget {
  const _ToneBanner({required this.tone});

  final ArchiveTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (tone) {
      ArchiveTone.fortune => TransparenceColors.coral,
      ArchiveTone.clear => TransparenceColors.leaf,
      ArchiveTone.unknown => TransparenceColors.mute,
    };
    return Semantics(
      label: archiveToneLabel(tone),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border(left: BorderSide(color: color, width: 6)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Text(
            archiveToneLabel(tone),
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

Brand? _findBrand(Library library, String brandId) {
  for (final brand in library.brands) {
    if (brand.id == brandId) return brand;
  }
  return null;
}

List<Source> _sources(Library library, BrandChain chain) {
  final ids = <String>[];
  void add(String? id) {
    if (id != null && !ids.contains(id)) ids.add(id);
  }

  void walk(Holding holding) {
    add(holding.sourceId);
    for (final next in holding.above) {
      walk(next);
    }
  }

  for (final owner in chain.chain.owners) {
    walk(owner);
  }
  for (final link in chain.chain.historical) {
    add(link.sourceId);
  }
  return [for (final id in ids) ?library.sourceOrNull(id)];
}

String _ownerName(Library library, OwnerRef owner) {
  return switch (owner.kind) {
    OwnerKind.company => library.company(owner.id).name,
    OwnerKind.fortune => library.fortune(owner.id).name,
  };
}

