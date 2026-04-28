import 'package:flutter/material.dart';
import 'package:kido/Pages/level3/numbers/tracing_game.dart';
import 'package:kido/Widgets/content/level3/numbers/number_lesson_widget.dart';
import 'package:kido/constants.dart';
import 'package:kido/data/level3/numbers/numbers_journey.dart';
import '../../../Models/level3/letters/letter_map.dart';
import '../../../Widgets/content/level3/letters/bubble_pop.dart';
import '../../../Widgets/journey_map.dart';


class NumbersMapPage extends StatefulWidget {
  final bool isEnglish;
  const NumbersMapPage({super.key,required this.isEnglish});

  @override
  State<NumbersMapPage> createState() => _NumbersMapPageState();
}

class _NumbersMapPageState extends State<NumbersMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        journeyData: widget.isEnglish?journeyNumEng:journeyNumArab,
        backgroundColor: AppColors.kidoYellow,
        nodeButtonColor: AppColors.kidoColors[5],
        detailFlowBuilder: (item) => NumberDetailsFlow(item: item),
      ),
    );
  }
}

class NumberDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const NumberDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  NumberLessonWidget(
                                data:item.letterData,
                                isEnglish: false,
                                onNext: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => TracingGame(
                                            question: item.tracingData,
                                            onComplete: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => BubblePopGame(
                                            targetLetter: item.charName!,
                                            audioPath:item.letterData.audioPath,
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
