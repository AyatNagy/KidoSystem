

import 'package:flutter/material.dart';
import 'package:kido/Widgets/kido_action_button.dart';

class ReplayButton extends StatelessWidget{
  final Color color;
  final VoidCallback onPressed;

  const ReplayButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context){
    return KidoActionButton(
      heroTag: 'replay_button',
       icon: Icons.refresh_rounded,
       color: Colors.orangeAccent,
        onPressed: onPressed);
  }

}