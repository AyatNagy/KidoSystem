// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/constants.dart';

import '../../../../Models/level3/pixel.dart';

class TreeDiscoveryPage extends StatefulWidget {
  final PixelItem fruit;
  final VoidCallback? onNext;

  const TreeDiscoveryPage({super.key, required this.fruit, this.onNext});

  @override
  State<TreeDiscoveryPage> createState() => _TreeDiscoveryPageState();
}

class _TreeDiscoveryPageState extends State<TreeDiscoveryPage> {
  late AudioPlayer _audioPlayer;
  final Set<int> _pickedIndices = {};

  // Define positions here so we can check the total count
  final List<Map<String, dynamic>> _positions = [
    {'top': 0.25, 'left': 0.25},
    {'top': 0.40, 'left': 0.20},
    {'top': 0.5, 'left': 0.65},
    {'top': 0.52, 'left': 0.01},
    {'top': 0.32, 'left': 0.55},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  bool get _isTaskComplete => _pickedIndices.length == _positions.length;

  Future<void> _handleFruitTap(int index, PixelItem fruit) async {
    if (_pickedIndices.contains(index)) return;

    HapticFeedback.mediumImpact();
    try {
      String path = fruit.soundPath.replaceFirst('assets/', '');
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }

    setState(() {
      _pickedIndices.add(index);
    });

    if (_isTaskComplete) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            top: 200,
            bottom: 100,
            child: Image.asset(
              "assets/images/fruits/tree.png",
              fit: BoxFit.cover,
            ),
          ),
          ..._positions.asMap().entries.map((entry) {
            int idx = entry.key;
            var pos = entry.value;
            PixelItem fruit = widget.fruit;

            return Positioned(
              top: size.height * pos['top'],
              left: size.width * pos['left'],
              child: GestureDetector(
                onTap: () => _handleFruitTap(idx, fruit),
                child: AnimatedScale(
                  scale: _pickedIndices.contains(idx) ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 600),
                  curve:
                      Curves
                          .easeInBack, // Changed to easeInBack for a "plucking" feel
                  child: Image.asset(fruit.mainImage, height: 100),
                ),
              ),
            );
          }),

          // The "Next" Button - Appears only when all fruits are picked
          if (_isTaskComplete)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: ElevatedButton.icon(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kidoGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 30),
                    label: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Floating Score/Counter (Optional - helpful for kids)
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Text(
                "${_pickedIndices.length}/${_positions.length}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.kidoBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
