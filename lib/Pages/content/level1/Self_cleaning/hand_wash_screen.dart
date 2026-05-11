// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kido/constants.dart';

class HandwashScreen extends StatefulWidget {
  const HandwashScreen({super.key});

  @override
  State<HandwashScreen> createState() => _HandwashScreenState();
}

class _HandwashScreenState extends State<HandwashScreen> {
  double _progress = 0.0;
  bool _done = false;
  bool _dragging = false;

  Offset _soapPos = const Offset(16, 16);
  Offset _dragStart = Offset.zero;
  Offset _soapStart = Offset.zero;

  final List<_Bubble> _bubbles = [];
  Timer? _fadeTimer;
  final _rand = Random();

  double get _dirtyOpacity =>
      _progress < 0.15
          ? 1.0
          : (1.0 - ((_progress - 0.15) / 0.3)).clamp(0.0, 1.0);
  double get _scrubOpacity =>
      _progress < 0.15
          ? 0.0
          : _progress < 0.9
          ? ((_progress - 0.15) / 0.25).clamp(0.0, 1.0)
          : (1.0 - (_progress - 0.9) / 0.1).clamp(0.0, 1.0);
  double get _cleanOpacity =>
      _progress < 0.9 ? 0.0 : ((_progress - 0.9) / 0.1).clamp(0.0, 1.0);

  void _onPanStart(DragStartDetails d, Size area) {
    if (_done) return;
    final pos = d.localPosition;
    if ((pos - (_soapPos + const Offset(32, 32))).distance > 38) return;
    setState(() {
      _dragging = true;
      _dragStart = pos;
      _soapStart = _soapPos;
    });
  }

  void _onPanUpdate(DragUpdateDetails d, Size area) {
    if (!_dragging || _done) return;
    setState(() {
      final newX = (_soapStart.dx + d.localPosition.dx - _dragStart.dx).clamp(
        0.0,
        area.width - 64,
      );
      final newY = (_soapStart.dy + d.localPosition.dy - _dragStart.dy).clamp(
        0.0,
        area.height - 64,
      );
      _soapPos = Offset(newX, newY);

      final cx = _soapPos.dx + 32;
      final cy = _soapPos.dy + 32;
      for (int i = 0; i < 2; i++) {
        _bubbles.add(
          _Bubble(
            position: Offset(
              cx + (_rand.nextDouble() - 0.5) * 50,
              cy + (_rand.nextDouble() - 0.5) * 50,
            ),
            size: 6 + _rand.nextDouble() * 16,
            opacity: 0.7 + _rand.nextDouble() * 0.3,
          ),
        );
      }
      if (_bubbles.length > 60) _bubbles.removeRange(0, _bubbles.length - 50);

      _progress = (_progress + 0.002).clamp(0.0, 1.0);
      if (_progress >= 1.0) _finish();
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (!_dragging) return;
    setState(() => _dragging = false);
    _fadeTimer?.cancel();
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        for (final b in _bubbles) {
          b.opacity -= 0.07;
        }
        _bubbles.removeWhere((b) => b.opacity <= 0);
      });
      if (_bubbles.isEmpty) t.cancel();
    });
  }

  void _finish() {
    _done = true;
    _bubbles.clear();
  }

  void _restart() {
    setState(() {
      _progress = 0;
      _done = false;
      _dragging = false;
      _soapPos = const Offset(16, 16);
      _bubbles.clear();
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 22,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 12,
                      backgroundColor: AppColors.bgColor,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.kidoBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kidoBlue,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    color: const Color(0xFFEAF4FD),
                    child: LayoutBuilder(
                      builder: (ctx, cs) {
                        final size = Size(cs.maxWidth, cs.maxHeight);
                        return GestureDetector(
                          onPanStart: (d) => _onPanStart(d, size),
                          onPanUpdate: (d) => _onPanUpdate(d, size),
                          onPanEnd: _onPanEnd,
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              Positioned.fill(
                                child: Opacity(
                                  opacity: _dirtyOpacity,
                                  child: Image.asset(
                                    'assets/images/clean/Hand_start.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              if (_progress > 0.05)
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: _scrubOpacity,
                                    child: Image.asset(
                                      'assets/images/clean/Hand_Scrup.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              if (_progress > 0.85)
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: _cleanOpacity,
                                    child: Image.asset(
                                      'assets/images/clean/Hand_Complete.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                              ..._bubbles.map(
                                (b) => Positioned(
                                  left: b.position.dx - b.size / 2,
                                  top: b.position.dy - b.size / 2,
                                  child: Opacity(
                                    opacity: b.opacity.clamp(0.0, 1.0),
                                    child: Container(
                                      width: b.size,
                                      height: b.size,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(
                                            0xFF3AABDB,
                                          ).withOpacity(0.6),
                                          width: 1.5,
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              if (!_done)
                                Positioned(
                                  left: _soapPos.dx,
                                  top: _soapPos.dy,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.kidoBlue.withOpacity(_dragging ? 0.4 : 0.2),
                                          blurRadius: _dragging ? 16 : 8,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/clean/tools_soap.png',
                                      width: _dragging ? 72 : 64,
                                      height: _dragging ? 72 : 64,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            if (_done) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _restart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueColor,
                      foregroundColor: AppColors.bgColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'العب تاني',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _Bubble {
  Offset position;
  double size;
  double opacity;
  _Bubble({required this.position, required this.size, required this.opacity});
}
