import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';

class DragDropQuestionWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;
  // الإضافة الجديدة هنا
  final bool isExamMode;

  const DragDropQuestionWidget({
    super.key,
    required this.question,
    this.onAnswered,
    this.isExamMode = false,
  });

  @override
  State<DragDropQuestionWidget> createState() => _DragDropQuestionWidgetState();
}

class _DragDropQuestionWidgetState extends State<DragDropQuestionWidget> {
  late Map<String, String?> targetOccupied;
  late Map<String, Offset> initialPositions;

  @override
  void initState() {
    super.initState();
    targetOccupied = {};
    initialPositions = {};

    for (var item in widget.question.items) {
      initialPositions[item.id] = item.startPosition;
    }
  }

  void _updateAnswers() {
    Map<String, String?> currentAnswers = {};
    targetOccupied.forEach((targetId, itemId) {
      if (itemId != null) {
        currentAnswers[itemId] = targetId;
      }
    });
    widget.onAnswered?.call(currentAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
        List<Widget> stackChildren = [];
        final bool isPuzzle = widget.question.backgroundImage != null;

        if (isPuzzle) {
          stackChildren.add(
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  widget.question.backgroundImage!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        }

        for (var target in widget.question.targets) {
          if (target.image.isEmpty) continue;
          stackChildren.add(
            Positioned(
              left: containerSize.width * target.position.dx,
              top: containerSize.height * target.position.dy,
              width: containerSize.width * target.size.width,
              height: containerSize.height * target.size.height,
              child: Image.asset(target.image, fit: BoxFit.contain),
            ),
          );
        }

        targetOccupied.forEach((targetId, itemId) {
          if (itemId == null) return;
          final target = widget.question.targets.firstWhere(
            (t) => t.id == targetId,
          );
          final item = widget.question.items.firstWhere((i) => i.id == itemId);
          final double scale = isPuzzle ? 1.0 : 0.5;

          stackChildren.add(
            Positioned(
              left:
                  (containerSize.width * target.position.dx) +
                  (containerSize.width * target.size.width * (1 - scale)) / 2,
              top:
                  (containerSize.height * target.position.dy) +
                  (containerSize.height * target.size.height * (1 - scale)) / 2,
              width: containerSize.width * target.size.width * scale,
              height: containerSize.height * target.size.height * scale,
              child: Draggable<String>(
                data: item.id,
                feedback: Material(
                  color: Colors.transparent,
                  child: Image.asset(
                    item.image,
                    width: containerSize.width * target.size.width * scale,
                    fit: BoxFit.contain,
                  ),
                ),
                child: Image.asset(item.image, fit: BoxFit.contain),
                onDragEnd: (details) {
                  if (!details.wasAccepted) {
                    setState(() {
                      targetOccupied.remove(targetId);
                      _updateAnswers();
                    });
                  }
                },
              ),
            ),
          );
        });

        for (var item in widget.question.items) {
          if (targetOccupied.containsValue(item.id)) continue;
          final itemSize = Size(
            containerSize.width * item.size.width,
            containerSize.height * item.size.height,
          );

          stackChildren.add(
            Positioned(
              left: containerSize.width * item.startPosition.dx,
              top: containerSize.height * item.startPosition.dy,
              width: itemSize.width,
              height: itemSize.height,
              child: Draggable<String>(
                data: item.id,
                feedback: Material(
                  color: Colors.transparent,
                  child: Image.asset(
                    item.image,
                    width: itemSize.width,
                    height: itemSize.height,
                    fit: BoxFit.contain,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    item.image,
                    width: itemSize.width,
                    fit: BoxFit.contain,
                  ),
                ),
                child: Image.asset(
                  item.image,
                  width: itemSize.width,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        }

        //  منطق الـ DragTarget
        for (var target in widget.question.targets) {
          stackChildren.add(
            Positioned(
              left: containerSize.width * target.position.dx,
              top: containerSize.height * target.position.dy,
              width: containerSize.width * target.size.width,
              height: containerSize.height * target.size.height,
              child: DragTarget<String>(
                onWillAcceptWithDetails: (details) {
                  if (widget.isExamMode) {
                    return true;
                  } else {
                    return target.acceptedItemIds.contains(details.data);
                  }
                },
                onAcceptWithDetails: (details) {
                  setState(() {
                    final itemId = details.data;
                    targetOccupied[target.id] = itemId;
                    _updateAnswers();
                  });
                },
                builder:
                    (context, candidateData, rejectedData) =>
                        const SizedBox.shrink(),
              ),
            ),
          );
        }

        return Stack(children: stackChildren);
      },
    );
  }
}
