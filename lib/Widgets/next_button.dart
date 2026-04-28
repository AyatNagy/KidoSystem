import'package:flutter/material.dart';
import 'package:kido/Widgets/kido_action_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';

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
    final r = ResponsiveProvider.of(context);
    return KidoActionButton(
      heroTag: 'next_button',
       icon: Icons.play_arrow_rounded,
       color:color,
       shadowColor: shadowColor,
       onPressed: onPressed,
      size: r.buttonHeight,
    );
  }

}