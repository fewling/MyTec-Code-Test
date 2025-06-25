import 'package:flutter/material.dart';

class Breathing extends StatefulWidget {
  const Breathing({
    super.key,
    required this.child,
    this.minScale = 0.9,
    this.maxScale = 1.1,
  });

  final Widget child;
  final double minScale;
  final double maxScale;

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final min = widget.minScale;
    final max = widget.maxScale;
    final range = max - min;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scaleX: min + range * _controller.value,
        scaleY: min + range * _controller.value,
        child: widget.child,
      ),
    );
  }
}
