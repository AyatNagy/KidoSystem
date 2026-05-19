import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/square.dart';
import '../../../../../Models/level3/discovery.dart';
import '../../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class CircleDrawingPage extends StatefulWidget {
  final String childName;
  final int childId;

  const CircleDrawingPage({
    super.key,
    required this.childName,
    required this.childId,
  });

  @override
  State<CircleDrawingPage> createState() => _CircleDrawingPageState();
}

class _CircleDrawingPageState extends State<CircleDrawingPage> {
  bool _showDiscovery = true;

  @override
  Widget build(BuildContext context) {
    if (_showDiscovery) {
      return DiscoveryPage(
        model: _CircleDiscoveryItem(),
        onNextPressed: () {
          setState(() {
            _showDiscovery = false;
          });
        },
      );
    }

    return BaseDrawingPage(
      shapeData: ShapeData.circle,
      successGif: 'assets/images/drawing/circle.gif',
      childId: widget.childId,
      onNext:
          () => Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
              SquareDrawingPage(childName: widget.childName, childId: widget.childId),
        ),
      ),
      shapeName: 'circle',
    );
  }
}

class _CircleDiscoveryItem implements DiscoveryItem {
  @override
  String get mainImage => 'assets/images/drawing/circle.gif';

  @override
  String? get extraImage => null;

  @override
  String get soundPath => 'assets/audio/shapes/circle.mp3';

  @override
  Color get primaryColor => Colors.white;

  @override
  Color get background => Colors.white;
}