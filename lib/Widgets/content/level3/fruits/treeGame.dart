import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../Models/level3/pixel.dart';

class TreeDiscoveryPage extends StatefulWidget {
  final PixelItem fruit;

  const TreeDiscoveryPage({super.key, required this.fruit});

  @override
  State<TreeDiscoveryPage> createState() => _TreeDiscoveryPageState();
}

class _TreeDiscoveryPageState extends State<TreeDiscoveryPage> {
  late AudioPlayer _audioPlayer;
  final Set<int> _pickedIndices = {};

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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;final List<Map<String, dynamic>> positions = [
      {'top': 0.25, 'left': 0.25},
      {'top': 0.40, 'left': 0.20},
      {'top': 0.5, 'left': 0.65},
      {'top': 0.52, 'left': 0.01},
      {'top': 0.32, 'left': 0.55},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            top: 200,
            bottom: 100,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/fruits/tree.png",
              fit: BoxFit.cover,
            ),
          ),

          ...positions.asMap().entries.map((entry) {
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
                  curve: Curves.bounceIn,
                  child: Image.asset(
                    fruit.mainImage,
                    height: 100,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}