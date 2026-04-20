import 'package:flutter/material.dart';
import 'package:kido/constants.dart';
import '../../../Models/level3/letters/letterMap.dart';
import '../../../Widgets/content/level3/discoveryWidget.dart';
import '../../../Widgets/content/level3/letters/mysteryBox.dart';
import '../../../Widgets/content/level3/letters/dragAnddrop.dart';
import '../../../Widgets/content/level3/letters/bubblePop.dart';
import '../../../Widgets/journeyMap.dart';
import '../../../data/level3/letters/journeyLetters.dart';

class LettersMapPage extends StatefulWidget {
  const LettersMapPage({super.key});

  @override
  State<LettersMapPage> createState() => _LettersMapPageState();
}

class _LettersMapPageState extends State<LettersMapPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kidoGreen,
      body:JourneymapPage(
        journeyData: journeyEn,
        backgroundColor: AppColors.kidoGreen,
        nodeButtonColor: AppColors.kidoColors[4],
        detailFlowBuilder: (item) => LetterDetailsFlow(item: item,)

      )
    );
  }
}

class LetterDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const LetterDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiscoveryPage(
        model: item.letterData,
        onNextPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MysteryBox(
                model: item.letterData,
                onComplete: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DragDropLessonPage(
                        questionData: item.dragData,
                        letterAudio: item.letterData.audioName,
                        firstColor: item.letterData.bgColor,
                        secondColor: item.letterData.activeBorder,
                        onNext: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BubblePopGame(
                                targetLetter: item.charName,
                                audioPath: item.letterData.audioName,
                                onNext: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}