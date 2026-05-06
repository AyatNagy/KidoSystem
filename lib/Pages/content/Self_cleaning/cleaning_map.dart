import 'package:flutter/material.dart';
import 'package:kido/Pages/content/Self_cleaning/HandwashScreen.dart';
import 'package:kido/Pages/content/Self_cleaning/TrashScreen.dart';
import 'package:kido/Pages/content/Self_cleaning/teeth_game_screen.dart';
import 'package:kido/Widgets/content/journey_map.dart';

class HygieneItem {
  final String image;
  final String title;
  bool isLocked;

  HygieneItem({
    required this.image,
    required this.title,
    this.isLocked = false,
  });
}

class CleaningMap extends StatefulWidget {
  const CleaningMap({super.key});

  @override
  State<CleaningMap> createState() => _CleaningMapState();
}

class _CleaningMapState extends State<CleaningMap> {
  final List<HygieneItem> journey = [
    HygieneItem(
      title: 'اغسل إيديك',
      image: 'assets/images/clean/wash_hand.gif',
      isLocked: false,
    ),
    HygieneItem(
      title: 'نظّف أسنانك',
      image: 'assets/images/clean/teeth_brush.gif',
      isLocked: false,
    ),
    HygieneItem(
      title: 'ارمي القمامة',
      image: 'assets/images/clean/trash.jpg',
      isLocked: false,
    ),
  ];

  Widget _buildDestination(int index) {
    switch (index) {
      case 0:
        return const HandwashScreen();
      case 1:
        return TeethGameScreen();
      case 2:
        return const TrashScreen();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFB),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                '🧼',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32),
              ),
            ),
            Expanded(
              child: JourneymapPage(
                journeyData: journey,
                backgroundColor: const Color(0xFFF7FAFB),
                nodeButtonColor: const Color(0xFF0D4A6A),
                detailFlowBuilder: (item) {
                  final index = journey.indexOf(item);
                  if (index == -1) return const SizedBox();
                  return _buildDestination(index);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('تعلم العادات الصحية ✨', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
