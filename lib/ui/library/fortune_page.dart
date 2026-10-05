import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/library/link_tile.dart';

class FortunePage extends StatelessWidget {
  const FortunePage({required this.fortuneId, super.key});

  final String fortuneId;

  @override
  Widget build(BuildContext context) {
    return LibraryView(
      builder: (context, library) {
        final l10n = AppLocalizations.of(context);
        final fortune = library.fortuneOrNull(fortuneId);
        if (fortune == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.missingEntry)),
          );
        }
        final portfolio = descendFromFortune(library, fortune.id);
        final active = library.holdingsOf(
          OwnerKind.fortune,
          fortune.id,
          LinkStatus.active,
        );
        final historical = library.holdingsOf(
          OwnerKind.fortune,
          fortune.id,
          LinkStatus.historical,
        );
        return Scaffold(
          appBar: AppBar(title: Text(fortune.name)),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(fortune.summary),
              ),
              ListTile(title: Text(l10n.alertOn)),
              _Section(l10n.participations),
              for (final link in active)
                LinkTile(
                  title: library.company(link.ownedCompanyId).name,
                  link: link,
                  source: _source(library, link),
                  onOpen: () => _open(
                    context,
                    CompanyPage(companyId: link.ownedCompanyId),
                  ),
                ),
              _Section(l10n.brandsReached),
              for (final brand in portfolio.brands)
                ListTile(
                  title: Text(brand.name),
                  onTap: () => _open(context, BrandPage(brandId: brand.id)),
                ),
              _Section(l10n.history),
              if (historical.isEmpty)
                ListTile(title: Text(l10n.noHistory))
              else
                for (final link in historical)
                  LinkTile(
                    title: library.company(link.ownedCompanyId).name,
                    link: link,
                    source: _source(library, link),
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

Source? _source(Library library, Ownership link) {
  final id = link.sourceId;
  if (id == null) return null;
  return library.sourceOrNull(id);
}

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}
