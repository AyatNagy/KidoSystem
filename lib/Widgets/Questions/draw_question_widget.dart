import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../Models/draw_question.dart';

class DrawingPoint {
  Offset point;
  DrawingPoint(this.point);
}

class DrawingQuestionWidget extends StatefulWidget {
  final DrawingQuestion question;
  final Function(List<Offset>) onDrawingUpdate;
  final VoidCallback onClear;

  const DrawingQuestionWidget({
    super.key,
    required this.question,
    required this.onDrawingUpdate,
    required this.onClear,
  });

  @override
  State<DrawingQuestionWidget> createState() => _DrawingQuestionWidgetState();
}

class _DrawingQuestionWidgetState extends State<DrawingQuestionWidget> {
  List<List<DrawingPoint>> paths = [];
  List<DrawingPoint> currentPath = [];
  List<List<DrawingPoint>> redoStack = [];

  void _onPanStart(DragStartDetails details) {
    currentPath = [DrawingPoint(details.localPosition)];
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      currentPath.add(DrawingPoint(details.localPosition));
      widget.onDrawingUpdate(_getAllPoints());
    });
  }

  void _onPanEnd(_) {
    if (currentPath.isNotEmpty) {
      paths.add(List.from(currentPath));
      currentPath.clear();
      redoStack.clear();
      widget.onDrawingUpdate(_getAllPoints());
    }
  }

  List<Offset> _getAllPoints() {
    List<Offset> allPoints = [];
    for (var path in paths) {
      allPoints.addAll(path.map((dp) => dp.point));
    }
    allPoints.addAll(currentPath.map((dp) => dp.point));
    return allPoints;
  }

  void _clearCanvas() {
    setState(() {
      paths.clear();
      currentPath.clear();
      redoStack.clear();
      widget.onClear();
    });
  }

  void _undo() {
    if (paths.isNotEmpty) {
      setState(() {
        redoStack.add(paths.removeLast());
        widget.onDrawingUpdate(_getAllPoints());
      });
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        paths.add(redoStack.removeLast());
        widget.onDrawingUpdate(_getAllPoints());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    return Column(
      children: [
        if (widget.question.image.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              widget.question.image,
              height: config.imageHeight(0.2),
              fit: BoxFit.contain,
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 4),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: DrawingPainter(
                  [
                    ...paths.expand((p) => p),
                    ...currentPath,
                  ].map((dp) => dp.point).toList(),
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _undo,
              icon: const Icon(Icons.undo),
              label: const Text('Undo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFDAB9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _redo,
              icon: const Icon(Icons.redo),
              label: const Text('Redo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff4bd6ac),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _clearCanvas,
              icon: const Icon(Icons.clear),
              label: const Text('Clear'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffff8a65),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 12.0
          ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}
