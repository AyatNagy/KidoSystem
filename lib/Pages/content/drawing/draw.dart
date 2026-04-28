// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../Widgets/content/drawing_page.dart';

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/audio/draw.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0);
        _controller.play();
        Future.delayed(Duration(seconds: 1), () {
          _controller.setVolume(1.0);
          _controller.setPlaybackSpeed(0.9);
          _controller.play();
        });
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        _navigateToDrawing();
      }
    });
  }

  void _navigateToDrawing() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const Drawing(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE0F2F1), Color(0xFFB9F6CA)],
                ),
              ),
            ),
            Positioned(
              top: -config.localHeight * 0.05,
              right: -config.localWidth * 0.1,

              child: _decorativeCircle(
                config.localWidth * 0.5,
                Colors.white.withOpacity(0.4),
              ),
            ),
            Positioned(
              bottom: -config.localHeight * 0.03,
              left: -config.localWidth * 0.08,

              child: _decorativeCircle(
                config.localWidth * 0.35,
                Colors.white.withOpacity(0.3),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "شاهد واستعد للمرح!",
                    style: TextStyle(
                      fontSize: config.headline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.03),
                  Container(
                    padding: EdgeInsets.all(config.localWidth * 0.03),
                    margin: EdgeInsets.symmetric(
                      horizontal: config.localWidth * 0.08,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        config.localWidth * 0.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        config.localWidth * 0.08,
                      ),
                      child:
                          _controller.value.isInitialized
                              ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                              : SizedBox(
                                height: config.localHeight * 0.25,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              ),
                    ),
                  ),
                  if (_controller.value.isInitialized)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: config.localWidth * 0.15,
                        vertical: config.localHeight * 0.03,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: false,
                          colors: const VideoProgressColors(
                            playedColor: Colors.blueGrey,
                            bufferedColor: Colors.black12,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: config.localHeight * 0.06,
              left: config.localWidth * 0.08,
              child: SizedBox(
                height: config.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: _navigateToDrawing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightGreen[700],
                    padding: EdgeInsets.symmetric(
                      horizontal: config.localWidth * 0.08,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        config.localWidth * 0.1,
                      ),
                    ),
                    elevation: 8,
                  ),
                  icon: Icon(
                    Icons.palette_rounded,
                    size: config.buttonFont * 0.8,
                  ),
                  label: Text(
                    "يلا نرسم!",
                    style: TextStyle(
                      fontSize: config.buttonFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
