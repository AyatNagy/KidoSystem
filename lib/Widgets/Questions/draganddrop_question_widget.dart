import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';

class DragDropQuestionWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;
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
  // التعديل: القيمة أصبحت List لاستيعاب أكثر من عنصر في السلة
  late Map<String, List<String>> targetOccupied;
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
    targetOccupied.forEach((targetId, itemIds) {
      for (var itemId in itemIds) {
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

        // 1. رسم الخلفية (إذا وجدت)
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

        // 2. رسم الأهداف (مثل السلال أو الحيوانات)
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

        // 3. رسم العناصر التي تم إسقاطها داخل الأهداف (التفاح داخل السلة)
        targetOccupied.forEach((targetId, itemIds) {
          if (itemIds.isEmpty) return;

          final target = widget.question.targets.firstWhere(
            (t) => t.id == targetId,
          );

          for (int i = 0; i < itemIds.length; i++) {
            final itemId = itemIds[i];
            final item = widget.question.items.firstWhere(
              (it) => it.id == itemId,
            );
            final double scale = isPuzzle ? 1.0 : 0.5;

            // إضافة إزاحة بسيطة (Offset) لكي لا يتراكم التفاح فوق بعضه تماماً
            double xOffset = i * 8.0;
            double yOffset = i * 4.0;

            stackChildren.add(
              Positioned(
                left:
                    (containerSize.width * target.position.dx) +
                    (containerSize.width * target.size.width * (1 - scale)) /
                        2 +
                    xOffset,
                top:
                    (containerSize.height * target.position.dy) +
                    (containerSize.height * target.size.height * (1 - scale)) /
                        2 +
                    yOffset,
                width: containerSize.width * target.size.width * scale,
                height: containerSize.height * target.size.height * scale,
                child: Draggable<String>(
                  data: item.id,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Image.asset(
                      item.image,
                      width: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Image.asset(item.image, fit: BoxFit.contain),
                  onDragEnd: (details) {
                    if (!details.wasAccepted) {
                      setState(() {
                        targetOccupied[targetId]!.remove(itemId);
                        _updateAnswers();
                      });
                    }
                  },
                ),
              ),
            );
          }
        });

        // 4. رسم العناصر المتاحة للسحب (التي لا تزال على الرف)
        for (var item in widget.question.items) {
          bool isPlaced = false;
          targetOccupied.values.forEach((list) {
            if (list.contains(item.id)) isPlaced = true;
          });
          if (isPlaced) continue;

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
                    fit: BoxFit.contain,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
                child: Image.asset(item.image, fit: BoxFit.contain),
              ),
            ),
          );
        }

        // 5. منطق استقبال السحب (Drag Targets) الشفاف
        for (var target in widget.question.targets) {
          stackChildren.add(
            Positioned(
              left: containerSize.width * target.position.dx,
              top: containerSize.height * target.position.dy,
              width: containerSize.width * target.size.width,
              height: containerSize.height * target.size.height,
              child: DragTarget<String>(
                onWillAcceptWithDetails: (details) {
                  if (widget.isExamMode) return true;
                  return target.acceptedItemIds.contains(details.data);
                },
                onAcceptWithDetails: (details) {
                  setState(() {
                    final itemId = details.data;
                    targetOccupied.putIfAbsent(target.id, () => []);

                    if (widget.isExamMode) {
                      targetOccupied[target.id] = [itemId];
                    } else {
                      if (!targetOccupied[target.id]!.contains(itemId)) {
                        targetOccupied[target.id]!.add(itemId);
                      }
                    }
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
