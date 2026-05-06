import 'package:flutter/material.dart';
import 'vegetable_journey_data.dart';
import 'vegetable_quiz.dart';
import 'vegetable_song.dart';
import 'vegetable_sound.dart';
import 'package:kido/Widgets/content/journey_map.dart';

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
