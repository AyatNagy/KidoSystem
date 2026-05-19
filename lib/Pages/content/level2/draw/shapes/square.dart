import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level2/draw/shapes/triangle.dart';
import '../../../../../Models/level3/discovery.dart';
import '../../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../../Widgets/content/level2/shapes.dart';
import '../../../../../data/content/level2/shapes.dart';

class SquareDrawingPage extends StatefulWidget {
  final String childName;
  final int childId;

  const SquareDrawingPage({
    super.key,
    required this.childName,
    required this.childId,
  });

  @override
  State<SquareDrawingPage> createState() => _SquareDrawingPageState();
}

class _SquareDrawingPageState extends State<SquareDrawingPage> {
  bool _showDiscovery = true;

  @override
  Widget build(BuildContext context) {
    if (_showDiscovery) {
      return DiscoveryPage(
        model: _SquareDiscoveryItem(),
        onNextPressed: () {
          setState(() {
            _showDiscovery = false;
          });
        },
      );
    }

    return BaseDrawingPage(
      shapeData: ShapeData.square,
      successGif: 'assets/images/drawing/square.gif',
      childId: widget.childId,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                TriangleDrawingPage(childName: widget.childName, childId: widget.childId),
          ),
        );
      },
      shapeName: 'square',
    );
  }
}

class _SquareDiscoveryItem implements DiscoveryItem {
  @override
  String get mainImage => 'assets/images/drawing/square.gif';

  @override
  String? get extraImage => null;

  @override
  String get soundPath => 'assets/audio/shapes/square.mp3';

  @override
  Color get primaryColor => Colors.white;

  @override
  Color get background => Colors.white;
}