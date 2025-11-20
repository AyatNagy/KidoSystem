/*import 'package:flutter/material.dart';
import '../../Models/Question/question.dart';
import '../../Models/Question/question_item.dart';
import '../../Models/Question/question_group.dart';
import '../../Models/Question/question_result.dart';
import 'base_drag_drop_question_page.dart';

/// مثال آخر: سؤال Thick or Thin
/// يوضح سهولة إضافة أسئلة جديدة
class ThickThinQuestionPage extends StatelessWidget {
  const ThickThinQuestionPage({super.key});

  static Question _createQuestion() {
    return Question(
      id: "thick_thin_001",
      title: "Thick or Thin?",
      groups: const [
        QuestionGroup(
          id: "thick",
          title: "THICK",
          color: Colors.purple,
        ),
        QuestionGroup(
          id: "thin",
          title: "THIN",
          color: Colors.pink,
        ),
      ],
      items: const [
        QuestionItem(
          id: "book",
          imagePath: "assets/images/book.png",
          correctGroupId: "thick",
        ),
        QuestionItem(
          id: "paper",
          imagePath: "assets/images/paper.png",
          correctGroupId: "thin",
        ),
        QuestionItem(
          id: "tree_trunk",
          imagePath: "assets/images/tree_trunk.png",
          correctGroupId: "thick",
        ),
        QuestionItem(
          id: "leaf",
          imagePath: "assets/images/leaf.png",
          correctGroupId: "thin",
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
        print("Thick/Thin Result: ${result.toString()}");
        // إرسال للـ API
      },
    );
  }
}

*/
