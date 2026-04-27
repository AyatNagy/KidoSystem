import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letters/letter_map.dart';
import 'vegetable_journey_data.dart';
import 'VegetableQuiz.dart';
import 'VegetableSong.dart';
import 'VegetableSound.dart';
import 'package:kido/Widgets/journey_map.dart';

class VegetableMapScreen extends StatefulWidget {
  const VegetableMapScreen({super.key});

  @override
  State<VegetableMapScreen> createState() => _VegetableMapScreenState();
}

class _VegetableMapScreenState extends State<VegetableMapScreen> {
  late final List journey =
      buildVegetableJourney().map((item) {
        item.isLocked = false;
        return item;
      }).toList();
  Widget _buildDestination(int index) {
    if (index == 5) {
      return VegetableQuiz();
    } else if (index == 6) {
      return VegetableSong();
    } else {
      return VegetableSound(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF6FBF4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              '🥦 Vegetables',
              style: TextStyle(
                color: Color(0xFF3A7D44),
                fontFamily: 'arlrdbd',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'الخضروات',
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
        backgroundColor: const Color(0xFFF6FBF4),
        nodeButtonColor: const Color(0xFF3A7D44),
        detailFlowBuilder: (item) {
          final index = journey.indexOf(item);
          if (index == -1) return const SizedBox();
          return _buildDestination(index);
        },
      ),
    );
  }
}
