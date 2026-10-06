import 'package:flutter/material.dart';

/// Fade + slide up entrance — light fun motion, delayable for stagger.
class Entrance extends StatefulWidget {
  const Entrance({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
    this.slide = 0.08,
    this.scaleFrom = 0.96,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slide;
  final double scaleFrom;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = curve;
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slide),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(
      begin: widget.scaleFrom,
      end: 1,
    ).animate(curve);
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
