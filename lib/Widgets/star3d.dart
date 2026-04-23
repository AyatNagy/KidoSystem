// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Star3DWidget extends StatefulWidget {
  final bool filled;
  const Star3DWidget({super.key, required this.filled});

  @override
  State<Star3DWidget> createState() => _Star3DWidgetState();
}

class _Star3DWidgetState extends State<Star3DWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;
  bool _prevFilled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotateAnim = Tween(
      begin: 0.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void didUpdateWidget(Star3DWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filled && !_prevFilled) {
      _controller.forward(from: 0);
    }
    _prevFilled = widget.filled;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(_rotateAnim.value),
            child: _build3DStar(widget.filled),
          ),
        );
      },
    );
  }

  Widget _build3DStar(bool filled) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Shadow layer (depth effect)
        Transform.translate(
          offset: const Offset(3, 4),
          child: Icon(
            Icons.star,
            size: 56,
            color:
                filled
                    ? Colors.orange.shade900.withOpacity(0.4)
                    : Colors.grey.shade600.withOpacity(0.2),
          ),
        ),

        // Dark side layer (3D bevel)
        Icon(
          Icons.star,
          size: 56,
          color: filled ? Colors.orange.shade700 : Colors.grey.shade500,
        ),

        // Bright top layer (light reflection)
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    filled
                        ? [
                          Colors.yellow.shade200,
                          Colors.amber,
                          Colors.orange.shade700,
                        ]
                        : [
                          Colors.grey.shade300,
                          Colors.grey.shade400,
                          Colors.grey.shade600,
                        ],
                stops: const [0.0, 0.4, 1.0],
              ).createShader(bounds),
          child: const Icon(Icons.star, size: 54),
        ),

        // Shine dot (top-left glint)
        if (filled)
          Positioned(
            top: 8,
            left: 14,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ),
      ],
    );
  }
}
