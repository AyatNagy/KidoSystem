// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../Widgets/content/drawing_page.dart';

class AnimationDrawplusPage extends StatefulWidget {
  const AnimationDrawplusPage({super.key});

  @override
  State<AnimationDrawplusPage> createState() => _AnimationDrawplusPageState();
}

class _AnimationDrawplusPageState extends State<AnimationDrawplusPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/+draw.mp4')
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
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
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
                    child:
                        _controller.value.isInitialized
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
            child: Drawing(
              guidePoints: [
                Offset(0.3, 0.37),
                Offset(0.5, 0.37),
                Offset(0.7, 0.37),
                Offset(0.9, 0.37),
                Offset(0.11, 0.37),

                Offset(0.5, 0.25),
                Offset(0.5, 0.3),
                Offset(0.5, 0.45),
                Offset(0.5, 0.55),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
