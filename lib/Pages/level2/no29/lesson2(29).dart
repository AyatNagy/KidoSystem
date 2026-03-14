import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../Widgets/ResponsiveProvider.dart';
import '../../../Widgets/content/drawing_page.dart';

class AnimationDrawPage extends StatefulWidget {
  const AnimationDrawPage({super.key});

  @override
  State<AnimationDrawPage> createState() => _AnimationDrawPageState();
}

class _AnimationDrawPageState extends State<AnimationDrawPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/draw-line.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setPlaybackSpeed(0.5);
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: config.localWidth,
              decoration: const BoxDecoration(
                color: Color(0xFFE9ECEF),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Center(
                child: Container(
                  width: config.localWidth * 0.8,
                  height: config.localHeight * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white, width: 8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Drawing(
                guidePoints: [
                  Offset(0.1, 0.4),
                  Offset(0.2, 0.4),
                  Offset(0.3, 0.4),
                  Offset(0.4, 0.4),
                  Offset(0.5, 0.4),
                  Offset(0.6, 0.4),
                  Offset(0.7, 0.4),
                  Offset(0.8, 0.4),
                  Offset(0.9, 0.4)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}