import'package:flutter/material.dart';
import 'package:kido/Widgets/kido_action_button.dart';

class NextButton extends StatelessWidget{

  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;

  const NextButton({
    super.key,
    required this.color,
    required this.onPressed,
    this.shadowColor= Colors.amber,

  });

  @override
  Widget build(BuildContext context) {
    return KidoActionButton(
      heroTag: 'next_button',
       icon: Icons.play_arrow_rounded,
       color: Colors.green[700]!,
       shadowColor: shadowColor,
       onPressed: onPressed,
      size:80,
    );

      
  }

}