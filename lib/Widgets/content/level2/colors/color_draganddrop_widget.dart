// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ColorDragDropWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;
  final VoidCallback? onWrongDrop;
  final VoidCallback? onDragStart;
  final bool
  highlightCorrect; // حالة الهينت (المساعدة) الخارجة من الشاشة الرئيسية

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
  final List<String> _fadedWrongItems =
      []; // قائمة لتخزين العناصر الخاطئة التي تم سحبها لتفعيل الفيدباك

  @override
  void initState() {
    super.initState();
    targetOccupied = {};

    // إعداد أنميشن النبض (يكبر ويصغر) متوافق تماماً مع حركة السحب
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.highlightCorrect) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ColorDragDropWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // مراقبة حالة الهينت: لو اشتغل برة، نشغل الأنميشن جوة فوراً على العنصر الصح
    if (widget.highlightCorrect != oldWidget.highlightCorrect) {
      if (widget.highlightCorrect) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.reset();
      }
    }
    // تصفية البيانات عند الانتقال لسؤال جديد
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

        // 1. صورة الخلفية إن وجدت
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

        // 2. بناء التارجت (البوكس أو الجردل)
        for (var target in widget.question.targets) {
          double extraSizeMultiplier = 1.8;
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
                    // فيدباك اهتزاز قوي فوري للموبايل عند محاولة تقريب عنصر خاطئ
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
                    child: SizedBox(
                      width: targetWidth,
                      height: targetHeight,
                      // التعديل الأول: التارجت يظهر بلونه الأصلي تماماً (بدون Opacity 0.3 وبدون ضل أسود)
                      child: SimpleShadow(
                        color:
                            isHoveringCorrect
                                ? Colors.greenAccent
                                : (isHoveringWrong
                                    ? Colors.redAccent
                                    : Colors.transparent),
                        sigma: (isHoveringCorrect || isHoveringWrong) ? 12 : 0,
                        child: Image.asset(
                          target.image,
                          // التعديل الثاني: لو بيحوم بغلط يحصل فيدباك فلاش أحمر على البوكس
                          color:
                              isHoveringWrong
                                  ? Colors.red.withOpacity(0.4)
                                  : null,
                          colorBlendMode:
                              isHoveringWrong ? BlendMode.colorBurn : null,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        // 3. بناء العناصر المراد سحبها
        for (int i = 0; i < widget.question.items.length; i++) {
          final item = widget.question.items[i];
          final isCorrectItem = item.id.startsWith('correct_');

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

          bool isFaded = _fadedWrongItems.contains(item.id);
          Widget itemImage = Image.asset(item.image, fit: BoxFit.contain);

          // ويدجت السحب الأساسية
          Widget draggableChild = Draggable<String>(
            data: item.id,
            maxSimultaneousDrags:
                isFaded ? 0 : 1, // منع سحب العناصر الخاطئة المبهتة مرة أخرى
            onDragStarted: () {
              _pulseController.repeat(reverse: true);
              widget.onDragStart?.call();
            },
            feedback: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return SimpleShadow(
                  opacity: 0.5,
                  offset: const Offset(12, 12),
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: itemImage,
                    ),
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
                  // التعديل الثالث: فيدباك تبهيت فورى عند إفلات العنصر الخاطئ
                  if (!isCorrectItem && !_fadedWrongItems.contains(item.id)) {
                    _fadedWrongItems.add(item.id);
                  }
                  targetOccupied.removeWhere((k, v) => v == item.id);
                  _updateAnswers();
                });
              }
            },
            child: SimpleShadow(
              opacity: isFaded ? 0.1 : 0.3,
              offset: const Offset(2, 2),
              child: itemImage,
            ),
          );

          // التعديل الرابع: وقت الهينت، العنصر الصحيح نفسه يكبر ويصغر كأنه مسحوب
          stackChildren.add(
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              key: ValueKey('${item.id}_${item.image}_index$i'),
              left: left,
              top: top,
              width: width,
              height: height,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity:
                    isFaded ? 0.30 : 1.0, // تطبيق الفيدباك الشفاف للعنصر الخاطئ
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
