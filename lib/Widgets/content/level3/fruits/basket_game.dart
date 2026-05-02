// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../Buttons/puls_button.dart';
import '../../../../Models/level3/pixel.dart';

class FruitCollectorPage extends StatefulWidget {
  final PixelItem fruit;
  final VoidCallback? onNext;

  const FruitCollectorPage({super.key, required this.fruit, this.onNext});

  @override
  State<FruitCollectorPage> createState() => _FruitCollectorPageState();
}

class _FruitCollectorPageState extends State<FruitCollectorPage> {
  int _collectedCount = 0;
  final int _targetCount = 5;
  late double _itemTop;
  late double _itemLeft;
  final Random _random = Random();
  late AudioPlayer _audioPlayer;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _generateRandomPosition();
  }

  @override
  void dispose() {
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

  void _generateRandomPosition() {
    _itemTop = _random.nextDouble() * 250 + 150;
    _itemLeft = _random.nextDouble() * 200 + 50;
  }

  void _onItemCollected() {
    HapticFeedback.heavyImpact();

    setState(() {
      _collectedCount++;
      if (_collectedCount < _targetCount) {
        _playSound(widget.fruit.soundPath);
        _generateRandomPosition();
      } else {
        _isComplete = true;
        _playSound('audio/yaay.mp3');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90AD42),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/garden.png",
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_targetCount, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: index < _collectedCount
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      widget.fruit.mainImage,
                      height: 35,
                      color: index < _collectedCount ? null : Colors.black26,
                      colorBlendMode:
                      index < _collectedCount ? BlendMode.dst : BlendMode.srcIn,
                    ),
                  );
                }),
              ),
            ),
          ),
          if (!_isComplete)
            Positioned(
              top: _itemTop,
              left: _itemLeft,
              child: Draggable<String>(
                data: "fruit",
                feedback: Material(
                  color: Colors.transparent,
                  child: Image.asset(widget.fruit.mainImage, height: 110),
                ),
                childWhenDragging: const SizedBox.shrink(),
                child: Image.asset(widget.fruit.mainImage, height: 100),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: DragTarget<String>(
              onAccept: (data) => _onItemCollected(),
              builder: (context, candidateData, rejectedData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_collectedCount == 0 && !_isComplete)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "ضع الفاكهة في السلة",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ),
                    const SizedBox(height: 10),
                    AnimatedScale(
                      scale: candidateData.isNotEmpty ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        "assets/images/basket.png",
                        height: 220,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (_isComplete)
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                repeat: false,
                fit: BoxFit.cover,
              ),
            ),
          if (_isComplete)
            Positioned(
              bottom: 50,
              left: 250,
              right: 0,
              child: Center(
                child: PulseButton(
                    onPressed: widget.onNext!,
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 90,
                      color: widget.fruit.primaryColor,
                    ),
                  ),
              ),
            ),
        ],
      ),
    );
  }
}