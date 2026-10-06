import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/library/link_tile.dart';

class FortunePage extends ConsumerWidget {
  const FortunePage({required this.fortuneId, super.key});

  final String fortuneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excluded =
        ref.watch(excludedFortuneIdsProvider).asData?.value ?? const {};
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
        final off = excluded.contains(fortune.id);
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
              ListTile(
                title: Text(
                  off ? l10n.alertOff : l10n.alertOn,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: off ? null : const Color(0xFFFF3D5A),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () {
                    final database = ref.read(appDatabaseProvider);
                    if (off) {
                      database.restoreAlert(fortune.id);
                    } else {
                      database.removeAlert(
                        fortuneId: fortune.id,
                        fortuneName: fortune.name,
                        removedAt: DateTime.now(),
                      );
                    }
                  },
                  child: Text(off ? l10n.alertRestore : l10n.alertRemove),
                ),
              ),
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
