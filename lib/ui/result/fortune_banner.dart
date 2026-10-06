import 'package:flutter/material.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/ui/theme.dart';

class FortuneBannerView extends StatelessWidget {
  const FortuneBannerView({required this.banner, super.key});

  final FortuneBanner banner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: TransparenceColors.coral,
          border: Border(
            left: BorderSide(color: TransparenceColors.ink, width: 6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (banner.title != grandeFortuneTitle) ...[
                Text(
                  grandeFortuneTitle.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                banner.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                banner.body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
