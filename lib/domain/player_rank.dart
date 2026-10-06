/// Soft paliers on put-backs — 1 / 10 / 50, named after the gesture.
final class PlayerRank {
  const PlayerRank({
    required this.level,
    required this.title,
    required this.esquives,
    required this.scans,
    required this.nextAt,
  });

  final int level;

  /// Milestone reached, or empty before the first put-back.
  final String title;
  final int esquives;
  final int scans;

  /// Put-backs needed for the next palier, or null at max.
  final int? nextAt;

  int get xpIntoLevel {
    final floor = _floors[level.clamp(0, _floors.length - 1)];
    return esquives - floor;
  }

  int? get xpForNext {
    final next = nextAt;
    if (next == null) return null;
    final floor = _floors[level.clamp(0, _floors.length - 1)];
    return next - floor;
  }

  double get progress {
    final span = xpForNext;
    if (span == null || span <= 0) return 1;
    return (xpIntoLevel / span).clamp(0, 1);
  }

  bool get isMax => nextAt == null;

  bool get hasMilestone => title.isNotEmpty;
}

/// Labels name the gesture — not RPG ranks.
const _titles = [
  '',
  'Première esquive',
  'Dix esquives',
  'Cinquante esquives',
];

/// Floors: 0 → first put-back → 10 → 50.
const _floors = [0, 1, 10, 50];

PlayerRank playerRank({required int esquives, required int scans}) {
  final safe = esquives < 0 ? 0 : esquives;
  var level = 0;
  for (var i = _floors.length - 1; i >= 0; i--) {
    if (safe >= _floors[i]) {
      level = i;
      break;
    }
  }
  final next = level + 1 < _floors.length ? _floors[level + 1] : null;
  return PlayerRank(
    level: level,
    title: _titles[level],
    esquives: safe,
    scans: scans < 0 ? 0 : scans,
    nextAt: next,
  );
}
