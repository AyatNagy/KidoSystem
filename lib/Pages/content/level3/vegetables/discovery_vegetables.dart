import 'package:flutter/material.dart';
import '../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../data/content/level3/fruits/fruits_discovery.dart';
import '../../../../data/content/level3/fruits/fruits_pixel.dart';

class DiscoveryVegetables extends StatefulWidget {
  const DiscoveryVegetables({super.key});

  @override
  State<DiscoveryVegetables> createState() => _DiscoveryVegetablesState();
}

class _DiscoveryVegetablesState extends State<DiscoveryVegetables> {
  int _currentIndex = 0;

  void _handleNext() {
    setState(() {
      if (_currentIndex < fruits.length - 1) {
        _currentIndex++;
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFruit = fruitsDiscovery[_currentIndex];
    return DiscoveryPage(model: currentFruit, onNextPressed: _handleNext);
  }
}
