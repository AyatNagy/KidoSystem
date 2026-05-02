import 'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/learning_item.dart';
import 'package:kido/data/level3/numbers/number_lesson_english_data.dart';
import 'package:kido/Widgets/content/level3/numbers/number_lesson_widget.dart'; // Make sure you have this widget

class EnglishNumberLesson extends StatefulWidget {
  const EnglishNumberLesson({super.key});

  @override
  State<EnglishNumberLesson> createState() => _EnglishNumberLessonState();
}

class _EnglishNumberLessonState extends State<EnglishNumberLesson> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // We call the list from our Repository class
    final List<LearningItem> lessons =
        NumbersEnglishLessonRepo.numbersEnglessons;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return LearningItemWidget(
            data: lessons[index],
            isEnglish: true,
            onNext: () {
              if (index < lessons.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                );
              } else {
                // Handle what happens after Number 10
              }
            },
          );
        },
      ),
    );
  }
}
