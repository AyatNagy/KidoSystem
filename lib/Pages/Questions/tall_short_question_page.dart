import 'package:flutter/material.dart';
import 'package:kido/Pages/Questions/match_food_question.dart';
import '../../Models/Question/question.dart';
import '../../Models/Question/question_group.dart';
import '../../Models/Question/question_item.dart';
import '../Questions/base_drag_drop_question_page.dart';

class TallShortQuestionPage extends StatelessWidget {
  const TallShortQuestionPage({super.key});

  static Question _createQuestion() {
    return Question(
      id: "tall_short_001",
      title: "Tall or Short?",
      groups: const [
        QuestionGroup(
          id: "tall",
          title: "TALL",
          color: Colors.blue,
          imagePath: "assets/images/tallbox.png",
          width: 150,
          height: 200,
        ),
        QuestionGroup(
          id: "short",
          title: "SHORT",
          color: Colors.orange,
          imagePath: "assets/images/shortbox.png",
          width: 150,
          height: 200,
        ),
      ],
      items: const [
        QuestionItem(
          id: "giraffe",
          imagePath: "assets/images/giraffe.png",
          correctGroupId: "tall",
          size: 50,
        ),
        QuestionItem(
          id: "tree",
          imagePath: "assets/images/tree.png",
          correctGroupId: "tall",
          size: 50,
        ),
        QuestionItem(
          id: "turtle",
          imagePath: "assets/images/turtle.png",
          correctGroupId: "short",
          size: 100,
        ),
        QuestionItem(
          id: "mushroom",
          imagePath: "assets/images/mushroom.png",
          correctGroupId: "short",
          size: 100,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _createQuestion();
    return BaseDragDropQuestionPage(
      question: question,
      onResult: (result) {
        print("Score: ${result.score * 100}%");
        print("Answers: ${result.answers}");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FoodMatchQuestionPage()),
        );
      },
    );
  }
}
