import "package:flutter/material.dart";

class PulseButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double pulseScale;
  final Duration duration;

  const PulseButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.pulseScale = 1.1,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.pulseScale
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}