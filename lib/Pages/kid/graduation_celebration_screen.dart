// ignore_for_file: deprecated_member_use
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/audio_service.dart';

class GraduationCelebrationScreen extends StatefulWidget {
  final String childName;
  final int score;
  final int total;
  final int stars;

  const GraduationCelebrationScreen({
    super.key,
    required this.childName,
    required this.score,
    required this.total,
    required this.stars,
  });

  @override
  State<GraduationCelebrationScreen> createState() =>
      _GraduationCelebrationScreenState();
}

class _GraduationCelebrationScreenState extends State<GraduationCelebrationScreen> {
  late final ConfettiController _confettiTop;
  late final ConfettiController _confettiBurst;

  @override
  void initState() {
    super.initState();
    _confettiTop = ConfettiController(duration: const Duration(seconds: 18));
    _confettiBurst = ConfettiController(duration: const Duration(seconds: 14));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AudioService.play(fileName: 'graduation.mp3');
      _confettiTop.play();
      _confettiBurst.play();
    });
  }

  @override
  void dispose() {
    AudioService.stop();
    _confettiTop.dispose();
    _confettiBurst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final shortSide = media.size.shortestSide;
    final gifHeight = (shortSide * 0.42).clamp(160.0, 260.0);

    final pastelGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(AppColors.kidoPink, Colors.white, 0.62)!,
        Color.lerp(AppColors.kidoBlue, Colors.white, 0.55)!,
        Color.lerp(AppColors.kidoYellow, Colors.white, 0.5)!,
        Color.lerp(AppColors.kidoGreen, Colors.white, 0.58)!,
      ],
      stops: const [0.0, 0.35, 0.65, 1.0],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: pastelGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: media.size.height * 0.02,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: ConfettiWidget(
                    confettiController: _confettiTop,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.04,
                    numberOfParticles: 12,
                    maxBlastForce: 15,
                    minBlastForce: 6,
                    gravity: 0.12,
                    colors: AppColors.kidoColors,
                  ),
                ),
              ),
              Center(
                child: IgnorePointer(
                  child: ConfettiWidget(
                    confettiController: _confettiBurst,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 35,
                    maxBlastForce: 22,
                    minBlastForce: 10,
                    gravity: 0.09,
                    colors: AppColors.kidoColors,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Column(
                  children: [
                    Text(
                      'You did it!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: (media.size.width * 0.09).clamp(26.0, 40.0),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        shadows: const [
                          Shadow(
                            color: Colors.white24,
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Graduation day',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: (media.size.width * 0.055).clamp(18.0, 26.0),
                        fontWeight: FontWeight.w600,
                        color: AppColors.purpleMain.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Way to go, ${widget.childName}!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (media.size.width * 0.042).clamp(15.0, 20.0),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                            (index) => Icon(
                          Icons.star_rounded,
                          size: 44,
                          color: index < widget.stars
                              ? AppColors.kidoOrange
                              : Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.score} / ${widget.total} on your final exam',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (media.size.width * 0.038).clamp(14.0, 18.0),
                        color: AppColors.textDark.withOpacity(0.75),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.45),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.kidoPink.withOpacity(0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/gif/garduation.png',
                            height: gifHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomGradientButton(
                      title: "YAY! LET'S GO!",
                      onPressed: () {
                        Navigator.pop(context, 3);
                      },
                      width: double.infinity,
                      borderRadius: 30,
                      fontSize: (media.size.width * 0.05).clamp(18.0, 24.0),
                      colors: const [
                        AppColors.kidoPink,
                        AppColors.kidoOrange,
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}