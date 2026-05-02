import'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Widgets/Buttons/play_button.dart';
import 'package:kido/Widgets/Buttons/replay_button.dart';
import 'package:kido/services/asset_service.dart';
import 'package:kido/services/audio_service.dart';
import'dart:async';

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
  late AnimationController _moveController;
  late AnimationController _walkController;
  int currentCars=0;
  bool hasStarted=false;
  bool isFirstTripFinished=false;
  int get carsNumberInPhase=> widget.phase==1? 5:9;
  //track assets
  bool isReady = false;
 

  @override
  void initState(){
    super.initState();
    
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


      //moving the train
    _moveController=AnimationController(
      duration:const Duration(seconds:15),
      vsync:this,
    );

    _moveController.addStatusListener((status){
      if(status==AnimationStatus.completed){
        setState((){
          hasStarted=false;
          isFirstTripFinished=true;
          currentCars=0;
        });
        _walkController.stop();
       AudioService.stop();
        _moveController.reset();
       
      }
    });

    //walking effect
    _walkController=AnimationController(
      duration:const Duration(milliseconds:600),
      vsync:this,
    );

    autoAddCar();
  }

  void autoAddCar() async{
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
  setState(() {
    hasStarted=true;
    currentCars=0;
  });
  playSong();
  _moveController.forward(from:0);
  _walkController.repeat(reverse: true);
  autoAddCar();

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
            //Container(color: Colors.lightBlue[100],),
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
            AnimatedBuilder(
              animation: Listenable.merge([_moveController,_walkController]),
               builder: (context,child){
                double trainWidth=300.0+(carsNumberInPhase*250.0);
                double screenWidth=MediaQuery.of(context).size.width;
                double xAxisPos=Tween<double>(
                  begin:screenWidth,
                  end:-trainWidth,
                ).evaluate(_moveController);
                double yAxisPos=_walkController.value*10.0;
                return Positioned(
                  left:xAxisPos,
                  top: (MediaQuery.of(context).size.height / 2) - 60 + yAxisPos,
                  //bottom: MediaQuery.of(context).size.height*0.2+yAxisPos,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(AssetService.images.trainEnginePath,height: 180,fit: BoxFit.contain,),
                      ...List.generate(currentCars,(index){
                        int carNumber = index+1;
                          return Padding(
                            padding: const EdgeInsets.only(left:2.0),
                            child: Image.asset(AssetService.images.car(widget.language,carNumber),height: 155,fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.amber,
            width: 100,
            height: 150,
            child: Text('Missing car_$carNumber'),
          );
        },
                            ),
                            );
                      })
                    ],
                  ),
                  );
               },
               ),

               if(!hasStarted)
                Container(
                  color:Colors.transparent,
                  alignment:Alignment.bottomCenter,
                  child:Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child:isFirstTripFinished
                  ?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReplayButton(color: const Color.fromARGB(255, 27, 24, 20), onPressed: startTrip),
                      const SizedBox(width: 60),
                      NextButton(color: Colors.greenAccent[700]!, onPressed: (){
                        Navigator.of(context).pop(true);
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
                )
          ],
        ),
      
    );
  }
}