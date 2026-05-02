import'package:flutter/material.dart';
import 'package:kido/Widgets/Animation/angry_effect.dart';

class AngryCharacter extends StatelessWidget {
  const AngryCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return AngryEffect(
      boy: Image.asset('assets/images/angry_character.png', width: 500),
      leftEyebrow: Image.asset('assets/images/left_eyebrow_overlay.png', width: 60),
      rightEyebrow: Image.asset('assets/images/right_eyebrow_overlay.png', width: 60),
    );
  }
}