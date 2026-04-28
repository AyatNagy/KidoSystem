import'package:flutter/material.dart';
class PlayButton extends StatelessWidget{
  final Color color;
  final VoidCallback onTap;
  const PlayButton({
    super.key,
    required this.color,
    required this.onTap,
    });
    @override
    Widget build(BuildContext context){
      return GestureDetector(
        onTap:onTap,
        child:Container(
          width:120,
          height:120,
          decoration:BoxDecoration(
            color:color,
            shape:BoxShape.circle,
            boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              offset: const Offset(0, 8),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha:0.4),
              offset: const Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
          gradient:LinearGradient(
            begin:Alignment.topLeft,
            end:Alignment.bottomRight,
            colors:[color.withValues(alpha:0.8),color],
          ),
          ),
          child:const Icon(
            Icons.play_arrow_rounded,
            size:80,
            color:Colors.white,
          )
        )
      );
    }

}