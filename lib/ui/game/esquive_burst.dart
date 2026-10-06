import 'package:flutter/material.dart';
import 'package:transparence/ui/theme.dart';

/// Soft confirmation after a put-back.
class EsquiveBurst extends StatelessWidget {
  const EsquiveBurst({required this.line, this.rankTitle, super.key});

  final String line;
  final String? rankTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = rankTitle;
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: TransparenceColors.lime, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
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
    );
  }
}
