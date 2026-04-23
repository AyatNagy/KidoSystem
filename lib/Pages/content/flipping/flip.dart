// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:video_player/video_player.dart';

class FlipBookLesson extends StatefulWidget {
  final int level;

  const FlipBookLesson({super.key, required this.level});

  @override
  State<FlipBookLesson> createState() => _FlipBookLessonState();
}

class _FlipBookLessonState extends State<FlipBookLesson> {
  VideoPlayerController? _controller;
  int _currentPage = 0;
  bool _lessonCompleted = false;

  final List<Map<String, dynamic>> _pages = [
    {'content': 'assets/images/duck.png', 'bg': const Color(0xFFFFFDE7)},
    {'content': '🍏', 'bg': const Color(0xFFF1F8E9)},
    {'content': 'assets/images/cat2.png', 'bg': const Color(0xFFFFF3E0)},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.level < 3) {
      _initVideo();
    }
  }

  void _initVideo() {
    _controller = VideoPlayerController.asset('assets/audio/rabbit-flip.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller?.play();
      });

    _controller?.addListener(_videoListener);
  }

  void _videoListener() {
    if (!mounted || _controller == null) return;
    if (widget.level == 1) {
      if (_controller!.value.position >= _controller!.value.duration) {
        if (!_lessonCompleted) {
          setState(() => _lessonCompleted = true);
        }
      }
    }
  }

  void _onPageFlipped() {
    setState(() {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
        if (widget.level == 2) {
          _controller?.seekTo(Duration.zero);
          _controller?.play();
        }
      } else {
        _lessonCompleted = true;
      }
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildCircles(config),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: config.localHeight * 0.03),
                _buildHeader(config),
                const Spacer(),
                if (widget.level == 1)
                  _buildFullVideoSection(config)
                else ...[
                  if (widget.level == 2) _buildVideoSection(config),
                  if (widget.level == 2) const Spacer(),
                  _buildFlipPage(config),
                ],
                const Spacer(),
                _buildAnimatedButton(config),
                SizedBox(height: config.localHeight * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullVideoSection(config) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 10),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  Widget _buildVideoSection(config) {
    if (_controller == null || !_controller!.value.isInitialized)
      return const SizedBox();
    return Container(
      height: config.localHeight * 0.25,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: VideoPlayer(_controller!),
      ),
    );
  }

  Widget _buildFlipPage(config) {
    double height =
        widget.level == 3 ? config.localHeight * 0.6 : config.localHeight * 0.4;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) _onPageFlipped();
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) _onPageFlipped();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: Container(
          key: ValueKey<int>(_currentPage),
          width: config.localWidth * 0.85,
          height: height,
          decoration: BoxDecoration(
            color: _pages[_currentPage]['bg'],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 8),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPageContent(_pages[_currentPage]['content'], widget.level),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(String content, int level) {
    double size = level == 3 ? 130 : 90;
    if (content.contains('assets/')) {
      return Image.asset(
        content,
        height: size + 20,
        errorBuilder: (context, error, stack) {
          return Icon(Icons.broken_image, size: size, color: Colors.grey);
        },
      );
    }
    return Text(content, style: TextStyle(fontSize: size));
  }

  Widget _buildBackground() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)]),
    ),
  );

  Widget _buildCircles(config) => Stack(
    children: [
      Positioned(
        top: -50,
        right: -50,
        child: _circle(config.localWidth * 0.6, Colors.orange.withOpacity(0.1)),
      ),
      Positioned(
        bottom: -20,
        left: -20,
        child: _circle(config.localWidth * 0.4, Colors.white.withOpacity(0.3)),
      ),
    ],
  );

  Widget _circle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _buildHeader(config) {
    String title = "اتعلم مع الأرنب 🐰";
    if (widget.level == 1) title = "شاهد واستمتع! ✨";
    if (widget.level == 3) title = "تقدر تقلب الصفحة لوحدك؟ 💪";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: config.headline * 0.6,
          fontWeight: FontWeight.bold,
          color: Colors.orange[900],
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(config) => AnimatedSlide(
    offset: _lessonCompleted ? Offset.zero : const Offset(0, 2),
    duration: const Duration(milliseconds: 500),
    child: ElevatedButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.celebration, color: Colors.white),
      label: const Text(
        "خلصت يا بطل! 🌟",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
      ),
    ),
  );
}

class PageCurlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(size.width, size.height)
          ..lineTo(size.width - 40, size.height)
          ..quadraticBezierTo(
            size.width - 10,
            size.height - 10,
            size.width,
            size.height - 40,
          )
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
