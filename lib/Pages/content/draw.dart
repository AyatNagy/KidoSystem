import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class draw extends StatefulWidget {
  @override
  _CreativeDrawPageState createState() => _CreativeDrawPageState();
}

class _CreativeDrawPageState extends State<draw> {
  late VideoPlayerController _controller;
  bool _videoFinished = false;
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.purpleAccent;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/audio/draw.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0);
        _controller.setPlaybackSpeed(0.7);
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration && !_videoFinished) {
        setState(() => _videoFinished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF9E3), Color(0xFFFFECB3)],
          ),
        ),
        child: Stack(
          children: [
            if (!_videoFinished && _controller.value.isInitialized)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.brown[400],
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),

            if (_videoFinished)
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    points.add(DrawingPoint(
                      offset: renderBox.globalToLocal(details.globalPosition),
                      paint: Paint()
                        ..color = selectedColor
                        ..strokeCap = StrokeCap.round
                        ..strokeWidth = 14.0
                        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
                    ));
                  });
                },
                onPanEnd: (details) => points.add(null),
                child: CustomPaint(
                  painter: SpecialDrawingPainter(points: points),
                  size: Size.infinite,
                ),
              ),
            if (_videoFinished)
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorButton(Colors.purpleAccent),
                      _colorButton(Colors.orangeAccent),
                      _colorButton(Colors.lightBlueAccent),
                      _colorButton(Colors.greenAccent),
                      IconButton(
                        icon: Icon(Icons.delete_sweep, color: Colors.redAccent, size: 30),
                        onPressed: () => setState(() => points.clear()),
                      ),
                    ],
                  ),
                ),
              ),
            if (_videoFinished)
              const Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "🎨",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'ComicSans',
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 4,
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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