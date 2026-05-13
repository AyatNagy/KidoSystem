import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level3/vegetables/garden.dart';
import 'package:kido/constants.dart';
import '../../../../Models/level3/letters/letter_map.dart';
import '../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../Widgets/content/journey_map.dart';
import '../../../../data/content/level3/vegetables/vegetables_journey.dart';

class VegetablesMapPage extends StatefulWidget {
  const VegetablesMapPage({super.key});

  @override
  State<VegetablesMapPage> createState() => _VegetablesMapPageState();
}

class _VegetablesMapPageState extends State<VegetablesMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        journeyData: journeyVegetables,
        backgroundColor: AppColors.kidoGreen,
        nodeButtonColor: const Color(0xFF3A7D44),
        detailFlowBuilder: (item) => VegetablesDetailsFlow(item: item),
      ),
    );
  }
}

class VegetablesDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const VegetablesDetailsFlow({super.key, required this.item});

  String _getRandomDistractor() {
    final otherVegetables = journeyVegetables
        .where((element) => element.image != item.image)
        .toList();
    if (otherVegetables.isEmpty) return "assets/gif/onion.gif";
    otherVegetables.shuffle();
    return otherVegetables.first.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiscoveryPage(
        model: item.letterData,
        onNextPressed: () {
          final String distractor = _getRandomDistractor();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GardenHarvestGame(
                targetImage: item.image,
                distractorImage: distractor,
                soundPath: item.letterData.audioName,
                onComplete: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                  },
              ),
            ),
          );
        },
      ),
    );
  }
}