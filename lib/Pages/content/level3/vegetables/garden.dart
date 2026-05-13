// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class GardenHarvestGame extends StatefulWidget {
  final String targetImage;
  final String distractorImage;
  final String soundPath;
  final VoidCallback onComplete;

  const GardenHarvestGame({
    super.key,
    required this.targetImage,
    required this.distractorImage,
    required this.soundPath,
    required this.onComplete,
  });

  @override
  State<GardenHarvestGame> createState() => _GardenHarvestGameState();
}

class _GardenHarvestGameState extends State<GardenHarvestGame>
    with TickerProviderStateMixin {
  int count = 0;
  List<bool> pickedStatus = [false, false, false, false, false];
  List<bool> isJumping = [false, false, false, false, false];
  late List<String> items;
  late AnimationController _basketController;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _basketController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    items = [
      widget.targetImage,
      widget.targetImage,
      widget.targetImage,
      widget.distractorImage,
      widget.distractorImage
    ]..shuffle();
  }

  @override
  void dispose() {
    _basketController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String path) async {
    try {
      String cleanPath = path.replaceFirst('assets/', '');
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  void _onTapVegetable(int index, BuildContext context, bool isCorrect) async {
    if (pickedStatus[index] || isJumping[index]) return;

    if (isCorrect) {
      _playSound(widget.soundPath);
      setState(() {
        isJumping[index] = true;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        setState(() {
          pickedStatus[index] = true;
          isJumping[index] = false;
          count++;
        });
        _basketController.forward(from: 0);
        if (count == 3) {
          Lottie.asset(
            'assets/lottie/confetti.json',
            repeat: false,
            fit: BoxFit.cover,
          );
          _playSound('audio/yaay.mp3');
          Future.delayed(const Duration(seconds: 2), widget.onComplete);
        }
      }
    } else {
      HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cartoonVegetable/refiregator.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Wrap(
                spacing: 30,
                runSpacing: 50,
                alignment: WrapAlignment.center,
                children: List.generate(items.length, (index) {
                  bool isTarget = items[index] == widget.targetImage;
                  return GestureDetector(
                    onTap: () => _onTapVegetable(index, context, isTarget),
                    child: _buildVegetableItem(index, items[index]),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Swing(
                controller: (ctrl) => _basketController = ctrl,
                manualTrigger: true,
                child: BounceInUp(
                  child: Image.asset(
                    "assets/images/cartoonVegetable/vege-box.png",
                    width: 200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVegetableItem(int index, String imagePath) {
    bool picked = pickedStatus[index];
    bool jumping = isJumping[index];

    return AnimatedScale(
      scale: picked ? 0.0 : (jumping ? 1.4 : 1.0),
      duration: const Duration(milliseconds: 400),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, jumping ? -180 : 0, 0),
        child: Opacity(
          opacity: picked ? 0.0 : 1.0,
          child: ZoomIn(
            delay: Duration(milliseconds: index * 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imagePath, width: 110, height: 110),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: jumping ? 0.2 : 1.0,
                  child: Container(
                    width: 70,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius:
                      const BorderRadius.all(Radius.elliptical(70, 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}