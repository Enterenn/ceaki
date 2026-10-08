import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/chrome/stamp_tag.dart';
import 'package:transparence/ui/theme.dart';

/// Put-back win — full lime Z scene.
class EsquiveBurst extends StatefulWidget {
  const EsquiveBurst({
    required this.line,
    this.rankTitle,
    this.brands = const [],
    super.key,
  });

  final String line;
  final String? rankTitle;
  final List<Brand> brands;

  @override
  State<EsquiveBurst> createState() => _EsquiveBurstState();
}

class _EsquiveBurstState extends State<EsquiveBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: 0.86, end: 1).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final rank = widget.rankTitle;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: TransparenceScenes.solidLime,
              borderRadius: TransparenceRadii.tile,
              boxShadow: TransparenceShadows.stampStrong,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.brands.isNotEmpty) ...[
                    BrandMark.forBrand(widget.brands.first, size: 48),
                    const SizedBox(width: 14),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StampTag(
                          label: l10n.esquiveBadge,
                          background: TransparenceColors.ink,
                          foreground: TransparenceColors.lime,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.line,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: TransparenceColors.ink,
                            fontVariations: const [
                              FontVariation('wght', 800),
                            ],
                            height: 1.15,
                          ),
                        ),
                        if (rank != null && rank.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            rank,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: TransparenceColors.ink.withValues(
                                alpha: 0.65,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
