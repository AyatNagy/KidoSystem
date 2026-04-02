import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';

class DragDropWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;

  const DragDropWidget({
    super.key,
    required this.question,
    this.onAnswered,
  });

  @override
  State<DragDropWidget> createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  late Map<String, String?> targetOccupied;

  @override
  void initState() {
    super.initState();
    targetOccupied = {};
  }

  void _updateAnswers() {
    Map<String, String?> currentAnswers = {};
    targetOccupied.forEach((targetId, itemId) {
      if (itemId != null) currentAnswers[itemId] = targetId;
    });
    widget.onAnswered?.call(currentAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
        List<Widget> stackChildren = [];

        if (widget.question.backgroundImage != null) {
          stackChildren.add(
            Positioned.fill(
              child: Image.asset(widget.question.backgroundImage!, fit: BoxFit.contain),
            ),
          );
        }

        for (var target in widget.question.targets) {
          stackChildren.add(
            Positioned(
              left: containerSize.width * target.position.dx,
              top: containerSize.height * target.position.dy,
              width: containerSize.width * target.size.width,
              height: containerSize.height * target.size.height,
              child: DragTarget<String>(
                onWillAccept: (itemId) {
                  return target.acceptedItemIds.contains(itemId) &&
                      (targetOccupied[target.id] == null || targetOccupied[target.id] == itemId);
                },
                onAccept: (itemId) {
                  setState(() {
                    targetOccupied.removeWhere((k, v) => v == itemId);
                    targetOccupied[target.id] = itemId;
                    _updateAnswers();
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  bool isHovering = candidateData.isNotEmpty;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isHovering ? Colors.yellow.withOpacity(0.3) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: target.image.isNotEmpty
                        ? Opacity(
                      opacity: targetOccupied.containsValue(target.id) ? 0.0 : 0.5,
                      child: Image.asset(target.image, fit: BoxFit.contain),
                    )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ),
          );
        }

        for (var item in widget.question.items) {
          String? currentTargetId;
          targetOccupied.forEach((tId, iId) {
            if (iId == item.id) currentTargetId = tId;
          });

          double left, top, width, height;

          if (currentTargetId != null) {
            final target = widget.question.targets.firstWhere((t) => t.id == currentTargetId);
            left = containerSize.width * target.position.dx;
            top = containerSize.height * target.position.dy;
            width = containerSize.width * target.size.width;
            height = containerSize.height * target.size.height;
          } else {
            left = containerSize.width * item.startPosition.dx;
            top = containerSize.height * item.startPosition.dy;
            width = containerSize.width * item.size.width;
            height = containerSize.height * item.size.height;
          }

          stackChildren.add(
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              key: ValueKey(item.id),
              left: left,
              top: top,
              width: width,
              height: height,
              child: Draggable<String>(
                data: item.id,
                feedback: Material(
                  color: Colors.transparent,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(item.image, width: width, height: height, fit: BoxFit.contain),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.2,
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
                onDragEnd: (details) {
                  if (!details.wasAccepted) {
                    setState(() {
                      targetOccupied.removeWhere((k, v) => v == item.id);
                      _updateAnswers();
                    });
                  }
                },
                child: Image.asset(item.image, fit: BoxFit.contain),
              ),
            ),
          );
        }

        return Stack(children: stackChildren);
      },
    );
  }
}