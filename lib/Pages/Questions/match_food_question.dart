import 'package:flutter/material.dart';
import 'package:kido/Models/Question/question.dart';
import 'package:kido/Models/Question/question_group.dart';
import 'package:kido/Models/Question/question_item.dart';
import 'package:kido/Pages/Questions/base_drag_drop_question_page.dart';
import 'package:kido/Pages/Questions/kitchen_bedroom_question.dart';

class FoodMatchQuestionPage extends StatelessWidget {
  const FoodMatchQuestionPage({super.key});

  static Question _createQuestion() {
    return Question(
      id: "food_match_001",
      title: "Match the Food!",
      groups: const [
        QuestionGroup(
          id: "dog",
          title: "Dog",
          color: Colors.brown,
          imagePath: "assets/images/dog.png",
          width: 100,
          height: 180,
        ),
        QuestionGroup(
          id: "cat",
          title: "Cat",
          color: Colors.orange,
          imagePath: "assets/images/cat.png",
          width: 100,
          height: 180,
        ),
        QuestionGroup(
          id: "bird",
          title: "Bird",
          color: Colors.blue,
          imagePath: "assets/images/bird.png",
          width: 100,
          height: 180,
        ),
      ],
      items: const [
        QuestionItem(
          id: "bone",
          imagePath: "assets/images/dogfood.png",
          correctGroupId: "dog",
          size: 80,
        ),
        QuestionItem(
          id: "fish",
          imagePath: "assets/images/catfood.png",
          correctGroupId: "cat",
          size: 70,
        ),
        QuestionItem(
          id: "grain",
          imagePath: "assets/images/birdfood.png",
          correctGroupId: "bird",
          size: 60,
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
          MaterialPageRoute(builder: (_) => const KitchenBedroomQuestionPage()),
        );
      },
    );
  }
}
