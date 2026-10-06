import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/theme.dart';

/// Soft confirmation after a put-back — ink win strip with a short entrance.
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
      duration: const Duration(milliseconds: 420),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = curve;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: 0.94, end: 1).animate(curve);
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
            decoration: const BoxDecoration(
              color: TransparenceColors.ink,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.brands.isNotEmpty) ...[
                    BrandMark.forBrand(widget.brands.first, size: 44),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              color: TransparenceColors.lime,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.esquiveBadge.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: TransparenceColors.lime,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.line,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: TransparenceColors.paper,
                            fontVariations: const [
                              FontVariation('wght', 700),
                            ],
                          ),
                        ),
                        if (rank != null && rank.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            rank,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: TransparenceColors.mist,
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
