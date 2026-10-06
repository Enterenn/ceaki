import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/fiche_chrome.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/library/link_tile.dart';
import 'package:transparence/ui/theme.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({required this.companyId, super.key});

  final String companyId;

  @override
  Widget build(BuildContext context) {
    return LibraryView(
      builder: (context, library) {
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);
        final company = library.companyOrNull(companyId);
        if (company == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.missingEntry)),
          );
        }
        final chain = resolveCompany(library, company.id);
        final subsidiaries = library.holdingsOf(
          OwnerKind.company,
          company.id,
          LinkStatus.active,
        );
        final brands = [
          for (final brand in library.brands)
            if (brand.companyId == company.id) brand,
        ];
        return Scaffold(
          appBar: AppBar(title: Text(company.name)),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SizedBox(height: 12),
              FichePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      l10n.companyRoleCountry(company.role, company.country),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: TransparenceColors.mute,
                      ),
                    ),
                    if (company.aliases.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        company.aliases.join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: TransparenceColors.mute,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              FicheSection(l10n.shareholders),
              for (final link in chain.owners)
                LinkTile(
                  title: _ownerName(library, link.owner),
                  link: _asOwnership(link),
                  source: _source(library, link.sourceId),
                  onOpen: link.owner.kind == OwnerKind.company
                      ? () => _open(
                          context,
                          CompanyPage(companyId: link.owner.id),
                        )
                      : () => _open(
                          context,
                          FortunePage(fortuneId: link.owner.id),
                        ),
                ),
              if (subsidiaries.isNotEmpty) ...[
                FicheSection(l10n.subsidiaries),
                for (final link in subsidiaries)
                  LinkTile(
                    title: library.company(link.ownedCompanyId).name,
                    link: link,
                    source: _source(library, link.sourceId),
                    onOpen: () => _open(
                      context,
                      CompanyPage(companyId: link.ownedCompanyId),
                    ),
                  ),
              ],
              if (brands.isNotEmpty) ...[
                FicheSection(l10n.sectionBrands),
                for (final brand in brands)
                  FicheNavRow(
                    title: brand.name,
                    leading: BrandMark.forBrand(brand, size: 40),
                    onTap: () => _open(context, BrandPage(brandId: brand.id)),
                  ),
              ],
              if (chain.fortuneIds.isNotEmpty) ...[
                FicheSection(l10n.sectionFortunes),
                for (final id in chain.fortuneIds)
                  FicheNavRow(
                    title: library.fortune(id).name,
                    subtitle: l10n.sectionFortunes,
                    onTap: () => _open(context, FortunePage(fortuneId: id)),
                  ),
              ],
              FicheSection(l10n.history),
              if (chain.historical.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    l10n.noHistory,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                )
              else
                for (final link in chain.historical)
                  LinkTile(
                    title: _ownerName(library, link.owner),
                    link: link,
                    source: _source(library, link.sourceId),
                  ),
            ],
          ),
        );
      },
    );
  }
}

String _ownerName(Library library, OwnerRef owner) {
  return switch (owner.kind) {
    OwnerKind.company => library.company(owner.id).name,
    OwnerKind.fortune => library.fortune(owner.id).name,
  };
}

Ownership _asOwnership(Holding holding) {
  return Ownership(
    ownedCompanyId: holding.ownedCompanyId,
    owner: holding.owner,
    capitalPercent: holding.capitalPercent,
    votingPercent: holding.votingPercent,
    linkType: holding.linkType,
    factDate: holding.factDate,
    sourceId: holding.sourceId,
    status: LinkStatus.active,
    note: holding.note,
  );
}

Source? _source(Library library, String? id) {
  if (id == null) return null;
  return library.sourceOrNull(id);
}

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}
