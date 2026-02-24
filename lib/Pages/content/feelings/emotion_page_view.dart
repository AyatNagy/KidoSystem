import'package:flutter/material.dart';
import 'package:kido/utils/emotion_screen.dart';

class EmotionsPageView extends StatefulWidget{
  const EmotionsPageView({super.key});

  @override
  State<EmotionsPageView> createState()=> _EmotionsPageViewState();

}

class _EmotionsPageViewState extends State<EmotionsPageView>{
  final PageController _controller = PageController();
  int currentPage=0;
  final List<EmotionScreen> emotions = [
    EmotionScreen(
            title:"Scared!",
            color:Color(0xFF4A148C),
            background:"assets/images/ghost background.png",
            character:"assets/images/scared feeling.png"
          ),
           EmotionScreen(
            title:"Happy!",
            color:Color(0xFFFFD54F),
            background:"",
            character:"assets/images/happy feeling.png",
            effect: EmotionEffect.happy,
          ),
           EmotionScreen(
            title:"Sad!",
            color:Color(0xFFADD8E6),
            background:"",
            character:"assets/images/sad feeling.png",
            effect: EmotionEffect.rain,
          ),
           EmotionScreen(
            title:"Angry!",
            color:Color(0xFFF08080),
            background:"",
            character:"assets/images/angry feeling.png",
            effect: EmotionEffect.storm,
          ),


  ];
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:PageView(
        controller:_controller,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (value){
          setState(() {
            currentPage=value;
          });
        },
        children: emotions,
          
        
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: AnimatedOpacity(
              opacity: currentPage==0?0:1,
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton(
                heroTag: "prev",
                onPressed: currentPage==0?null:(){
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                 child: const Icon(Icons.arrow_back),
                 ),
              ),
      ),
       AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: currentPage==emotions.length-1?0:1,
      child: FloatingActionButton(
        heroTag: "next",
        onPressed: currentPage == emotions.length-1
            ? null
            : () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
        child: const Icon(Icons.arrow_forward),
      ),
    ),
        ]
      )
    );
  }
    @override
    void dispose(){
      _controller.dispose();
      super.dispose();
    }
  
}