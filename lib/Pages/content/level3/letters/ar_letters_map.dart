import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level3/letters/letter_trace_page.dart';
import 'package:kido/constants.dart';
import '../../../../Models/level3/letters/letter_map.dart';
import '../../../../Widgets/content/level3/discovery_widget.dart';
import '../../../../Widgets/content/level3/letters/bubble_pop.dart';
import '../../../../Widgets/content/level3/letters/drag_and_drop.dart';
import '../../../../Widgets/content/level3/letters/mystery_box.dart';
import '../../../../Widgets/content/journey_map.dart';
import '../../../../data/content/level3/letters/journey_letters.dart';
import 'package:kido/utils/journey_lesson_ids.dart';
import 'package:kido/utils/journey_navigation.dart';

class ArLettersMapPage extends StatefulWidget {
  final int childId;

  const ArLettersMapPage({super.key, this.childId = 0});

  @override
  State<ArLettersMapPage> createState() => _ArLettersMapPageState();
}

class _ArLettersMapPageState extends State<ArLettersMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        childId: widget.childId,
        resolveLessonId: (_, index) => lettersMapLessonId(index),
        journeyData: journeyAr,
        backgroundColor: AppColors.kidoYellow,
        nodeButtonColor: AppColors.kidoColors[5],
        detailFlowBuilder: (item) => ArLetterDetailsFlow(item: item),
      ),
    );
  }
}

class ArLetterDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const ArLetterDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MysteryBox(
        model: item.letterData,
        onComplete: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DiscoveryPage(
                model: item.letterData,
                onNextPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DragDropLessonPage(
                        questionData: item.dragData,
                        letterAudio: item.letterData.audioName,
                        firstColor: item.letterData.bgColor,
                        secondColor: item.letterData.activeBorder,
                        onNext: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BubblePopGame(
                                targetLetter: item.charName!,
                                audioPath:
                                item.letterData.audioName,
                                onNext: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (
                                          context,
                                          ) => LetterTracePage(
                                        letter: item.charName!,
                                        onComplete: () {
                                          finishJourneyNode(
                                            context,
                                            screensAboveMap: 4,
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
