import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Models/level3/pixel.dart';

class FruitCollectorPage extends StatefulWidget {
  final PixelItem fruit;

  const FruitCollectorPage({super.key, required this.fruit});

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

  Future<void> _playFruitSound() async {
    try {
      String path = widget.fruit.soundPath.replaceFirst('assets/', '');
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
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
    _playFruitSound();

    setState(() {
      _collectedCount++;
      if (_collectedCount < _targetCount) {
        _generateRandomPosition();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF90AD42),
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
                      colorBlendMode: index < _collectedCount ? BlendMode.dst : BlendMode.srcIn,
                    ),
                  );
                }),
              ),
            ),
          ),

          if (_collectedCount < _targetCount)
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
                    if (_collectedCount == 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "ضع الفاكهة في السلة",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
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
        ],
      ),
    );
  }
}