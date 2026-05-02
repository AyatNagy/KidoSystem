import 'package:flutter/material.dart';
import 'package:kido/Pages/level3/numbers/tracing_game.dart';
import 'package:kido/Widgets/content/level3/numbers/number_lesson_widget.dart';
import 'package:kido/data/level3/shapes/shape_lessons.dart';
import 'package:kido/data/level3/shapes/tracing_shapes.dart';

class ShapesLearningPage extends StatefulWidget {
  const ShapesLearningPage({super.key});

  @override
  State<ShapesLearningPage> createState() => _ShapesLearningPageState();
}

class _ShapesLearningPageState extends State<ShapesLearningPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final items = ShapesLessonRepo.shapes;

    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return LearningItemWidget(
            data: items[index],
            isEnglish: true,
            onNext: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => TracingGame(
                        question: tracingCircle, // غيري حسب الشكل
                        onComplete: () {
                          Navigator.pop(context);
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        },
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
