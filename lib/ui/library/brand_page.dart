import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/holding_list.dart';
import 'package:transparence/ui/library/library_view.dart';

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
        return Scaffold(
          appBar: AppBar(title: Text(brand.name)),
          body: ListView(
            children: [
              if (brand.aliases.isNotEmpty) ...[
                _Section(l10n.aliases),
                for (final alias in brand.aliases) ListTile(title: Text(alias)),
              ],
              ListTile(title: Text(brand.sectors.map(sectorLabel).join(', '))),
              ListTile(
                title: Text(company.name),
                subtitle: Text(company.role),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CompanyPage(companyId: company.id),
                    ),
                  );
                },
              ),
              _Section(l10n.chain),
              HoldingList(library: library, holdings: chain.chain.owners),
              ListTile(title: Text(l10n.noScans)),
            ],
          ),
        );
      },
    );
  }
}

Brand? _findBrand(Library library, String brandId) {
  for (final brand in library.brands) {
    if (brand.id == brandId) return brand;
  }
  return null;
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
