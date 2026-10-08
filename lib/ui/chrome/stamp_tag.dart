import 'package:flutter/material.dart';
import 'package:transparence/ui/theme.dart';

/// Soft-square stamp label — Z sticker energy on result scenes.
class StampTag extends StatelessWidget {
  const StampTag({
    required this.label,
    this.background = TransparenceColors.ink,
    this.foreground = TransparenceColors.lime,
    this.tilt = 0,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;

  /// Radians — tiny tilt for sticker feel (keep under ~0.06).
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final tag = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: TransparenceRadii.all,
        boxShadow: TransparenceShadows.stamp,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foreground,
            letterSpacing: 1.1,
            fontVariations: const [FontVariation('wght', 700)],
          ),
        ),
      ),
    );
    if (tilt == 0) return tag;
    return Transform.rotate(angle: tilt, child: tag);
  }
}
