import 'package:flutter/material.dart';

class KidoActionButton extends StatelessWidget{
   final String heroTag;
   final IconData icon;
   final double size;
   final Color color;
   final VoidCallback onPressed;
   final Color? shadowColor;


   const KidoActionButton({
    super.key,
    required this.heroTag,
    required this.icon,
    this.size=65,
    required this.color,
    required this.onPressed,
    this.shadowColor,
   });

   @override
   Widget build(BuildContext context){
          return GestureDetector(
            onTap: onPressed,
            child: Container(
              width:size,
              height: size,
              decoration: BoxDecoration(
                color:color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                  color:(shadowColor??color).withValues(alpha: 0.6),
                  blurRadius: 15,
                  spreadRadius: 5,
                  offset: const Offset(0, 0)
              ),
              
              ],
              ),
              child: Hero(
                tag: heroTag
              , child: Icon(
                icon,
                size: size*0.7,
                color: Colors.white,)
              ),
              
            ),
          );
   }


}