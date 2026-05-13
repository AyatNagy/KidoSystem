import 'package:flutter/material.dart';
import '../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../data/content/level3/vegetables/discovery_vegetables.dart';

class DiscoveryVegetables extends StatefulWidget {
  const DiscoveryVegetables({super.key});

  @override
  State<DiscoveryVegetables> createState() => _DiscoveryVegetablesState();
}

class _DiscoveryVegetablesState extends State<DiscoveryVegetables> {
  int _currentIndex = 0;

  void _handleNext() {
    setState(() {
      if (_currentIndex < vegetablesDiscovery.length - 1) {
        _currentIndex++;
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentVege = vegetablesDiscovery[_currentIndex];
    return DiscoveryPage(model: currentVege, onNextPressed: _handleNext);
  }
}
