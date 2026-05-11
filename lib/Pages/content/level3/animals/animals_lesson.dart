import 'package:flutter/material.dart';
import 'package:kido/Widgets/content/level3/discovery_widget.dart';
import 'package:kido/data/level3/animals/animals_data.dart';

class AnimalsDiscoveryScreen extends StatefulWidget {
  const AnimalsDiscoveryScreen({super.key});

  @override
  State<AnimalsDiscoveryScreen> createState() => _AnimalsDiscoveryScreenState();
}

class _AnimalsDiscoveryScreenState extends State<AnimalsDiscoveryScreen> {
  final PageController _pageController = PageController();

  void _handleNextage() {
    if (_pageController.page!.toInt() < animalsDiscovery.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: animalsDiscovery.length,
      itemBuilder: (context, index) {
        return DiscoveryPage(
          model: animalsDiscovery[index],
          onNextPressed: _handleNextage,
        );
      },
    );
  }
}
