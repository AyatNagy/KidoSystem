import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../../Widgets/content/drawing_page.dart';
import '../../../constants.dart';
class RocketLesson extends StatefulWidget {
  const RocketLesson({super.key});

  @override
  State<RocketLesson> createState() => _RocketLessonState();
}

class _RocketLessonState extends State<RocketLesson> with SingleTickerProviderStateMixin {
  late AnimationController _rocketController;
  late Animation<Offset> _rocketAnimation;
  bool _isLaunched = false;

  @override
  void initState() {
    super.initState();
    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rocketAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(5, -5),
    ).animate(CurvedAnimation(parent: _rocketController, curve: Curves.easeInQuint));
  }

  void _onLessonComplete() {
    setState(() => _isLaunched = true);
    _rocketController.forward();
  }

  @override
  void dispose() {
    _rocketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D2A),
      body: Stack(
        children: [
          ...List.generate(10, (i) => Positioned(
            top: config.localHeight * (0.1 * i),
            left: config.localWidth * ((i * 7) % 10 / 10),
            child: const Icon(Icons.star, color: Colors.white24, size: 10),
          )),

          Positioned(
            top: config.localHeight * 0.1,
            width: config.localWidth,
            child: Center(
              child: Text(
                "READY FOR TAKEOFF?",
                style: TextStyle(
                  fontSize: config.headline,
                  fontWeight: FontWeight.w900,
                  color: AppColors.kidoYellow,
                  shadows: [Shadow(color: AppColors.kidoOrange, blurRadius: 10)],
                ),
              ),
            ),
          ),
          Center(
            child: CustomPaint(
              size: Size(config.localWidth * 0.6, config.localHeight * 0.4),
              painter: SlantedDashPainter(),
            ),
          ),
          Drawing(
            guidePoints: const [
              Offset(0.2, 0.8),
              Offset(0.5, 0.5),
              Offset(0.8, 0.2),
            ],
          ),
          Positioned(
            bottom: config.localHeight * 0.15,
            left: config.localWidth * 0.15,
            child: SlideTransition(
              position: _rocketAnimation,
              child: Transform.rotate(
                angle: -0.8,
                child: Image.asset(
                  'assets/images/rocket.png',
                  width: 80,
                ),
              ),
            ),
          ),
          if (!_isLaunched) Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white24,
              onPressed: _onLessonComplete,
              child: const Icon(
                  Icons.play_arrow,
                color: AppColors.kidoYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlantedDashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}