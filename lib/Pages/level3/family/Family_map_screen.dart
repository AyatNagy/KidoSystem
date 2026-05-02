import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/Pages/level3/family/FamilySongScreen.dart';
import 'package:kido/Pages/level3/family/FamilyTreeScreen.dart';
import 'package:kido/Pages/level3/family/Family_journey_data.dart';
import 'package:kido/Pages/level3/family/family_lessons.dart';
import 'package:kido/Widgets/journey_map.dart';

class FamilyMapScreen extends StatefulWidget {
  const FamilyMapScreen({super.key});

  @override
  State<FamilyMapScreen> createState() => _FamilyMapScreenState();
}

class _FamilyMapScreenState extends State<FamilyMapScreen> {
  late final List<LetterJourney> journey = buildFamilyJourney();

  Widget _buildDestination(int index) {
    switch (index) {
      case 6:
        return const FamilySongScreen();
      case 7:
        return const FamilyTreeScreen();
      default:
        return FamilySoundScreen(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              '👨‍👩‍👧‍👦 Family',
              style: TextStyle(
                color: Color(0xFFD7A96B),
                fontFamily: 'arlrdbd',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'العائلة',
              style: TextStyle(
                color: Colors.black38,
                fontFamily: 'arlrdbd',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: JourneymapPage(
        journeyData: journey,
        backgroundColor: const Color(0xFFFFF8EC),
        nodeButtonColor: const Color(0xFFD7A96B),
        detailFlowBuilder: (item) {
          final index = journey.indexOf(item);
          return _buildDestination(index);
        },
      ),
    );
  }
}
