import'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/numbers_train_model.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Widgets/Buttons/play_button.dart';
import 'package:kido/Widgets/Buttons/replay_button.dart';
import 'package:kido/Widgets/content/level3/numbers/numbers_train_display.dart';
import 'package:kido/data/level3/numbers/train_test_data.dart';
import 'package:kido/services/asset_service.dart';
import 'package:kido/services/audio_service.dart';

class NumbersTrain extends StatefulWidget {
  final int phase;
  final TrainLessonLanguage language;
  const NumbersTrain({
    super.key,
    required this.phase,
    required this.language,
    });

  @override
  State<NumbersTrain> createState() => _NumbersTrainState();
}

class _NumbersTrainState extends State<NumbersTrain> with TickerProviderStateMixin{
  int get carsNumberInPhase => widget.phase == 1 ? 5 : 9;
  //animations
  late AnimationController _moveController;
  late AnimationController _walkController;
  TrainMode currentMode=TrainMode.presenting;
  int currentCars=0;
  bool hasStarted=false;
  bool isFirstTripFinished=false;
  bool isReady = false;
  int currentQuestionIndex=0;

  //test state
  bool isTestTrip=false;
  bool isWaitingForInput=false;
  bool isTestAnswered=false;
  int? acceptedCarIndex;

  List<TrainQuestion> get phaseQuestions=>trainTestQuestions.where(
    (q)=>q.phase==widget.phase&&q.language==widget.language).toList();
  TrainQuestion get trainQuestion=>phaseQuestions[currentQuestionIndex];

 

  @override
  void initState(){
    super.initState();
    setupAnimations();
    warmUpAssets();
    
  


_moveController.addStatusListener((status){
      if(status==AnimationStatus.completed){
        handleAnimation();
      }
  });
  

  _moveController.addListener(checkTrainPosition);

    

    autoAddCar();
  }

  void setupAnimations(){
       //moving the train
    _moveController=AnimationController(
      duration:const Duration(seconds:15),
      vsync:this,
    );

    //walking effect
    _walkController=AnimationController(
      duration:const Duration(milliseconds:600),
      vsync:this,
    );
    }

    void handleAnimation(){
      if(!mounted) return;
      setState(() {
        hasStarted=false;
        isFirstTripFinished=true;
        if(isTestTrip){
          currentMode=TrainMode.finished;
        }else{
          currentCars=0;
          currentMode=TrainMode.presenting;
        }
      });
      _walkController.stop();
      AudioService.stop();
      _moveController.reset();

    }
   
  void warmUpAssets(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    final warmUP=[
      AssetService.images.trainBackgroundPath,
      AssetService.images.trainRailwayPath,
      AssetService.images.trainEnginePath,
      ...AssetService.images.carRange(carsNumberInPhase,widget.language)
    ];
    await AssetService.warmupAssets(context, warmUP);
    if(mounted){
      setState(()=>isReady=true);
    }
  });
  }

   void autoAddCar() async{

    if(isTestTrip) return;
    setState((){
      currentCars=0;
    });
    int totalCars=carsNumberInPhase;
    for(int i=0;i<totalCars;i++){
      await Future.delayed(const Duration(seconds:1));
      if(mounted&&hasStarted&&currentCars<totalCars){
        setState(() {
          currentCars++;
        });
      }
    }
  }


void startTrip(){
  _moveController.reset();
  setState(() {
    hasStarted=true;
    currentMode=TrainMode.presenting;
    currentCars=0;
    isFirstTripFinished=false;
    isTestTrip=false;
  });
  playSong();
  _moveController.forward(from:0);
  _walkController.repeat(reverse: true);
  autoAddCar();

}

void startTestTrip(){
  _moveController.reset();
  setState((){
    hasStarted=true;
    currentMode=TrainMode.presenting;
    isTestTrip=true;
    isWaitingForInput=false;
    isTestAnswered=false;
    acceptedCarIndex=null;
    currentQuestionIndex=0;
    _moveController.forward(from:0);
    _walkController.repeat(reverse: true);

  });
}

void checkTrainPosition() {
  
  if(isTestTrip&&_moveController.value>=trainQuestion.stopPosition&&!isWaitingForInput&&!isTestAnswered) {
    _moveController.stop();
    _walkController.stop();
    setState(() {
      isWaitingForInput=true;
      currentMode=TrainMode.testing; 
    });
  }
}

void onQuestionAnswered(Map<String,String?> answer){
  if(answer.isEmpty) return;
  final carNumber=trainQuestion.carNumberFromPath(answer.keys.first!);
  AudioService.play(fileName: 'yaay.mp3');
  setState(() {
    acceptedCarIndex=carNumber;
    isWaitingForInput=false;
    isTestAnswered=true;
    currentMode=TrainMode.presenting;
  });
  _moveController.forward();
  _walkController.repeat(reverse: true);
}

Future playSong() async{
    await AudioService.play(fileName: 'numeric_en/half_song.mp3');
  }
  

  @override
  void dispose(){
    _moveController.dispose();
    _walkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!isReady) return const Scaffold(backgroundColor: Colors.white);
    return Scaffold(
      body: Stack(
          children: [
             buildBackground(),
             if(hasStarted)
             TrainDisplay(
              acceptedCarIndex: acceptedCarIndex, 
              currentCars: currentCars, 
              currentQusetion:trainQuestion , 
              isTestTrip: isTestTrip, 
              isWaitingForInput: isWaitingForInput, 
              language: widget.language, 
              totalCarsInPhase: widget.phase==1?5:9, 
              onAnswered:onQuestionAnswered , 
              moveAnimation:_moveController , 
              walkAnimation:_walkController,
              ),
             buildControllers(),
                
          ],
        ),
      
    );
  }

  Widget buildBackground(){
    return Stack(
      children:[
     Positioned.fill(
             child:Image.asset(
              AssetService.images.trainBackgroundPath,
              fit:BoxFit.cover,
            ),
     ),
           
            Positioned(
              top: (MediaQuery.of(context).size.height / 2) + 20,
              left:0,
              right:0,
              child:Image.asset(AssetService.images.trainRailwayPath,height:100,fit:BoxFit.cover),
                     
            ),
      ],
    );
  }

  Widget buildControllers(){
     if(currentMode!=TrainMode.testing&&!hasStarted){
      return Container(
                  color:Colors.transparent,
                  alignment:Alignment.bottomCenter,
                  child:Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child:isFirstTripFinished
                  ?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReplayButton(color: const Color.fromARGB(255, 182, 142, 90), onPressed: startTrip),
                      const SizedBox(width: 60),
                      NextButton(color: Colors.greenAccent[700]!, 
                      onPressed: (){
                        if(currentMode==TrainMode.finished){
                          Navigator.pop(context,true);
                        }else{
                        setState(()=>
                          isFirstTripFinished=false);
                        startTestTrip();
                        }
                      },
                        )
                    ],
                  )
                  :PlayButton(
                    color:Colors.green,
                    onTap:(){
                      startTrip();
                    }
                  )
                )

            );

  }
  return const SizedBox.shrink();}
}