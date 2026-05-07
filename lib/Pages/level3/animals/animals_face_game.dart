import 'package:flutter/material.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/Widgets/content/success_overlay_widget.dart';
import 'package:kido/data/level3/animals/animals_data.dart';
import 'package:kido/data/level3/animals/animals_faces_game_data.dart';
import 'package:kido/services/audio_service.dart';

class AnimalFaceGamePage extends StatefulWidget {
  final int intialIndex;
  final VoidCallback onGameComplete;
  const AnimalFaceGamePage({super.key,required this.intialIndex,required this.onGameComplete});

  @override
  State<AnimalFaceGamePage> createState() => _AnimalFaceGamePageState();
}

class _AnimalFaceGamePageState extends State<AnimalFaceGamePage> {
 late int currentIndex;
  bool showSuccess=false;
  String get animalNameAudio=>animalsDiscovery[currentIndex].audioName;
void playAnimalAudio(String audioPath){
  AudioService.play(fileName: audioPath);
}
  void handleSuccess(Map<String, String?> answers) {
    if(showSuccess) return;
    if (answers.isNotEmpty) {
      setState(() => 
      showSuccess = true
      );
      AudioService.play(fileName: "yaay.mp3");
      //gif sound
      Future.delayed(Duration(milliseconds: 1500),(){
        if(mounted&&showSuccess){
          playAnimalAudio(animalNameAudio);
        }
      });

      Future.delayed(const Duration(seconds: 6), () {
        if (mounted) {
          widget.onGameComplete();
        }
      });
    }
  }

  @override
  void initState(){
    super.initState();
    currentIndex=widget.intialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playAnimalAudio(animalNameAudio);
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (currentIndex >= AnimalsGameData.animalsQuestions.length) return const SizedBox();
    final currentQuestion=AnimalsGameData.animalsQuestions[currentIndex];
    final animalMedia=animalsDiscovery[currentIndex];
    final Color primaryColor=animalMedia.activeBorder;

    return Scaffold(
      body: Stack(
        children:[
            AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.4),
                radius: 1.4,
                colors: [
                  primaryColor.withValues(alpha:0.4),
                  primaryColor.withValues(alpha:0.2),
                  Colors.white.withValues(alpha:0.8),
                  const Color(0xFFF8F9FE),
                ],
                stops:const [0.0,0.3,0.6,1.0],
              ),
            ),
          ),
          Positioned.fill(
            child:AnimatedSwitcher(
          duration:const Duration(milliseconds:500),
          child:!showSuccess
          ?
          DragDropWidget(
              key: ValueKey('game_$currentIndex'),
              question:currentQuestion,
              onAnswered:handleSuccess,
              onWrongDrop: () => AudioService.play(fileName: "wrong.mp3"),
            )
            :SuccessOverlay(
              key: ValueKey('success_$currentIndex'),
              image:animalMedia.animalPath,
              title:'',
              transform:Matrix4.identity()..scale(1.5),
            ),
         ),   
          ),
          
    
        ],
    ),
    );
  }
}