// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import '../../../../Widgets/Painter/teeth_painter.dart';

class TeethGameScreen extends StatefulWidget {
  const TeethGameScreen({super.key});

  @override
  State<TeethGameScreen> createState() => _TeethGameScreenState();
}

class _TeethGameScreenState extends State<TeethGameScreen> {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
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
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueColor,
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
                        AppColors.kidoBlue,
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
                    color: AppColors.blueColor,
                  ),
                ),
              ),
            ),

            if (!_isFinished)
              Positioned(
                left: _brushX - 14,
                top: _brushY - 60,
                child: IgnorePointer(child: ToothbrushWidget()),
              ),

            if (_isFinished)
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueColor,
                          foregroundColor: AppColors.bgColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'العب تاني',
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