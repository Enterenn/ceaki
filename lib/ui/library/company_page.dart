import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/library/link_tile.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({required this.companyId, super.key});

  final String companyId;

  @override
  Widget build(BuildContext context) {
    return LibraryView(
      builder: (context, library) {
        final l10n = AppLocalizations.of(context);
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
        final brands = library.brands.where(
          (brand) => brand.companyId == company.id,
        );
        return Scaffold(
          appBar: AppBar(title: Text(company.name)),
          body: ListView(
            children: [
              ListTile(
                title: Text(company.role),
                subtitle: Text(company.country),
              ),
              _Section(l10n.shareholders),
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
              _Section(l10n.subsidiaries),
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
              _Section(l10n.sectionBrands),
              for (final brand in brands)
                ListTile(
                  title: Text(brand.name),
                  onTap: () => _open(context, BrandPage(brandId: brand.id)),
                ),
              _Section(l10n.sectionFortunes),
              for (final id in chain.fortuneIds)
                ListTile(
                  title: Text(library.fortune(id).name),
                  onTap: () => _open(context, FortunePage(fortuneId: id)),
                ),
              _Section(l10n.history),
              if (chain.historical.isEmpty)
                ListTile(title: Text(l10n.noHistory))
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

class _Section extends StatelessWidget {
  const _Section(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
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
