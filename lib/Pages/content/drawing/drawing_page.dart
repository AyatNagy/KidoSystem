import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../Widgets/ResponsiveProvider.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.purpleAccent;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  void _setupAudio() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setSource(AssetSource('audio/scratch.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startSound() async {
    if (!_isPlaying) {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
  }

  void _stopSound() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    }
  }

  void _clearCanvas() {
    HapticFeedback.vibrate();
    setState(() => points.clear());
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE0F2F1), Color(0xFFB9F6CA)],
                ),
              ),
              child: GestureDetector(
                onPanStart: (details) => _startSound(),
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    points.add(DrawingPoint(
                      offset: renderBox.globalToLocal(details.globalPosition),
                      paint: Paint()
                        ..color = selectedColor
                        ..strokeCap = StrokeCap.round
                        ..strokeWidth = config.isTablet ? 18.0 : 14.0
                        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
                    ));
                  });
                },
                onPanEnd: (details) {
                  _stopSound();
                  points.add(null);
                },
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: SpecialDrawingPainter(points: points),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            Positioned(
              right: config.localWidth * 0.04,
              top: config.localHeight * 0.15,
              bottom: config.localHeight * 0.15,
              child: Container(
                width: config.isTablet ? 85 : 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorButton(Colors.redAccent, config),
                    _colorButton(Colors.orangeAccent, config),
                    _colorButton(Colors.yellow, config),
                    _colorButton(Colors.greenAccent, config),
                    _colorButton(Colors.blueAccent, config),
                    _colorButton(Colors.purpleAccent, config),
                    const Divider(indent: 15, endIndent: 15),
                    IconButton(
                      icon: Icon(Icons.delete_sweep,
                          color: Colors.redAccent,
                          size: config.isTablet ? 40 : 32),
                      onPressed: _clearCanvas,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: config.localHeight * 0.06,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: config.localWidth * 0.06,
                      vertical: config.localHeight * 0.015
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: selectedColor.withOpacity(0.5), width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: Text(
                    "املأ الشاشة ألوان وحركات! ✨",
                    style: TextStyle(
                      fontSize: config.title,
                      fontWeight: FontWeight.bold,
                      color: selectedColor == Colors.yellow ? Colors.orange : selectedColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color, var config) {
    bool isSelected = selectedColor == color;
    double buttonSize = config.isTablet ? 60.0 : 48.0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => selectedColor = color);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? buttonSize : buttonSize - 10,
        height: isSelected ? buttonSize : buttonSize - 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black54 : Colors.white,
            width: isSelected ? 4 : 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12)]
              : [],
        ),
      ),
    );
  }
}

class DrawingPoint {
  Offset offset;
  Paint paint;
  DrawingPoint({required this.offset, required this.paint});
}

class SpecialDrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  SpecialDrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.offset, points[i + 1]!.offset, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(SpecialDrawingPainter oldDelegate) => true;
}