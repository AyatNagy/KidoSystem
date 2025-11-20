import 'package:flutter/material.dart';
import '../../Models/Question/question_group.dart';
import '../../Models/Question/question_item.dart';
import 'draggable_question_item.dart';
import '../ResponsiveProvider.dart';

class DropTargetBox extends StatelessWidget {
  final QuestionGroup group;
  final List<QuestionItem> items;
  final Function(QuestionItem) onItemDropped;

  const DropTargetBox({
    super.key,
    required this.group,
    required this.items,
    required this.onItemDropped,
  });

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return DragTarget<QuestionItem>(
      onWillAccept: (_) => true,
      onAccept: onItemDropped,
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;

        return Container(
          width: group.width > 0 ? group.width : config.localWidth * 0.35,
          height: group.height > 0 ? group.height : config.localHeight * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHighlighted ? Colors.green : Colors.transparent,
              width: isHighlighted ? 4 : 0,
            ),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  group.imagePath,
                  width:
                      group.width > 0 ? group.width : config.localWidth * 0.35,
                  height:
                      group.height > 0
                          ? group.height
                          : config.localHeight * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              // العناصر داخل البوكس
              Positioned.fill(
                child:
                    items.isEmpty
                        ? const SizedBox()
                        : SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children:
                                items
                                    .map(
                                      (item) =>
                                          DraggableQuestionItem(item: item),
                                    )
                                    .toList(),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
