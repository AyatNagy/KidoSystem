import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/sense_data.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/sense_mapper.dart';
import 'package:kido/enum/sense_type.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';

class SenseDragPracticeScreen extends StatefulWidget {
  final SenseType type;
  const SenseDragPracticeScreen({super.key, required this.type});

  @override
  State<SenseDragPracticeScreen> createState() =>
      _SenseDragPracticeScreenState();
}

class _SenseDragPracticeScreenState extends State<SenseDragPracticeScreen>
    with TickerProviderStateMixin {
  late final SenseData senseData;
  late final DragDropQuestion dragDropData;

  bool isSuccess = false;
  bool showHint = false;

  Timer? _idleTimer;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    senseData = SenseMapper.get(widget.type);

    // إعداد أنيميشن الوميض (Hint)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _prepareDragDropData();

    // تشغيل السؤال لأول مرة عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSystemSequence());
  }

  // --- المنطق الرئيسي للنظام ---

  void _runSystemSequence({bool triggerHint = false}) async {
    if (isSuccess || !mounted) return;

    // 1. تنظيف أي عمليات سابقة
    _stopAllActions();

    // 2. تفعيل التلميح إذا كان مطلوباً (في حالة التأخير أو الخطأ)
    if (triggerHint) {
      setState(() => showHint = true);
      _glowController.repeat(reverse: true);
    }

    // 3. تشغيل صوت السؤال
    await AudioService.play(fileName: senseData.questionAudio);

    // 4. بدء تايمر الانتظار (إذا لم يحرك الطفل شيئاً خلال 7 ثواني يعيد التنبيه)
    _startIdleTimer();
  }

  void _stopAllActions() {
    _idleTimer?.cancel();
    _glowController.reset();
    AudioService.stop();
    if (mounted) setState(() => showHint = false);
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 7), () {
      _runSystemSequence(triggerHint: true); // إعادة السؤال مع تفعيل التلميح
    });
  }

  // --- أحداث اللعبة ---

  void _onAnswerUpdate(Map<String, String?> answers) async {
    if (answers.containsKey("correct_part")) {
      if (isSuccess) return;

      _stopAllActions(); // إيقاف كل شيء عند النجاح
      setState(() => isSuccess = true);

      await AudioService.play(fileName: "yaay.mp3");
      await Future.delayed(const Duration(milliseconds: 1500));
      await AudioService.play(fileName: senseData.audio);
    }
  }

  void _onUserStartedDragging() {
    // بمجرد ما الطفل يمسك القطعة، نوقف الصوت والتايمر عشان نركز في الحركة
    _stopAllActions();
  }

  void _onUserMadeMistake() {
    // لو وضع القطعة في مكان غلط، نعيد له السؤال فوراً مع التلميح
    _runSystemSequence(triggerHint: true);
  }

  // --- بناء البيانات والواجهة ---

  void _prepareDragDropData() {
    final wrongSenseData = _getWrongOptionData();
    dragDropData = DragDropQuestion(
      questionText: "",
      backgroundImage: senseData.faceWithoutFeature,
      items: [
        DragItem(
          id: "correct_part",
          image: senseData.featureImage,
          startPosition: const Offset(0.2, 0.82),
          size: const Size(0.25, 0.2),
        ),
        DragItem(
          id: "wrong_part",
          image: wrongSenseData.featureImage,
          startPosition: const Offset(0.55, 0.82),
          size: const Size(0.25, 0.2),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "main_target",
          acceptedItemIds: ["correct_part"],
          position: Offset(senseData.leftFactor, senseData.topFactor),
          size: Size(senseData.widthFactor, senseData.widthFactor),
          image: senseData.featureImage,
        ),
      ],
    );
  }

  SenseData _getWrongOptionData() {
    final allTypes =
        SenseType.values.toList()
          ..remove(widget.type)
          ..shuffle();
    return SenseMapper.get(allTypes.first);
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _glowController.dispose();
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final w = config.localWidth;
    final h = config.localHeight;

    final correctItem = dragDropData.items.firstWhere(
      (i) => i.id == "correct_part",
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. ويدجت اللعب الأساسية
          DragDropWidget(
            question: dragDropData,
            onAnswered: _onAnswerUpdate,
            onDragStart: _onUserStartedDragging,
            onWrongDrop: _onUserMadeMistake,
          ),

          // 2. طبقة الوميض (Hint Layer)
          if (showHint && !isSuccess)
            Positioned(
              left: w * correctItem.startPosition.dx,
              top: (h * correctItem.startPosition.dy) - 50,
              width: w * correctItem.size.width,
              height: h * correctItem.size.height,
              child: IgnorePointer(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width: w * 0.18,
                        height: w * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellowAccent.withValues(
                                alpha: _glowAnimation.value * 0.7,
                              ),
                              blurRadius: 40 * _glowAnimation.value + 10,
                              spreadRadius: 20 * _glowAnimation.value,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // 3. طبقة الاحتفال عند النجاح
          if (isSuccess)
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/CONFETTI.json',
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),

          // 4. زر الرجوع
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
