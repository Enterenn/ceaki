import 'package:flutter/material.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/fortune_page.dart';
import 'package:transparence/ui/library/library_view.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _search = TextEditingController();
  var _sector = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LibraryView(
      builder: (context, library) {
        final l10n = AppLocalizations.of(context);
        final query = _search.text;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (query.trim().isEmpty)
              _SectorBar(
                sectors: library.sectors,
                selected: _sector,
                onSelected: (sector) => setState(() => _sector = sector),
              ),
            Expanded(
              child: query.trim().isEmpty
                  ? _FortuneList(library: library, sector: _sector)
                  : _SearchResults(library: library, query: query),
            ),
          ],
        );
      },
    );
  }
}

class _SectorBar extends StatelessWidget {
  const _SectorBar({
    required this.sectors,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sectors;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = ['', ...sectors];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final sector in chips)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  sector.isEmpty ? l10n.sectorAll : sectorLabel(sector),
                ),
                selected: selected == sector,
                onSelected: (_) => onSelected(sector),
              ),
            ),
        ],
      ),
    );
  }
}

class _FortuneList extends StatelessWidget {
  const _FortuneList({required this.library, required this.sector});

  final Library library;
  final String sector;

  @override
  Widget build(BuildContext context) {
    final fortunes = [...library.fortunes]
      ..sort((a, b) => a.name.compareTo(b.name));
    final visible = fortunes.where((fortune) {
      if (sector.isEmpty) return true;
      return descendFromFortune(
        library,
        fortune.id,
      ).brands.any((brand) => brand.sectors.contains(sector));
    });
    return ListView(
      children: [
        for (final fortune in visible)
          ListTile(
            title: Text(fortune.name),
            subtitle: Text(fortune.summary),
            onTap: () => _open(context, FortunePage(fortuneId: fortune.id)),
          ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.library, required this.query});

  final Library library;
  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fortunes =
        library.fortunes
            .where(
              (fortune) => _matches(query, [fortune.name, ...fortune.aliases]),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    final companies =
        library.companies
            .where(
              (company) => _matches(query, [company.name, ...company.aliases]),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    final brands =
        library.brands
            .where((brand) => _matches(query, [brand.name, ...brand.aliases]))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    if (fortunes.isEmpty && companies.isEmpty && brands.isEmpty) {
      return Center(child: Text(l10n.noResult));
    }
    return ListView(
      children: [
        if (fortunes.isNotEmpty) _Header(l10n.sectionFortunes),
        for (final fortune in fortunes)
          ListTile(
            title: Text(fortune.name),
            onTap: () => _open(context, FortunePage(fortuneId: fortune.id)),
          ),
        if (companies.isNotEmpty) _Header(l10n.sectionCompanies),
        for (final company in companies)
          ListTile(
            title: Text(company.name),
            onTap: () => _open(context, CompanyPage(companyId: company.id)),
          ),
        if (brands.isNotEmpty) _Header(l10n.sectionBrands),
        for (final brand in brands)
          ListTile(
            title: Text(brand.name),
            onTap: () => _open(context, BrandPage(brandId: brand.id)),
          ),
      ],
    );
  }

  bool _matches(String query, List<String> names) {
    final key = normalizeBrandName(query);
    if (key.isEmpty) return false;
    return names.any((name) => normalizeBrandName(name).contains(key));
  }
}

class _Header extends StatelessWidget {
  const _Header(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}
