// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatefulWidget {
  final int stars;
  final String letter;
  final VoidCallback onContinue;

  const CelebrationOverlay({
    super.key,
    required this.stars,
    required this.letter,
    required this.onContinue,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _rnd = math.Random();

  @override
  void initState() {
    super.initState();

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _particles.addAll(List.generate(60, (_) => _ConfettiParticle(_rnd)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.black45)),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder:
                  (_, __) => CustomPaint(
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _confettiController.value,
                    ),
                  ),
            ),
          ),
          Center(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: _buildCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final messages = {
      1: ('🌟', 'Keep Trying!', 'حاول تاني وهتبقى أحسن!'),
      2: ('🌟🌟', 'Good Job!', 'كويس جداً! تقدر تعمل أحسن!'),
      3: ('🌟🌟🌟', 'Amazing!', 'رائع يا بطل! عملتها!'),
    };

    final msg = messages[widget.stars.clamp(1, 3)]!;

    return Container(
      width: 340,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.amber, width: 3),
            ),
            child: Center(
              child: Text(
                widget.letter,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(msg.$1, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            msg.$2,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            msg.$3,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                label: 'Try Again',
                icon: Icons.refresh_rounded,
                color: Colors.orange,
                onTap: () => Navigator.of(context).pop(),
              ),
              _buildButton(
                label: 'Next',
                icon: Icons.arrow_forward_rounded,
                color: Colors.green,
                onTap: widget.onContinue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}

class _ConfettiParticle {
  final double x;
  final double speedY;
  final double speedX;
  final Color color;
  final double size;
  final double rotation;

  _ConfettiParticle(math.Random rnd)
    : x = rnd.nextDouble(),
      speedY = 0.3 + rnd.nextDouble() * 0.7,
      speedX = (rnd.nextDouble() - 0.5) * 0.3,
      color = Colors.primaries[rnd.nextInt(Colors.primaries.length)],
      size = 6 + rnd.nextDouble() * 8,
      rotation = rnd.nextDouble() * math.pi;
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = size.height * progress * p.speedY;
      final x = size.width * p.x + size.width * progress * p.speedX;
      if (y > size.height) continue;

      final paint = Paint()..color = p.color.withOpacity(1 - progress * 0.5);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * p.rotation * 5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
