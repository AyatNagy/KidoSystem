import 'package:flutter/material.dart';
import 'package:kido/Models/level3/numbers/tracing_numbers.dart';
import'package:audioplayers/audioplayers.dart';
import'package:lottie/lottie.dart';

class TracingGame extends StatefulWidget {
  final TracingQuestion question;
  TracingGame({required this.question});

  @override
  _TracingGameState createState() => _TracingGameState();
}

class _TracingGameState extends State<TracingGame> {
  int gameStage=1; 
  bool isVisible=true;
  bool isTransitioning=false;
  Offset? beePosition;
  Offset? startOfDragPosition;
  bool initialized=false;
  bool showConfettie=false;
  final AudioPlayer audioPlayer=AudioPlayer();

   String _getBackgroundImage() {
    switch (gameStage) {
      case 1: return widget.question.backgroundImage1;
      case 2: return widget.question.backgroundImage2;
      case 3: return widget.question.backgroundImage3;
      default: return widget.question.backgroundImage4;
    }
  }
  void resetTracing() {
  setState(() {
    gameStage = 1;
    isVisible = true;
    isTransitioning = false;
    initialized = false; 
  });
}

void goToNextNumber() {
  // Use your app's navigation logic here
  // For example: Navigator.push(...) or a callback
  print("Moving to next number!");
}

Future<void> playAudio ()async{
  try{
          await audioPlayer.play(AssetSource(widget.question.audioPath));
  }catch(error){
    print("error in playing audio $error");
  }
}

Widget _buildRoundButton({
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
  required String heroTag,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: color,
      elevation: 0,
      shape: const CircleBorder(),
      child: Icon(icon, color: Colors.white, size: 30),
    ),
  );
}
  Offset _getClosestPointOnPath(Offset currentPos, List<Offset> points, BoxConstraints constraints) {
  Offset closest = _getPx(points.first, constraints);
  double minDistance = (currentPos - closest).distance;

  for (int i = 0; i < points.length - 1; i++) {
    Offset p1 = _getPx(points[i], constraints);
    Offset p2 = _getPx(points[i + 1], constraints);

    // Math to find the projection of the point onto the line segment p1-p2
    double l2 = (p1 - p2).distanceSquared;
    if (l2 == 0.0) continue;
    double t = ((currentPos.dx - p1.dx) * (p2.dx - p1.dx) + (currentPos.dy - p1.dy) * (p2.dy - p1.dy)) / l2;
    t = t.clamp(0.0, 1.0);
    Offset projection = Offset(p1.dx + t * (p2.dx - p1.dx), p1.dy + t * (p2.dy - p1.dy));

    double dist = (currentPos - projection).distance;
    if (dist < minDistance) {
      minDistance = dist;
      closest = projection;
    }
  }
  return closest;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (!initialized) {
            beePosition = _getPx(widget.question.startPosition, constraints);
            initialized = true;
          }

          Offset currentTarget = gameStage == 1 
              ? _getPx(widget.question.midTarget, constraints) 
              : _getPx(widget.question.endTarget, constraints);

          return Stack(
            children: [
              Positioned.fill(child: Image.asset("assets/images/bee_tracing_background.png",fit: BoxFit.cover,),),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Image.asset(
                    _getBackgroundImage(),
                    key: ValueKey(gameStage),
                    width: 300,
                  ),
                ),
              ),

              if (beePosition != null && gameStage < 4)
                AnimatedPositioned(
                      duration: isTransitioning ? Duration.zero : const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      left: beePosition!.dx - 40,
                      top: beePosition!.dy - 40,
                  child: Visibility(
                    visible: isVisible,
                    child: GestureDetector(
                      onPanStart: (details) {
                        // Store the position when the child first touches the bee
                        startOfDragPosition = beePosition;

                      },
                     onPanUpdate: (details) {
                       if (isTransitioning) return;
                        // 1. Where the finger wants the bee to go
                        Offset fingerPos = beePosition! + details.delta;
                        // 2. Where the bee is ALLOWED to go (the closest point on the number's spine)
                        Offset allowedPos = _getClosestPointOnPath(fingerPos, widget.question.pathPoints, constraints);
                       // 3. Strictness Check: // If the finger is more than 60 pixels away from the number, the bee won't follow.
                       double fingerDistFromPath = (fingerPos - allowedPos).distance;
                       if (fingerDistFromPath < 60) {
                           setState(() {
                             beePosition = allowedPos; // Magnetize bee to the path
                            });
                        // 4. Check if we hit the current stage's target
                       double distanceToTarget = (beePosition! - currentTarget).distance;
                        if (distanceToTarget < 35) {
                         _handleStageClear(constraints);
                         }
                       }
                       },
                      onPanEnd: (details) {
                        if (isTransitioning) return;

                        // SNAP BACK LOGIC:
                        // If the drag ends and we haven't hit the target, snap back
                        double distance = (beePosition! - currentTarget).distance;
                        if (distance >= 35) {
                          setState(() {
                            beePosition = startOfDragPosition;
                          });
                        }
                      },
                      child: Image.asset(widget.question.characterImage, width: 80),
                    ),
                  ),
                ),

                if(showConfettie)
                       IgnorePointer(
                        child: Center(
                          child: Lottie.asset('assets/lottie/CONFETTI.json',repeat: false,fit: BoxFit.contain),
                        ),
                       ),
                

                if (gameStage == 4)
  TweenAnimationBuilder(
    // Triggering only when gameStage becomes 4
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 800),
    curve: Curves.elasticOut,
    builder: (context, double value, child) {
      return Transform.scale(
        scale: value,
        child: child,
      );
    },
    child: Align(
      alignment: Alignment.bottomCenter,
      // Lifted the buttons higher (vertical: 80)
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- ROUND RETRY BUTTON ---
            _buildRoundButton(
              icon: Icons.refresh_rounded,
              color: Colors.orangeAccent,
              onPressed: resetTracing,
              heroTag: "retry",
            ),

            // --- ROUND NEXT BUTTON ---
            _buildRoundButton(
              icon: Icons.arrow_forward_ios_rounded,
              color: Colors.greenAccent[700]!,
              onPressed: goToNextNumber,
              heroTag: "next",
            ),
          ],
        ),
      ),
    ),
  ),
  
            ],
          );
        },
      ),
    );
  }


  void _handleStageClear(BoxConstraints constraints) async {
    if (isTransitioning) return;
    isTransitioning = true;
    audioPlayer.play(AssetSource('audio/success.mp3'));
    
    setState((){
      isVisible=false;
      showConfettie=true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      showConfettie=false;
      if (gameStage == 1) {
        gameStage = 2;
        // Bee stays at the top curve for Stage 2
        beePosition = _getPx(widget.question.midTarget, constraints); 
      } 
      else if (gameStage == 2) {
        gameStage = 3;
        // Bee resets to the very top dash for Stage 3
        beePosition = _getPx(widget.question.startPosition, constraints);
      } 
      else {
        gameStage = 4;
        playAudio();
      }
      
      isVisible = (gameStage < 4);
      isTransitioning = false;
    });
  }

 Offset _getPx(Offset percent, BoxConstraints constraints) {
  // 1. Define the size of your number image as it appears in the Center widget
  const double imageSize = 300.0;

  // 2. Calculate the 'Letterbox' offsets (the space around the image)
  double offsetX = (constraints.maxWidth - imageSize) / 2;
  double offsetY = (constraints.maxHeight - imageSize) / 2;

  // 3. Map the percentage (0.0 - 1.0) strictly to that 300x300 square area
  return Offset(
    (percent.dx * imageSize) + offsetX,
    (percent.dy * imageSize) + offsetY,
  );
}
}