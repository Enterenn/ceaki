import 'package:flutter/material.dart';
import 'package:transparence/ui/theme.dart';

/// Shared section header — lime square + uppercase label.
class FicheSection extends StatelessWidget {
  const FicheSection(
    this.label, {
    this.padding = const EdgeInsets.fromLTRB(16, 24, 16, 6),
    super.key,
  });

  final String label;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(width: 10, height: 10, color: TransparenceColors.lime),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 1.2,
              color: TransparenceColors.mute,
            ),
          ),
        ],
      ),
    );
  }
}

/// Accent panel — left bar + fill. Used on result, archive, and fiches.
class FichePanel extends StatelessWidget {
  const FichePanel({
    required this.child,
    this.accent = TransparenceColors.lime,
    this.color = Colors.white,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  final Widget child;
  final Color accent;
  final Color color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          border: Border(left: BorderSide(color: accent, width: 6)),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Tappable title / subtitle row into a fiche or action.
class FicheNavRow extends StatelessWidget {
  const FicheNavRow({
    required this.title,
    this.subtitle,
    this.leading,
    required this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: TransparenceColors.mute,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 18,
                color: TransparenceColors.mute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
