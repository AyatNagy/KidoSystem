import 'package:flutter/material.dart';
import 'package:kido/Pages/content/Self_cleaning/HandwashScreen.dart';
import 'package:kido/Pages/content/Self_cleaning/TrashScreen.dart';
import 'package:kido/Pages/content/Self_cleaning/teeth_game_screen.dart';
import 'package:kido/Widgets/content/journey_map.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';

class HygieneItem {
  final String image;
  final String title;
  bool isLocked;
  HygieneItem({
    required this.image,
    required this.title,
    this.isLocked = false,
  });
}

class CleaningMap extends StatefulWidget {
  const CleaningMap({super.key});

  @override
  State<CleaningMap> createState() => _CleaningMapState();
}

class _CleaningMapState extends State<CleaningMap> {
  final DragDropQuestion trashQuestionData = DragDropQuestion(
    examId: ['clean_mission'],
    questionAudio: "ارمي القمامة في السلة",
    backgroundImage: 'assets/images/clean/Trash/TrashBackground.png',
    targets: [
      DragTargetZone(
        id: 'bin',
        image: 'assets/images/clean/Trash/closedBasket.png',
        position: const Offset(0.35, 0.65),
        size: const Size(0.3, 0.3),
        acceptedItemIds: ['banana', 'bottle', 'paper'],
      ),
    ],
    items: [
      DragItem(
        id: 'banana',
        image: 'assets/images/clean/Trash/قشرة_موزة.png',
        startPosition: const Offset(0.1, 0.4),
        size: const Size(0.15, 0.1),
      ),
      DragItem(
        id: 'bottle',
        image: 'assets/images/clean/Trash/زجاجة_بلاستيك.png',
        startPosition: const Offset(0.7, 0.5),
        size: const Size(0.1, 0.18),
      ),
      DragItem(
        id: 'paper',
        image: 'assets/images/clean/Trash/ورقة_مجعدة.png',
        startPosition: const Offset(0.4, 0.3),
        size: const Size(0.12, 0.12),
      ),
    ],
  );

  final List<HygieneItem> journey = [
    HygieneItem(
      title: 'اغسل إيديك',
      image: 'assets/images/clean/wash_hand.gif',
    ),
    HygieneItem(
      title: 'نظّف أسنانك',
      image: 'assets/images/clean/teeth_brush.gif',
    ),
    HygieneItem(title: 'ارمي القمامة', image: 'assets/images/clean/trash.jpg'),
  ];

  Widget _buildDestination(int index) {
    switch (index) {
      case 0:
        return const HandwashScreen();
      case 1:
        return TeethGameScreen();
      case 2:
        return TrashGameWidget(
          question: trashQuestionData,
          onAnswered: (answers) {
            if (answers.length == 3) debugPrint("تم بنجاح!");
          },
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFB),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '🧼 رحلة النظافة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: JourneymapPage(
                journeyData: journey,
                backgroundColor: const Color(0xFFF7FAFB),
                nodeButtonColor: const Color(0xFF0D4A6A),
                detailFlowBuilder: (item) {
                  final index = journey.indexOf(item);
                  if (index == -1) return const SizedBox();
                  return _buildDestination(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
