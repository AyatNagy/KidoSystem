import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Models/level3/numbers/number_lesson_model.dart';
import 'package:kido/Widgets/next_button.dart';
import 'package:kido/Widgets/sound_button.dart';
import 'dart:async';

class NumberLessonWidget extends StatefulWidget {
  final NumberLessonData data;
  final VoidCallback onNext;
  final bool isEnglish;


  const NumberLessonWidget({
    super.key,
    required this.data,
    required this.onNext,
    required this.isEnglish,
  });

   @override
  State<NumberLessonWidget> createState() => _NumberLessonWidgetState();
}



class _NumberLessonWidgetState extends State<NumberLessonWidget> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;
  late AnimationController _idleController;
  late Animation<double> _idleOffset;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasInteracted = false;
  Timer? _idleTimer;
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _controller.reverse();
    });
    _entranceController=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      );

    _slideAnimation=Tween<Offset>(
      begin: const Offset(0, 1.5), 
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceController, curve: Curves.bounceOut)
    );
    _entranceController.forward();

    _breatheController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
)..repeat(reverse: true); 

   _breatheAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
  CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
);

   _idleController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 1), // Speed of the floating
)..repeat(reverse: true); // Back and forth

  _idleOffset = Tween<double>(begin: 0, end: -15).animate( // Moves up by 15 pixels
  CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
);
  }

  Future<void> _playLesson() async {
    setState(() => _hasInteracted = true);
    _idleController.stop();
    _idleController.reset();
    _controller.forward();
    await _audioPlayer.setSource(AssetSource(widget.data.audioPath));
    await _audioPlayer.resume();
    _startIdleTimer();
  }

  void _startIdleTimer() {
  _idleTimer?.cancel(); // Cancel any existing timer
  _idleTimer = Timer(const Duration(seconds: 2), () {
    if (mounted && !_idleController.isAnimating) {
      _idleController.repeat(reverse: true); 
    }
  });
}

  @override
  void dispose() {
    _idleTimer?.cancel();
    _controller.dispose();
    _audioPlayer.dispose();
    _entranceController.dispose();
    _breatheController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final Color buttonColor=widget.isEnglish?widget.data.primaryColor:const Color.fromARGB(255, 2, 56, 122);
    return Scaffold(
      backgroundColor:Colors.blue[100],
      body:SafeArea(
        child: Column(
           children: [
          
            // Number Image
            Expanded(
              flex: 3,
              child: 
               SlideTransition(
              position: _slideAnimation,
              child:Center(
              child: AnimatedBuilder(
        animation: _idleOffset,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _idleOffset.value),
            child: child,
          );
        },
             
           child:GestureDetector(
                onTap: _playLesson,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Image.asset(
                    widget.data.numberImagePath,
                    fit: BoxFit.contain, // Ensures it fits available space
                  ),
                ),
              ),
            ),
               ),
               ),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ScaleTransition(
                    scale: _breatheAnimation,
                    child: SoundButton(color: buttonColor, onPressed: _playLesson),
                    ),
                  if(_hasInteracted)
                  NextButton(color:buttonColor,onPressed:  widget.onNext,)
                  else
                  const SizedBox(width: 90,)
                ],

              ),
              )
           ]   
           
        )) ,
          
    );
  }
}
