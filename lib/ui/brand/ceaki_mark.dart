import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:transparence/ui/theme.dart';

/// Wordmark « Céaki » with a lightly tilted « ? ».
class CeakiMark extends StatelessWidget {
  const CeakiMark({
    super.key,
    this.size = 40,
    this.color,
    this.questionColor,
  });

  final double size;
  final Color? color;
  final Color? questionColor;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? TransparenceColors.ink;
    final mark = questionColor ?? ink;
    final base = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontSize: size,
      height: 1,
      letterSpacing: -1.4,
      color: ink,
      fontVariations: const [FontVariation('wght', 800)],
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Céaki', style: base),
        Transform.translate(
          offset: Offset(size * 0.02, -size * 0.08),
          child: Transform.rotate(
            angle: 12 * math.pi / 180,
            alignment: Alignment.bottomLeft,
            child: Text(
              '?',
              style: base?.copyWith(color: mark),
            ),
          ),
        ),
      ],
    );
  }
}
