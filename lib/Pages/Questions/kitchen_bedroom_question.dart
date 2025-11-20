import 'package:flutter/material.dart';
import '../../Models/Question/question.dart';
import '../../Models/Question/question_group.dart';
import '../../Models/Question/question_item.dart';
import '../Questions/base_drag_drop_question_page.dart';

class KitchenBedroomQuestionPage extends StatelessWidget {
  const KitchenBedroomQuestionPage({super.key});

  static Question _createQuestion() {
    return Question(
      id: "kitchen_bedroom_001",
      title: "Which belongs to Kitchen or Bedroom?",
      groups: const [
        QuestionGroup(
          id: "kitchen",
          title: "KITCHEN",
          color: Colors.green,
          imagePath: "assets/images/kitchen.png",
          width: 150,
          height: 200,
        ),
        QuestionGroup(
          id: "bedroom",
          title: "BEDROOM",
          color: Colors.purple,
          imagePath: "assets/images/room.png",
          width: 150,
          height: 200,
        ),
      ],
      items: const [
        QuestionItem(
          id: "fork",
          imagePath: "assets/images/fork.png",
          correctGroupId: "kitchen",
          size: 80,
        ),
        QuestionItem(
          id: "pot",
          imagePath: "assets/images/pot.png",
          correctGroupId: "kitchen",
          size: 80,
        ),
        QuestionItem(
          id: "bed",
          imagePath: "assets/images/bed.png",
          correctGroupId: "bedroom",
          size: 100,
        ),
        QuestionItem(
          id: "pillow",
          imagePath: "assets/images/pillow.png",
          correctGroupId: "bedroom",
          size: 80,
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
      },
    );
  }
}
