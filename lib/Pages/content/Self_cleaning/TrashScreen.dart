// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:confetti/confetti.dart';
import 'package:kido/Models/exams/draganddrop_question.dart';

class TrashGameWidget extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(Map<String, String?> answers)? onAnswered;

  const TrashGameWidget({super.key, required this.question, this.onAnswered});

  @override
  State<TrashGameWidget> createState() => _TrashGameWidgetState();
}

class _TrashGameWidgetState extends State<TrashGameWidget>
    with SingleTickerProviderStateMixin {
  late Map<String, String?> targetOccupied;
  late List<String>
  remainingItemIds; // قائمة لمتابعة العناصر اللي لسه على الأرض
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    targetOccupied = {};
    // في البداية، كل العناصر موجودة على الأرض
    remainingItemIds = widget.question.items.map((e) => e.id).toList();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onItemDropped(String itemId, String targetId) {
    HapticFeedback.heavyImpact();

    setState(() {
      // 1. إضافة العنصر للأهداف المكتملة
      targetOccupied[targetId] = itemId;
      // 2. إزالة العنصر من قائمة العناصر المتبقية (هذا ما سيخفيه تماماً)
      remainingItemIds.remove(itemId);
    });

    _audioPlayer.play(AssetSource('audio/yaay.mp3'));

    if (widget.onAnswered != null) {
      widget.onAnswered!(targetOccupied);
    }

    // الاحتفال لما العناصر تخلص خالص من الأرض
    if (remainingItemIds.isEmpty) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          children: [
            // 1. الخلفية
            Positioned.fill(
              child: Image.asset(
                widget.question.backgroundImage ??
                    'assets/images/clean/Trash/TrashBackground.png',
                fit: BoxFit.cover,
              ),
            ),

            // 2. السلة (تكبير الحجم 1.8 مرة)
            for (var target in widget.question.targets)
              Positioned(
                left: containerSize.width * target.position.dx,
                top: containerSize.height * target.position.dy,
                width:
                    containerSize.width *
                    target.size.width *
                    1.8, // زيادة الحجم
                height: containerSize.height * target.size.height * 1.8,
                child: DragTarget<String>(
                  onWillAcceptWithDetails:
                      (details) =>
                          target.acceptedItemIds.contains(details.data),
                  onAcceptWithDetails:
                      (details) => _onItemDropped(details.data, target.id),
                  builder: (context, candidateData, rejectedData) {
                    bool isHovering = candidateData.isNotEmpty;
                    return SimpleShadow(
                      color:
                          isHovering ? Colors.greenAccent : Colors.transparent,
                      sigma: isHovering ? 10 : 0,
                      child: Image.asset(
                        isHovering
                            ? 'assets/images/clean/Trash/openBaskett.png'
                            : target.image,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),

            // 3. قطع القمامة (تظهر فقط إذا كانت في قائمة المتبقي)
            for (var item in widget.question.items)
              if (remainingItemIds.contains(item.id)) // الشرط الصارم للإخفاء
                Positioned(
                  left: containerSize.width * item.startPosition.dx,
                  top: containerSize.height * item.startPosition.dy,
                  width: containerSize.width * item.size.width,
                  height: containerSize.height * item.size.height,
                  child: Draggable<String>(
                    data: item.id,
                    // شكل القطعة وهي بتتسحب (feedback)
                    feedback: Material(
                      color: Colors.transparent,
                      child: Image.asset(
                        item.image,
                        width: containerSize.width * item.size.width * 1.2,
                        height: containerSize.height * item.size.height * 1.2,
                      ),
                    ),
                    // شكل مكانها على الأرض وهي بتتسحب (شفاف)
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: Image.asset(item.image, fit: BoxFit.contain),
                    ),
                    // شكلها العادي على الأرض
                    child: SimpleShadow(
                      child: Image.asset(item.image, fit: BoxFit.contain),
                    ),
                  ),
                ),

            // 4. الاحتفال
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 20,
                gravity: 0.1,
              ),
            ),
          ],
        );
      },
    );
  }
}
