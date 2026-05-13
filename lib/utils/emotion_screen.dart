import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum EmotionEffect { none, rain, storm, happy, confetti }

class EmotionScreen extends StatelessWidget {
  final Color color;
  final String title;
  final String background;
  final Widget characterWidget;
  final EmotionEffect effect;

  const EmotionScreen({
    super.key,
    required this.color,
    required this.title,
    required this.background,
    required this.characterWidget,
    this.effect = EmotionEffect.none,
  });

  Widget _buildBackground() {
    switch (effect) {
      //rain
      case EmotionEffect.rain:
        return Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/rain_drop.json',
                fit: BoxFit.fill,
                repeat: true,
              ),
            ),

            // Small top-left rain
            Positioned(
              top: 0,
              left: 0,
              width: 150,
              height: 200,
              child: Lottie.asset('assets/lottie/rain_drop.json', repeat: true),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              width: 150,
              height: 200,
              child: Lottie.asset('assets/lottie/rain_drop.json', repeat: true),
            ),
            ...List.generate(15, (index) {
              return Positioned(
                top: (index * 50) % 600,
                left: (index * 70) % 350,
                child: SizedBox(
                  width: 80,
                  height: 120,
                  child: Lottie.asset(
                    'assets/lottie/rain_drop.json',
                    repeat: true,
                  ),
                ),
              );
            }),
          ],
        );

      //storm
      case EmotionEffect.storm:
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              width: 150,
              height: 200,
              child: Lottie.asset('assets/lottie/storm.json', repeat: true),
            ),

            ...List.generate(15, (index) {
              return Positioned(
                top: (index * 50) % 600,
                left: (index * 70) % 350,
                child: SizedBox(
                  width: 80,
                  height: 120,
                  child: Lottie.asset('assets/lottie/storm.json', repeat: true),
                ),
              );
            }),
          ],
        );

      case EmotionEffect.happy:
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              width: 150,
              height: 200,
              child: Lottie.asset('assets/lottie/star (2).json', repeat: true),
            ),
            // Small random storm
            ...List.generate(15, (index) {
              return Positioned(
                top: (index * 50) % 600,
                left: (index * 70) % 350,
                child: SizedBox(
                  width: 80,
                  height: 120,
                  child: Lottie.asset(
                    'assets/lottie/star (2).json',
                    repeat: true,
                  ),
                ),
              );
            }),
          ],
        );

      case EmotionEffect.confetti:
        return Lottie.asset(
          'assets/animations/confetti.json',
          fit: BoxFit.cover,
          repeat: true,
        );

      case EmotionEffect.none:
        return Image.asset(
          background,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: color,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: _buildBackground()),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: AnimatedScale(
              scale: 1,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              child: SizedBox(
                height: screenHeight * 0.5,
                child: characterWidget,
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: screenHeight * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
