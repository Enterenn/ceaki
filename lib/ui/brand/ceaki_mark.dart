import 'package:flutter/material.dart';
import 'package:transparence/ui/theme.dart';

/// Wordmark « Céaki ».
class CeakiMark extends StatelessWidget {
  const CeakiMark({super.key, this.size = 40, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? TransparenceColors.ink;
    return Text(
      'Céaki',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontSize: size,
        height: 1,
        letterSpacing: -1.4,
        color: ink,
        fontVariations: const [FontVariation('wght', 800)],
      ),
    );
  }
}
