import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';

class DragDropQuestionWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;

  const DragDropQuestionWidget({
    super.key,
    required this.question,
    this.onAnswered,
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
      initialPositions[item.id] = item.startPosition ?? const Offset(0.1, 0.8);
    }
  }

  void _updateAnswers() {
    widget.onAnswered?.call({
      for (var it in widget.question.items)
        it.id: targetOccupied.entries
         .firstWhere(
              (e) => e.value == it.id,
          orElse: () => const MapEntry('', null),
         ).key,
    });
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

        // 2. Targets Layer
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
          final target = widget.question.targets.firstWhere((t) => t.id == targetId);
          final item = widget.question.items.firstWhere((i) => i.id == itemId);

          final double scale = isPuzzle ? 1.0 : 0.5;

          stackChildren.add(
            Positioned(
              left: (containerSize.width * target.position.dx) +
                  (containerSize.width * target.size.width * (1 - scale)) / 2,
              top: (containerSize.height * target.position.dy) +
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
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(item.image, fit: BoxFit.contain),
                  ),
                ),
                child: Image.asset(item.image, fit: BoxFit.contain),
                onDragEnd: (details) {
                  setState(() {
                    targetOccupied.remove(targetId);
                    _updateAnswers();
                  });
                },
              ),
            ),
          );
        });

        for (var item in widget.question.items) {
          if (targetOccupied.containsValue(item.id)) continue;
          final start = initialPositions[item.id]!;
          final itemSize = Size(
            containerSize.width * item.size.width,
            containerSize.height * item.size.height,
          );

          stackChildren.add(
            Positioned(
              left: containerSize.width * start.dx,
              top: containerSize.height * start.dy,
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
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      item.image,
                      width: itemSize.width,
                      height: itemSize.height,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                child: Image.asset(
                  item.image,
                  width: itemSize.width,
                  height: itemSize.height,
                  fit: BoxFit.contain,
                ),
                onDragEnd: (details) {
                  setState(() {
                    initialPositions[item.id] =
                        item.startPosition ?? const Offset(0.1, 0.8);
                    _updateAnswers();
                  });
                },
              ),
            ),
          );
        }

        // DragTarget Overlay
        for (var target in widget.question.targets) {
          final targetPos = Offset(
            containerSize.width * target.position.dx,
            containerSize.height * target.position.dy,
          );
          final targetSize = Size(
            containerSize.width * target.size.width,
            containerSize.height * target.size.height,
          );

          stackChildren.add(
            Positioned(
              left: targetPos.dx,
              top: targetPos.dy,
              width: targetSize.width,
              height: targetSize.height,
              child: DragTarget<String>(
                onWillAccept: (itemId) => true,
                onAccept: (itemId) {
                  setState(() {
                    final oldItemId = targetOccupied[target.id];
                    if (oldItemId != null) {
                      initialPositions[oldItemId] =
                          widget.question.items
                              .firstWhere((i) => i.id == oldItemId)
                              .startPosition ??
                          const Offset(0.1, 0.8);
                    }

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
