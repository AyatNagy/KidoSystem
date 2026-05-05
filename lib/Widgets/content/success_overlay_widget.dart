import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessOverlay extends StatelessWidget {
  final String image;
  final String title;
  final Matrix4? transform;
  final Color textColor;

  const SuccessOverlay({
    super.key,
    required this.image,
    required this.title,
    this.transform,
    this.textColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الأنيميشن الخلفي
        Positioned.fill(
          child: Lottie.asset('assets/lottie/CONFETTI.json', fit: BoxFit.cover),
        ),
        // المحتوى المركزي
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Container(
                    transform: transform ?? Matrix4.identity(),
                    transformAlignment: Alignment.center,
                    child: child,
                  );
                },
                child: Image.asset(image, height: 250),
              ),
              const SizedBox(height: 50),
              Text(
                title,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
