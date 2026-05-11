import 'package:flutter/material.dart';
import 'package:kido/Models/level1/sense_model.dart';
import 'package:kido/Pages/content/level1/senses/sense_tap_practice_page.dart';
import 'package:kido/Widgets/content/level1/sense_face_view.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/enum/sense_type.dart';
import 'package:kido/services/audio_service.dart';
import '../../../../constants.dart';
import '../../../../data/content/level1/senses/sense_data.dart';

class SenseLearningScreen extends StatefulWidget {
  final SenseType type;

  const SenseLearningScreen({super.key, required this.type});

  @override
  State<SenseLearningScreen> createState() => _SenseLearningScreenState();
}

class _SenseLearningScreenState extends State<SenseLearningScreen> {
  late final SenseData data;

  bool isPlaying = false;
  bool isLoopFinished = false;

  @override
  void initState() {
    super.initState();
    data = SenseMapper.get(widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playLoop();
    });
  }

  Future<void> _playLoop() async {
    for (int i = 0; i < 5; i++) {
      if (!mounted) return;
      await _playSound();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (mounted) {
      setState(() => isLoopFinished = true);
    }
  }

  Future<void> _playSound() async {
    if (isPlaying) return;

    if (mounted) setState(() => isPlaying = true);
    await AudioService.play(fileName: data.audio);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: config.localWidth,
          height: config.localHeight,
          child: Stack(
            children: [
              GestureDetector(
                onTap: _playSound,
                child: SenseFaceView(
                  data: data,
                  width: config.localWidth,
                  height: config.localHeight,
                  faceImage: data.faceWithoutFeature,
                  isPlaying: isPlaying,
                ),
              ),
              if (isLoopFinished)
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: NextButton(
                    color: AppColors.kidoGreen,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SenseTapPracticeScreen(type: widget.type),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
