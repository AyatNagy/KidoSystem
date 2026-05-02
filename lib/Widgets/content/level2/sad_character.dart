import 'package:flutter/material.dart';
import 'package:kido/Widgets/Animation/sad_effect.dart';

 // Import your effect

class SadCharacter extends StatefulWidget {
  const SadCharacter({super.key});

  @override
  State<SadCharacter> createState() => _SadCharacterState();
}

class _SadCharacterState extends State<SadCharacter> {
  @override

  void initState(){
    super.initState();
    
  }
  @override
  void dispose(){
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // The Boy
        Image.asset('assets/images/sad_character.png', width: 500),

        //left tear
        Positioned(
          top: 190,  
          left: 140, 
          child:SadEffect(
            child: Image.asset(
              'assets/images/left_tear_overlay.png', 
              width: 100,
            ),
          ),
        ),
        
        //right tear
        Positioned(
          top: 190,  
          right: 140,
          child: SadEffect(
            child: Image.asset(
              'assets/images/right_tear_overlay.png', 
              width: 100,
            ),
          ),
        ),
      ],
    );
  }
}