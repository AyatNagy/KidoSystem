// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Models/draganddrop_question.dart';
import 'package:simple_shadow/simple_shadow.dart';

class DragDropWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;
  final VoidCallback? onWrongDrop;
  final VoidCallback? onDragStart;

  const DragDropWidget({
    super.key,
    required this.question,
    this.onAnswered,
    this.onWrongDrop,
    this.onDragStart,
  });

  @override
  State<DragDropWidget> createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget>
    with SingleTickerProviderStateMixin {
  late Map<String, String?> targetOccupied;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    targetOccupied = {};

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
              child: Image.asset(
                widget.question.backgroundImage!,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        for (var target in widget.question.targets) {
          double extraSizeMultiplier = 2.0;
          double targetWidth = containerSize.width * target.size.width;
          double targetHeight = containerSize.height * target.size.height;

          stackChildren.add(
            Positioned(
              left:
                  (containerSize.width * target.position.dx) -
                  (targetWidth * (extraSizeMultiplier - 1) / 2),
              top:
                  (containerSize.height * target.position.dy) -
                  (targetHeight * (extraSizeMultiplier - 1) / 2),
              width: targetWidth * extraSizeMultiplier,
              height: targetHeight * extraSizeMultiplier,
              child: DragTarget<String>(
                onWillAcceptWithDetails: (details) {
                  final isCorrect = target.acceptedItemIds.contains(
                    details.data,
                  );
                  if (!isCorrect) {
                    widget.onWrongDrop?.call();
                  }
                  return isCorrect;
                },
                onAcceptWithDetails: (details) {
                  final itemId = details.data;
                  HapticFeedback.mediumImpact();
                  setState(() {
                    targetOccupied.removeWhere((k, v) => v == itemId);
                    targetOccupied[target.id] = itemId;
                    _updateAnswers();
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  bool isHoveringCorrect = candidateData.isNotEmpty;
                  bool isHoveringWrong = rejectedData.isNotEmpty;
                  bool isOccupied = targetOccupied[target.id] != null;

                  return Center(
                    child: SizedBox(
                      width: targetWidth,
                      height: targetHeight,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isOccupied ? 0.0 : 1.0,
                        child: SimpleShadow(
                          color:
                              isHoveringCorrect
                                  ? Colors.greenAccent
                                  : (isHoveringWrong
                                      ? Colors.redAccent
                                      : Colors.black),
                          sigma:
                              (isHoveringCorrect || isHoveringWrong) ? 10 : 2,
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              target.image,
                              color:
                                  isHoveringWrong
                                      ? Colors.red.withOpacity(0.5)
                                      : Colors.black,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        for (int i = 0; i < widget.question.items.length; i++) {
          final item = widget.question.items[i];
          String? currentTargetId;
          targetOccupied.forEach((tId, iId) {
            if (iId == item.id) currentTargetId = tId;
          });

          double left, top, width, height;

          if (currentTargetId != null) {
            final target = widget.question.targets.firstWhere(
              (t) => t.id == currentTargetId,
            );
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
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              key: ValueKey('${item.id}_${item.image}_index$i'),
              left: left,
              top: top,
              width: width,
              height: height,
              child: Draggable<String>(
                data: item.id,
                onDragStarted: () {
                  _pulseController.repeat(reverse: true);
                  widget.onDragStart?.call();
                },
                feedback: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return SimpleShadow(
                      opacity: 0.5,
                      offset: const Offset(15, 15),
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Image.asset(
                          item.image,
                          width: width,
                          height: height,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                childWhenDragging: Opacity(
                  opacity: 0.2,
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
                onDragEnd: (details) {
                  _pulseController.reset();
                  if (!details.wasAccepted) {
                    widget.onWrongDrop?.call();
                    HapticFeedback.lightImpact();
                    setState(() {
                      targetOccupied.removeWhere((k, v) => v == item.id);
                      _updateAnswers();
                    });
                  }
                },
                child: SimpleShadow(
                  opacity: 0.3,
                  offset: const Offset(2, 2),
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
              ),
            ),
          );
        }

        return Stack(children: stackChildren);
      },
    );
  }
}