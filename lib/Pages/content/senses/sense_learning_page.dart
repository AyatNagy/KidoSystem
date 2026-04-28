import 'package:flutter/material.dart';
import 'package:kido/Models/sense_data.dart';
import 'package:kido/Pages/content/senses/sense_tap_practice_page.dart';
import 'package:kido/Widgets/content/level1/sense_face_view.dart';
import 'package:kido/Widgets/next_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/sense_mapper.dart';
import 'package:kido/enum/sense_type.dart';
import 'package:kido/services/audio_service.dart';

class SenseLearningScreen extends StatefulWidget {
  final SenseType type;

  const SenseLearningScreen({super.key, required this.type});

  @override
  State<SenseLearningScreen> createState() => _SenseLearningScreenState();
}

class _SenseLearningScreenState extends State<SenseLearningScreen> {
  late final SenseData data;

  bool isStarted = false;
  bool isPlaying = false;
  bool isLoopFinished = false;

  @override
  void initState() {
    super.initState();
    data = SenseMapper.get(widget.type);
  }

  void _startLesson() {
    setState(() => isStarted = true);
    _playLoop();
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

    setState(() => isPlaying = true);

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
                onTap: isStarted ? _playSound : null,
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
                    color: Colors.green,
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

              if (!isStarted)
                GestureDetector(
                  onTap: _startLesson,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.play_circle_fill,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
