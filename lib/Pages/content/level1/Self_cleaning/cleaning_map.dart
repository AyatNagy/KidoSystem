import 'package:flutter/material.dart';
import 'package:kido/Pages/content/level1/Self_cleaning/hand_wash_screen.dart';
import 'package:kido/Pages/content/level1/Self_cleaning/trash_screen.dart';
import 'package:kido/Pages/content/level1/Self_cleaning/teeth_game_screen.dart';
import 'package:kido/Widgets/content/journey_map.dart';
import 'package:kido/constants.dart';
import '../../../../data/content/level1/clean.dart';
import '../../../../data/content/level1/trash.dart';

class CleaningMap extends StatefulWidget {
  const CleaningMap({super.key});

  @override
  State<CleaningMap> createState() => _CleaningMapState();
}

class _CleaningMapState extends State<CleaningMap> {

  Widget _buildDestination(String title) {
    if (title == 'اغسل إيديك') {
      return const HandwashScreen();
    }

    if (title == 'نظّف أسنانك') {
      return TeethGameScreen();
    }

    return TrashGameWidget(
      question: trashQuestionData,
      onAnswered: (answers) {
        if (answers.length == 3) {
          debugPrint("تم بنجاح!");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JourneymapPage(
        journeyData: journey,
        backgroundColor: AppColors.kidoBlue,
        nodeButtonColor: AppColors.blueColor,
        detailFlowBuilder: (item) {
          final title = item.title.toString();
          return Scaffold(
            body: SizedBox.expand(child: _buildDestination(title)),
          );
        },
      ),
    );
  }
}
