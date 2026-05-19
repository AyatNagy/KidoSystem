import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letters/letter_map.dart';
import 'package:kido/Pages/content/level2/sizes/size_intro_page.dart';
import 'package:kido/enum/size_goal.dart';
import 'package:kido/utils/category_progress.dart';
import '../../../../Widgets/content/journey_map.dart';
import '../../../../data/content/level2/size/sizes_journy_data.dart';

class SizesMapPage extends StatelessWidget {
  final int childId;

  const SizesMapPage({super.key, this.childId = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        childId: childId,
        resolveLessonId: (item, _) =>
            sizeLessonIdFromCharName((item as LetterJourney).charName),
        journeyData: sizesJourney,
        backgroundColor: const Color(0xFFFDF6F0),
        nodeButtonColor: Colors.orangeAccent,
        detailFlowBuilder: (item) {
          return SizesDetailsFlow(item: item);
        },
      ),
    );
  }
}

class SizesDetailsFlow extends StatelessWidget {
  final LetterJourney item;
  const SizesDetailsFlow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final goal = _getGoalFromName(item.charName!);

    return SizeIntroPage(goal: goal);
  }

  SizeGoal _getGoalFromName(String name) {
    return SizeGoal.values.firstWhere((e) => e.name == name);
  }
}
