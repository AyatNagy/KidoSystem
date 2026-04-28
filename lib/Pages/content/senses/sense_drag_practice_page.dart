import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/sense_data.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/Widgets/Questions/draganddrop_question_widget.dart';
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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    senseData = SenseMapper.get(widget.type);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _prepareDragDropData();
    _startSequence();
  }

  void _startSequence() async {
    await AudioService.play(fileName: senseData.questionAudio);
    _resetIdleTimer();
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    if (isSuccess) return;

    _idleTimer = Timer(const Duration(seconds: 3), () {
      if (!isSuccess && mounted) {
        _triggerHintAndRepeatAudio();
      }
    });
  }

  void _triggerHintAndRepeatAudio() async {
    setState(() => showHint = true);
    _pulseController.repeat(reverse: true);
    _shakeController.forward(from: 0).then((_) => _shakeController.reverse());

    await AudioService.play(fileName: senseData.questionAudio);
    _resetIdleTimer();
  }

  void _onActionStarted() {
    _idleTimer?.cancel();
    AudioService.stop();
    _pulseController.stop();
    setState(() => showHint = false);
  }

  SenseData _getWrongOptionData() {
    final allTypes = SenseType.values.toList();
    allTypes.remove(widget.type);
    allTypes.shuffle();
    return SenseMapper.get(allTypes.first);
  }

  void _prepareDragDropData() {
    final wrongSenseData = _getWrongOptionData();
    dragDropData = DragDropQuestion(
      questionText: "",
      backgroundImage: senseData.faceWithoutFeature,
      items: [
        DragItem(
          id: "correct_part",
          image: senseData.featureImage,
          startPosition: const Offset(0.2, 0.75),
          size: const Size(0.25, 0.2),
        ),
        DragItem(
          id: "wrong_part",
          image: wrongSenseData.featureImage,
          startPosition: const Offset(0.55, 0.75),
          size: const Size(0.25, 0.2),
        ),
      ],
      targets: [
        DragTargetZone(
          id: "main_target",
          acceptedItemIds: ["correct_part"],
          position: Offset(senseData.leftFactor, senseData.topFactor),
          size: Size(senseData.widthFactor, senseData.widthFactor),
          image: "",
        ),
      ],
    );
  }

  void _onAnswerUpdate(Map<String, String?> answers) async {
    if (answers.containsKey("correct_part")) {
      if (isSuccess) return;
      _onActionStarted();
      setState(() {
        isSuccess = true;
      });

      await AudioService.play(fileName: "yaay.mp3");
      await Future.delayed(const Duration(milliseconds: 1500));
      await AudioService.play(fileName: senseData.audio);
    } else {
      _resetIdleTimer();
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _pulseController.dispose();
    _shakeController.dispose();
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
      body: Center(
        child: SizedBox(
          width: w,
          height: h,
          child: Stack(
            children: [
              Listener(
                onPointerDown: (_) => _onActionStarted(),
                child: DragDropQuestionWidget(
                  question: dragDropData,
                  onAnswered: _onAnswerUpdate,
                  isExamMode: false,
                ),
              ),

              if (showHint && !isSuccess)
                Positioned(
                  left: w * correctItem.startPosition.dx,
                  top: h * correctItem.startPosition.dy,
                  width: w * correctItem.size.width,
                  height: h * correctItem.size.height,
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnimation.value, 0),
                          child: ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.6),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow.withOpacity(0.4),
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              if (isSuccess)
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lottie/CONFETTI.json',
                    fit: BoxFit.cover,
                    repeat: false,
                  ),
                ),

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
        ),
      ),
    );
  }
}
