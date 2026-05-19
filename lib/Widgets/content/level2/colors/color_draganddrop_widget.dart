// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:kido/services/audio_service.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ColorDragDropWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;
  final VoidCallback? onWrongDrop;
  final VoidCallback? onDragStart;
  final bool highlightCorrect;

  const ColorDragDropWidget({
    super.key,
    required this.question,
    this.onAnswered,
    this.onWrongDrop,
    this.onDragStart,
    required this.highlightCorrect,
  });

  @override
  State<ColorDragDropWidget> createState() => _ColorDragDropWidgetState();
}

class _ColorDragDropWidgetState extends State<ColorDragDropWidget>
    with SingleTickerProviderStateMixin {
  late Map<String, String?> targetOccupied;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _fadedWrongItems = [];

  @override
  void initState() {
    super.initState();

    targetOccupied = {};

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.22).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.highlightCorrect) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ColorDragDropWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.highlightCorrect != oldWidget.highlightCorrect) {
      if (widget.highlightCorrect) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.reset();
      }
    }

    if (widget.question != oldWidget.question) {
      _fadedWrongItems.clear();
      targetOccupied.clear();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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

        // targets
        for (var target in widget.question.targets) {
          double targetWidth = containerSize.width * target.size.width;

          double targetHeight = containerSize.height * target.size.height;

          stackChildren.add(
            Positioned(
              left: containerSize.width * target.position.dx,
              top: containerSize.height * target.position.dy,
              width: targetWidth,
              height: targetHeight,
              child: DragTarget<String>(
                onWillAcceptWithDetails: (details) {
                  final isCorrect = target.acceptedItemIds.contains(
                    details.data,
                  );

                  if (!isCorrect) {
                    AudioService.playEffect(fileName: "colors/wrong_buzz.mp3");

                    HapticFeedback.heavyImpact();
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

                  return Center(
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isHoveringCorrect ? 1.08 : 1.0,
                      child: SizedBox(
                        width: targetWidth,
                        height: targetHeight,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            boxShadow: [
                              if (isHoveringCorrect)
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.35),
                                  blurRadius: 25,
                                  spreadRadius: 4,
                                ),

                              if (isHoveringWrong)
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.30),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                ),
                            ],
                          ),
                          child: Image.asset(target.image, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        // items
        for (int i = 0; i < widget.question.items.length; i++) {
          final item = widget.question.items[i];

          final isCorrectItem = item.id.startsWith('correct_');

          String? currentTargetId;

          targetOccupied.forEach((tId, iId) {
            if (iId == item.id) {
              currentTargetId = tId;
            }
          });

          double left;
          double top;
          double width;
          double height;

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

          bool isFaded = _fadedWrongItems.contains(item.id);

          Widget itemImage = Image.asset(item.image, fit: BoxFit.contain);

          Widget draggableChild = Draggable<String>(
            data: item.id,

            maxSimultaneousDrags: isFaded ? 0 : 1,

            onDragStarted: () {
              _pulseController.repeat(reverse: true);

              widget.onDragStart?.call();
            },

            feedback: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: itemImage,
                  ),
                );
              },
            ),

            childWhenDragging: Opacity(opacity: 0.2, child: itemImage),

            onDragEnd: (details) {
              _pulseController.reset();

              if (!details.wasAccepted) {
                widget.onWrongDrop?.call();

                HapticFeedback.lightImpact();

                setState(() {
                  if (!isCorrectItem && !_fadedWrongItems.contains(item.id)) {
                    _fadedWrongItems.add(item.id);
                  }

                  targetOccupied.removeWhere((k, v) => v == item.id);

                  _updateAnswers();
                });
              }
            },

            child: SimpleShadow(
              opacity: isFaded ? 0.08 : 0.22,
              offset: const Offset(2, 2),
              child: itemImage,
            ),
          );

          stackChildren.add(
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              key: ValueKey('${item.id}_${item.image}_$i'),
              left: left,
              top: top,
              width: width,
              height: height,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isFaded ? 0.35 : 1.0,
                child:
                    (widget.highlightCorrect && isCorrectItem)
                        ? AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: child,
                            );
                          },
                          child: draggableChild,
                        )
                        : draggableChild,
              ),
            ),
          );
        }

        return Stack(children: stackChildren);
      },
    );
  }
}
