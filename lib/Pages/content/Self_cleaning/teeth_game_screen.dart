import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// TEETH GAME SCREEN
// الطفل يحرك الفرشاة على الأسنان — بعد 5 حركات تظهر الأسنان النضيفة
// ─────────────────────────────────────────────────────────────
class TeethGameScreen extends StatefulWidget {
  const TeethGameScreen({super.key});

  @override
  State<TeethGameScreen> createState() => _TeethGameScreenState();
}

class _TeethGameScreenState extends State<TeethGameScreen> {
  // ── State ──────────────────────────────────────────────────
  int _strokes = 0;
  static const int _requiredStrokes = 3;

  double _brushX = 180;
  double _brushY = 400;
  bool get _isFinished => _strokes >= _requiredStrokes;
  double get _progress => (_strokes / _requiredStrokes).clamp(0.0, 1.0);
  void _onPanUpdate(DragUpdateDetails details) {
    if (_isFinished) return;
    setState(() {
      _brushX = details.localPosition.dx;
      _brushY = details.localPosition.dy;
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (_isFinished) return;
    setState(() => _strokes++);
  }

  void _reset() {
    setState(() {
      _strokes = 0;
      _brushX = 180;
      _brushY = 400;
    });
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FD),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Center(
                  child: Image.asset(
                    _isFinished
                        ? 'assets/images/clean/clean_boy.png'
                        : 'assets/images/clean/dirty_boy.png',
                    width: size.width * 0.78,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 60,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقدم: ${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D4A6A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withOpacity(0.6),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF29B6F6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Color(0xFF0D4A6A),
                  ),
                ),
              ),
            ),

            if (!_isFinished)
              Positioned(
                left: _brushX - 14,
                top: _brushY - 60,
                child: IgnorePointer(child: _ToothbrushWidget()),
              ),

            if (_isFinished)
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '🎉 أسنانك نضيفة!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0D4A6A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D4A6A),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'العب تاني 🦷',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToothbrushWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(28, 90), painter: _BrushPainter());
  }
}

class _BrushPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF29B6F6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.3,
          size.width * 0.4,
          size.height * 0.65,
        ),
        const Radius.circular(6),
      ),
      paint,
    );

    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.32),
      const Radius.circular(8),
    );
    paint.color = Colors.white;
    canvas.drawRRect(headRect, paint);

    paint
      ..color = const Color(0xFF29B6F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(headRect, paint);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF29B6F6);
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.19);
      canvas.drawLine(
        Offset(x, size.height * 0.02),
        Offset(x, size.height * 0.28),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BrushPainter old) => false;
}
