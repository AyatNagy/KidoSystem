import 'package:flutter/material.dart';
import 'package:kido/data/level3/numbers/number_lesson_arabic_data.dart';
import 'package:kido/Widgets/content/level3/numbers/number_lesson_widget.dart'; // Make sure you have this widget

class ArabicNumberLesson extends StatefulWidget {
  const ArabicNumberLesson({super.key, required Null Function() onNext});

  @override
  State<ArabicNumberLesson> createState() => _ArabicNumberLessonState();
}

class _ArabicNumberLessonState extends State<ArabicNumberLesson> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // We call the list from our Repository class
    final lessons = NumbersArabicLessonRepo.numbersArablessons;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return NumberLessonWidget(
            data: lessons[index],
            isEnglish: false,
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
