import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/level2home.dart';
import '../../../../../Models/level3/discovery.dart';
import '../../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class TriangleDrawingPage extends StatefulWidget {
  final String childName;
  final int childId;

  const TriangleDrawingPage({
    super.key,
    required this.childName,
    required this.childId,
  });

  @override
  State<TriangleDrawingPage> createState() => _TriangleDrawingPageState();
}

class _TriangleDrawingPageState extends State<TriangleDrawingPage> {
  bool _showDiscovery = true;

  @override
  Widget build(BuildContext context) {
    if (_showDiscovery) {
      return DiscoveryPage(
        model: _TriangleDiscoveryItem(),
        onNextPressed: () {
          setState(() {
            _showDiscovery = false;
          });
        },
      );
    }

    return BaseDrawingPage(
      shapeData: ShapeData.triangle,
      successGif: 'assets/images/drawing/triangle.gif',
      childId: widget.childId,
      lessonId: 26,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Level2Home(
              childName: widget.childName,
              childId: widget.childId,
            ),
          ),
        );
      },
      shapeName: 'triangle',
    );
  }
}

class _TriangleDiscoveryItem implements DiscoveryItem {
  @override
  String get mainImage => 'assets/images/drawing/triangle.gif';

  @override
  String? get extraImage => null;

  @override
  String get soundPath => 'assets/audio/shapes/triangle.mp3';

  @override
  Color get primaryColor => Colors.white;

  @override
  Color get background => Colors.white;
}