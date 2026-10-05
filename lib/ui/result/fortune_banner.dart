import 'package:flutter/material.dart';
import 'package:transparence/domain/wording.dart';

class FortuneBannerView extends StatelessWidget {
  const FortuneBannerView({required this.banner, super.key});

  final FortuneBanner banner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      child: Material(
        color: theme.colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(banner.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(banner.body),
            ],
          ),
        ),
      ),
    );
  }
}
