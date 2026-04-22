import'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: onPressed,
      child:Container(
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
          Icons.play_arrow_rounded,
          size: 65,
          color: Colors.white,
        ),
      )
      );
      
  }

}