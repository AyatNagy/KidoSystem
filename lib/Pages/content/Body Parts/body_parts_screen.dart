import 'package:flutter/material.dart';
import 'package:kido/Models/body_parts_model.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/data/body_parts.dart';
import 'package:kido/utils/stars_progress.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class BodyPartsScreen extends StatefulWidget {
  final int index;
  const BodyPartsScreen({super.key, required this.index});

  @override
  State<BodyPartsScreen> createState() => _BodyPartsScreenState();
}

class _BodyPartsScreenState extends State<BodyPartsScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _lottieController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int repeatCount = 0;
  int maxrepeats = 5;
  bool showCelebration = false;
  BodyPart get part => bodyParts[widget.index];

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(part.video);
    _lottieController = AnimationController(vsync: this);

    _controller.initialize().then((_) {
      _controller.setVolume(0);
      _controller.setLooping(false);

      setState(() {});
      Future.delayed(const Duration(milliseconds: 300), () {
        _audioPlayer.play(AssetSource(part.audio));
        _controller.play();
      });
      _controller.addListener(videoListener);
    });
  }

  void videoListener() {
    if (!mounted) return;
    if (_controller.value.position >= _controller.value.duration &&
        !_controller.value.isPlaying) {
      setState(() {
        repeatCount++;
      });

      if (repeatCount < maxrepeats) {
        _audioPlayer.play(AssetSource(part.audio));
        _controller.seekTo(Duration.zero);
        _controller.play();
      } else {
        setState(() => showCelebration = true);
        _lottieController.forward();
        // hide after animation complete
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => showCelebration = false);
        });
      }
    }
  }

  void goNext() {
    if (widget.index < bodyParts.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BodyPartsScreen(index: widget.index + 1),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                part.name,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _controller.value.isInitialized
                  ? Center(
                    child: ClipRect(
                      child: SizedBox(
                        width: 300,
                        height: 450,
                        child: OverflowBox(
                          maxWidth: double.infinity,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ),
                  )
                  : const Center(child: CircularProgressIndicator()),

              StarProgressWidget(
                filledStars: repeatCount,
                totalStars: maxrepeats,
              ),

              const SizedBox(height: 40),

              if (repeatCount >= maxrepeats)
                AnimatedOpacity(
                  opacity: repeatCount >= maxrepeats ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: NextButton(
                    onPressed: repeatCount >= maxrepeats ? goNext : () {},
                    color: Colors.blueAccent,
                  ),
                ),
            ],
          ),

          if (showCelebration)
            IgnorePointer(
              child: Lottie.asset(
                'assets/lottie/CONFETTI.json',
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController
                    ..duration = composition.duration
                    ..forward();
                },
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.removeListener(videoListener);
    _controller.dispose();
    _lottieController.dispose();
    super.dispose();
  }
}
