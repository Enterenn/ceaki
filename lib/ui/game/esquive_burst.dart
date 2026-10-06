import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/theme.dart';

/// Soft confirmation after a put-back.
class EsquiveBurst extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = rankTitle;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: TransparenceColors.lime, width: 6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (brands.isNotEmpty) ...[
              BrandMark.forBrand(brands.first, size: 44),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line, style: theme.textTheme.titleMedium),
                  if (rank != null && rank.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      rank,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TransparenceColors.mute,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
