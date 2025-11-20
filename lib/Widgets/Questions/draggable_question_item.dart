import 'package:flutter/material.dart';
import '../../Models/Question/question_item.dart';

class DraggableQuestionItem extends StatelessWidget {
  final QuestionItem item;

  const DraggableQuestionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Draggable<QuestionItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        elevation: 8,
        child: Image.asset(
          item.imagePath,
          width: item.size,
          height: item.size,
          fit: BoxFit.contain,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Image.asset(
          item.imagePath,
          width: item.size,
          height: item.size,
          fit: BoxFit.contain,
        ),
      ),
      child: Image.asset(
        item.imagePath,
        width: item.size,
        height: item.size,
        fit: BoxFit.contain,
      ),
    );
  }
}
