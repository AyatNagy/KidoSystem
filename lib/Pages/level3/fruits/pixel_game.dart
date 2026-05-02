// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Models/level3/fruits/pixel_fruits.dart';
import '../../../Widgets/content/level3/pixel_widget.dart';
import '../../../Widgets/Buttons/puls_button.dart';
import '../../../constants.dart';

class FruitGamePage extends StatefulWidget {
  final PixelFruitModel fruit;
  final VoidCallback? onComplete;

  const FruitGamePage({super.key, required this.fruit, this.onComplete});

  @override
  State<FruitGamePage> createState() => _FruitGamePageState();
}

class _FruitGamePageState extends State<FruitGamePage>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late final AnimationController _cloudController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _playFruitSound(String? soundAsset) async {
    if (soundAsset == null) return;
    try {
      String soundPath = soundAsset.replaceFirst('assets/', '');
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void _onFruitComplete() {
    HapticFeedback.heavyImpact();
    _playFruitSound(widget.fruit.soundPath);
    _showCreativeSuccessDialog(widget.fruit);
  }

  void _showCreativeSuccessDialog(PixelFruitModel fruit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Success",
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: const BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(34),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 15),
                          ],
                          image: DecorationImage(
                            image: AssetImage(fruit.mainImage),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PulseButton(
                      onPressed: () => _playFruitSound(fruit.soundPath),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: widget.fruit.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30,
                      left: 30,
                      right: 30,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _finishLesson();
                      },
                      child: Center(
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                            color: widget.fruit.fruitColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _finishLesson() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            _buildMagicEasel(widget.fruit),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMagicEasel(PixelFruitModel currentFruit) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -80,
          left: 50,
          child: Container(
            width: 15,
            height: 120,
            color: Colors.brown.shade300,
          ),
        ),
        Positioned(
          bottom: -80,
          right: 50,
          child: Container(
            width: 15,
            height: 120,
            color: Colors.brown.shade300,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.brown.shade100, width: 10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: PixelColoringWidget(
            key: ValueKey(currentFruit.name),
            item: currentFruit,
            onComplete: _onFruitComplete,
          ),
        ),
      ],
    );
  }
}
