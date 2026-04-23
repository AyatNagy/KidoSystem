import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessCelebration extends StatelessWidget {
  final Widget child;
  final String lottiePath = 'assets/lottie/CONFETTI.json';

  const SuccessCelebration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Lottie.asset(lottiePath, repeat: true, fit: BoxFit.contain),
        ),

        child,
      ],
    );
  }
}
