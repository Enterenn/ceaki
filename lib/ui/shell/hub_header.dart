import 'package:flutter/material.dart';
import 'package:transparence/ui/brand/ceaki_mark.dart';
import 'package:transparence/ui/theme.dart';

/// Shared top chrome for Terrain / Carnet hubs — brand mark + title + lime bar.
class HubHeader extends StatelessWidget {
  const HubHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    this.bottom,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final Widget? bottom;

  static const limeBar = SizedBox(
    width: 56,
    height: 6,
    child: ColoredBox(color: TransparenceColors.lime),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sub = subtitle;
    final trail = trailing;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CeakiMark(size: 28),
                if (trail != null) ...[
                  const Spacer(),
                  Text(
                    trail,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            limeBar,
            if (sub != null) ...[
              const SizedBox(height: 10),
              Text(
                sub,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: TransparenceColors.mute,
                ),
              ),
            ],
            if (bottom != null) ...[
              const SizedBox(height: 14),
              bottom!,
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
