import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/archive_brands.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/shell_tab.dart';
import 'package:transparence/domain/archive.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/motion/entrance.dart';
import 'package:transparence/ui/motion/press_scale.dart';
import 'package:transparence/ui/shell/hub_header.dart';
import 'package:transparence/ui/theme.dart';

/// Personal archive of brands already met through scans.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _search = TextEditingController();
  ArchiveTone? _tone;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final archive = ref.watch(archiveBrandsProvider);
    final library = ref.watch(capitalLibraryProvider).asData?.value;
    return archive.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text(l10n.libraryError)),
      data: (entries) {
        final visible = filterArchive(
          entries,
          query: _search.text,
          tone: _tone,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Entrance(
              child: HubHeader(
                title: l10n.navLibrary,
                subtitle: l10n.archiveSub,
                trailing: l10n.archiveCount(entries.length),
              ),
            ),
            Entrance(
              delay: const Duration(milliseconds: 70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: l10n.archiveSearchHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            if (entries.isNotEmpty)
              Entrance(
                delay: const Duration(milliseconds: 120),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: l10n.archiveFilterAll,
                        selected: _tone == null,
                        color: TransparenceColors.ink,
                        onTap: () => setState(() => _tone = null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: l10n.archiveFilterFortune,
                        selected: _tone == ArchiveTone.fortune,
                        color: TransparenceColors.coral,
                        onTap: () =>
                            setState(() => _tone = ArchiveTone.fortune),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: l10n.archiveFilterClear,
                        selected: _tone == ArchiveTone.clear,
                        color: TransparenceColors.leaf,
                        onTap: () => setState(() => _tone = ArchiveTone.clear),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: l10n.archiveFilterUnknown,
                        selected: _tone == ArchiveTone.unknown,
                        color: TransparenceColors.mute,
                        onTap: () =>
                            setState(() => _tone = ArchiveTone.unknown),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: entries.isEmpty
                  ? Entrance(
                      delay: const Duration(milliseconds: 140),
                      slide: 0.08,
                      child: _EmptyArchive(
                        message: l10n.archiveEmpty,
                        cta: l10n.archiveEmptyCta,
                        onScan: () {
                          ref.read(shellTabProvider.notifier).select(0);
                        },
                      ),
                    )
                  : visible.isEmpty
                  ? Center(
                      child: Text(
                        l10n.archiveNoMatch,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: TransparenceColors.mute),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.92,
                          ),
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final entry = visible[index];
                        final stagger = index.clamp(0, 7) * 45;
                        return Entrance(
                          delay: Duration(milliseconds: 160 + stagger),
                          slide: 0.05,
                          child: _ArchiveTile(
                            entry: entry,
                            brand: _brandOf(library, entry.brandId),
                            onTap: () => _openEntry(context, entry),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _openEntry(BuildContext context, ArchiveEntry entry) {
    final brandId = entry.brandId;
    if (brandId == null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UnresolvedBrandPage(name: entry.name),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrandPage(brandId: brandId),
      ),
    );
  }
}

Brand? _brandOf(Library? library, String? brandId) {
  if (library == null || brandId == null) return null;
  for (final brand in library.brands) {
    if (brand.id == brandId) return brand;
  }
  return null;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSelected = color == TransparenceColors.mute
        ? TransparenceColors.panel
        : Colors.white;
    return Material(
      color: Colors.transparent,
      borderRadius: TransparenceRadii.all,
      child: InkWell(
        onTap: onTap,
        borderRadius: TransparenceRadii.all,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color : TransparenceColors.panel,
            borderRadius: TransparenceRadii.all,
            border: Border.all(color: color, width: 1.5),
            boxShadow: selected ? null : TransparenceShadows.stamp,
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: selected ? onSelected : color,
              fontVariations: const [FontVariation('wght', 700)],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyArchive extends StatelessWidget {
  const _EmptyArchive({
    required this.message,
    required this.cta,
    required this.onScan,
  });

  final String message;
  final String cta;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: CustomPaint(
          painter: _DashBorderPainter(
            color: TransparenceColors.ink,
            radius: TransparenceRadii.lg,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.add, size: 36, color: TransparenceColors.ink),
                const SizedBox(height: 14),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: TransparenceColors.mute,
                    height: 1.35,
                  ),
                ),
                  const SizedBox(height: 20),
                  PressScale(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: TransparenceColors.ink,
                        foregroundColor: TransparenceColors.lime,
                        minimumSize: const Size.fromHeight(52),
                        shape: const RoundedRectangleBorder(
                          borderRadius: TransparenceRadii.all,
                        ),
                      ),
                      onPressed: onScan,
                      child: Text(cta),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashBorderPainter extends CustomPainter {
  _DashBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 7.0;
      const gap = 5.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _ArchiveTile extends StatelessWidget {
  const _ArchiveTile({
    required this.entry,
    required this.brand,
    required this.onTap,
  });

  final ArchiveEntry entry;
  final Brand? brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = _tileFill(entry.tone);
    final onFill = _onTile(entry.tone);
    final label = archiveToneLabel(entry.tone);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: TransparenceRadii.tile,
        child: Ink(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: TransparenceRadii.tile,
            boxShadow: TransparenceShadows.stamp,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (brand != null)
                  BrandMark.forBrand(brand!, size: 44)
                else
                  BrandMark(name: entry.name, size: 44),
                const Spacer(),
                Text(
                  entry.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: onFill,
                    fontVariations: const [FontVariation('wght', 800)],
                    height: 1.15,
                  ),
                ),
                if (entry.companyName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.companyName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onFill.withValues(alpha: 0.72),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: onFill,
                    letterSpacing: 0.2,
                    fontVariations: const [FontVariation('wght', 700)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _tileFill(ArchiveTone tone) {
    return switch (tone) {
      ArchiveTone.fortune => TransparenceTiles.fortune,
      ArchiveTone.clear => TransparenceTiles.clear,
      ArchiveTone.unknown => TransparenceTiles.unknown,
    };
  }

  Color _onTile(ArchiveTone tone) {
    return switch (tone) {
      ArchiveTone.fortune => Colors.white,
      ArchiveTone.clear => TransparenceColors.ink,
      ArchiveTone.unknown => TransparenceColors.ink,
    };
  }
}
