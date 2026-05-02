import 'package:flutter/material.dart';
import 'package:kido/Pages/level3/numbers/numbers_train.dart';
import 'package:kido/Pages/level3/numbers/tracing_game.dart';
import 'package:kido/Widgets/content/level3/numbers/number_lesson_widget.dart';
import 'package:kido/constants.dart';
import 'package:kido/data/level3/numbers/numbers_journey.dart';
import 'package:kido/services/asset_service.dart';
import '../../../Models/level3/letters/letter_map.dart';
import '../../../Widgets/content/level3/letters/bubble_pop.dart';
import '../../../Widgets/journey_map.dart';

class NumbersMapPage extends StatefulWidget {
  final bool isEnglish;
  const NumbersMapPage({super.key, required this.isEnglish});

  @override
  State<NumbersMapPage> createState() => _NumbersMapPageState();
}

class _NumbersMapPageState extends State<NumbersMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        journeyData: widget.isEnglish ? journeyNumEng : journeyNumArab,
        backgroundColor: AppColors.kidoYellow,
        nodeButtonColor: AppColors.kidoColors[5],
        detailFlowBuilder: (item) {
          if (item.charName == 'train_phase1') {
            return NumbersTrain(
              phase: 1,
              language:
                  widget.isEnglish
                      ? TrainLessonLanguage.english
                      : TrainLessonLanguage.arabic,
            );
          } else if (item.charName == 'train_phase2') {
            return NumbersTrain(
              phase: 2,
              language:
                  widget.isEnglish
                      ? TrainLessonLanguage.english
                      : TrainLessonLanguage.arabic,
            );
          } else {
            return NumberDetailsFlow(item: item, isEnglish: widget.isEnglish);
          }
        },
      ),
    );
  }
}

class NumberDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  final bool isEnglish;
  const NumberDetailsFlow({
    super.key,
    required this.item,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kidoYellow,
      body: LearningItemWidget(
        data: item.letterData,
        isEnglish: isEnglish,
        onNext: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TracingGame(
                    question: item.tracingData!,
                    onComplete: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BubblePopGame(
                                targetLetter: item.charName!,
                                audioPath: item.letterData.audioPath,
                                onNext: () {
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop()
                                    ..pop(true);
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
