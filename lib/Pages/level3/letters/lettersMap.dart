import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import '../../../Widgets/map.dart';
import '../../../data/level3/letters/journeyLetters.dart';

class LettersMapPage extends StatefulWidget {
  const LettersMapPage({super.key});

  @override
  State<LettersMapPage> createState() => _LettersMapPageState();
}

class _LettersMapPageState extends State<LettersMapPage> {

  void _onNodeTap(int index) async {
    final currentStep = journeyEn[index];
    final bool? examPassed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LetterDetailsFlow(letter: currentStep.image),
      ),
    );
    if (examPassed == true) {
      setState(() {
        journeyEn[index].isCompleted = true;
        if (index + 1 < journeyEn.length) {
          journeyEn[index + 1].isLocked = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 100),
        itemCount: journeyEn.length,
        itemBuilder: (context, index) {
          return MapNode(
            index: index,
            totalItems: journeyEn.length,
            lesson: journeyEn[index],
            buttonColor: AppColors.kidoColors[0],
            onTap: () => _onNodeTap(index),
          );
        },
      ),
    );
  }
}

class LetterJourney {
  final String image;
  bool isLocked;
  bool isCompleted;

  LetterJourney({
    required this.image,
    this.isLocked = true,
    this.isCompleted = false,
  });
}
class LetterDetailsFlow extends StatelessWidget {
  final String letter;
  const LetterDetailsFlow({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Letter $letter")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Finish Exam"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
    );
  }
}