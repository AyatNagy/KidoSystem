// ignore_for_file: deprecated_member_use
import'package:flutter/material.dart';

class SoundButton extends StatelessWidget{

  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;

  const SoundButton({
    super.key,
    required this.color,
    required this.onPressed,
    this.shadowColor= Colors.amber,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [(
            BoxShadow(
              color:shadowColor.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 0)
            )

          )
          ]
        ),

        child: const Icon(
          Icons.volume_up_rounded,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }

}