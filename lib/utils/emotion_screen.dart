import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum EmotionEffect {
  none,
  rain,
  storm,
  happy,
  confetti,
}

class EmotionScreen extends StatelessWidget{
  final Color color;
  final String title;
  final String background;
  final String character;
  final EmotionEffect effect;
  


  const EmotionScreen({
    super.key,
    required this.color,
    required this.title,
    required this.background,
    required this.character,
    this.effect=EmotionEffect.none});

    Widget _buildBackground() {
  switch (effect) {

    //rain
    case EmotionEffect.rain:
      return Stack(
        children:[
           // Main rain
      Positioned.fill(
        child: Lottie.asset(
          'assets/lottie/rain_drop.json',
          fit: BoxFit.fill,
          repeat: true,
        ),
      ),

      

      // Small top-left rain
      Positioned(
        top: 0,
        left: 0,
        width: 150,
        height: 200,
        child: Lottie.asset(
          'assets/lottie/rain_drop.json',
          repeat: true,
        ),
      ),

      // Small bottom-right rain
      Positioned(
        bottom: 0,
        right: 0,
        width: 150,
        height: 200,
        child: Lottie.asset(
          'assets/lottie/rain_drop.json',
          repeat: true,
        ),
      ),// 🌧 Small random rain drops
      ...List.generate(15, (index) {
        return Positioned(
          top: (index * 50) % 600, // vertical spacing
          left: (index * 70) % 350, // horizontal spacing
          child: SizedBox(
            width: 80,
            height: 120,
            child: Lottie.asset(
              'assets/lottie/rain_drop.json',
              repeat: true,
            ),
          ),
        );
      }),
        ]
      );
       
       //storm
      case EmotionEffect.storm:
      return Stack(
        children:[

      // Small bottom-right storm
      Positioned(
        bottom: 0,
        right: 0,
        width: 150,
        height: 200,
        child: Lottie.asset(
          'assets/lottie/storm.json',
          repeat: true,
        ),
      ), 
      // 🌧 Small random storm
      ...List.generate(15, (index) {
        return Positioned(
          top: (index * 50) % 600, // vertical spacing
          left: (index * 70) % 350, // horizontal spacing
          child: SizedBox(
            width: 80,
            height: 120,
            child: Lottie.asset(
              'assets/lottie/storm.json',
              repeat: true,
            ),
          ),
        );
      }),
        ]
      );

    case EmotionEffect.happy:
      return Stack(
        children:[

      // Small bottom-right storm
      Positioned(
        bottom: 0,
        right: 0,
        width: 150,
        height: 200,
        child: Lottie.asset(
          'assets/lottie/star (2).json',
          repeat: true,
        ),
      ), 
      // 🌧 Small random storm
      ...List.generate(15, (index) {
        return Positioned(
          top: (index * 50) % 600, // vertical spacing
          left: (index * 70) % 350, // horizontal spacing
          child: SizedBox(
            width: 80,
            height: 120,
            child: Lottie.asset(
              'assets/lottie/star (2).json',
              repeat: true,
            ),
          ),
        );
      }),
        ]
      );

    case EmotionEffect.confetti:
      return Lottie.asset(
        'assets/animations/confetti.json',
        fit: BoxFit.cover,
        repeat: true,
      );

    case EmotionEffect.none:
    default:
      return Image.asset(
        background,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const SizedBox(),
      );
  }
}
  
  @override
  Widget build(BuildContext context){
    final screenHeight = MediaQuery.of(context).size.height;
   return Container(
    color:color,
    child:Stack(
      alignment:Alignment.center,
      children:[
         Positioned.fill(
          child: _buildBackground(),
         ),
        Positioned(
          bottom:MediaQuery.of(context).size.height*0.2,
          child: AnimatedScale(
            scale: 1, 
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            child: Image.asset(
            character,
            height:screenHeight * 0.5,
            errorBuilder:(context,error,stackTrace)=>const Icon(Icons.person,size:100),
            ),
          )
        ),
        Positioned(
          top:100,
          child:Text(
            title,
            style:  TextStyle(
            fontFamily: 'Fredoka',
            fontSize:screenHeight * 0.07,
            fontWeight:FontWeight.bold,
            color:Colors.white,
            letterSpacing:2,
            shadows:[Shadow(blurRadius:10,color:Colors.black26,offset:Offset(2,2))],

            ),
          ),
        ),
      ]
    )
   );
  }
  }