import'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/numbers_train_model.dart';
import 'package:kido/Widgets/content/draganddrop.dart';
import 'package:kido/services/asset_service.dart';
class TrainDisplay extends StatelessWidget {
 final TrainQuestion currentQusetion;
 final TrainLessonLanguage language;
 final int currentCars;
 final int totalCarsInPhase;
 final bool isTestTrip;
 final bool isWaitingForInput;
 final int? acceptedCarIndex;
 final Function(Map<String,String?>) onAnswered;
 final Animation<double> moveAnimation;
 final Animation<double> walkAnimation;

  const TrainDisplay({
    super.key,
    required this.acceptedCarIndex,
    required this.currentCars,
    required this.currentQusetion,
    required this.isTestTrip,
    required this.isWaitingForInput,
    required this.language,
    required this.totalCarsInPhase,
    required this.onAnswered,
    required this.moveAnimation,
    required this.walkAnimation,
  });

  @override
  Widget build(BuildContext context) {
    double carHeight = 155.0;
    final q=currentQusetion.question;
    double testHight=carHeight/q.targets.first.size.height;
    double testWidth=testHight*(q.targets.first.size.width/q.targets.first.size.height);
    double gapHeight=q.targets.first.size.height*testHight;
    double gapWidth=q.targets.first.size.width*testWidth;
 
    return AnimatedBuilder(
      animation: Listenable.merge([moveAnimation, walkAnimation]),
      builder: (context, child) {
        double trainWidth = 300.0 + (totalCarsInPhase * 250.0);
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double xAxisPos = Tween<double>(begin: screenWidth, end: -trainWidth).evaluate(moveAnimation);
        double trainTop=(screenHeight/2)-60+(walkAnimation.value*10.0);
        double gapLeft=xAxisPos+300+(currentQusetion.gapIndex*157.0);
        return Stack(
          children:[ 
            Positioned(
        left:xAxisPos,
        top:trainTop,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(AssetService.images.trainEnginePath, height: 180, fit: BoxFit.contain),
            ...List.generate(isTestTrip?totalCarsInPhase:currentCars,(index) {
             
              if (isTestTrip && index == currentQusetion.gapIndex) {  
                if(acceptedCarIndex!=null){
                  return Padding(
                    padding: const EdgeInsets.only(left:2.0),
                    child: Image.asset(AssetService.images.car(language, acceptedCarIndex!),
                           height: 155,
                           fit: BoxFit.contain,
                        ),
                  );
                }
                return   SizedBox(width: gapWidth, height: gapHeight);
              }
              return Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Image.asset(AssetService.images.car(language, index + 1), height: 155),
              );
            })
          ],
        ),
     ),

      if (isWaitingForInput)
            Positioned(
              left: gapLeft,
              top: trainTop,
              width: testWidth,
              height: screenHeight-trainTop,
              child: DragDropWidget(
                question:q,
                onAnswered:onAnswered,
    
              ),
            ),
     ],
      );
      },
    );
  }
}