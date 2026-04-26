// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Widgets/puls_button.dart';
import 'package:kido/constants.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/level3/pixel.dart';
import '../../../../data/level3/fruits/fruits_tree.dart';

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
  final AudioPlayer _winPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _winPlayer.dispose();
    super.dispose();
  }

  bool get _isComplete => _pickedIndices.length == positions.length;

  Future<void> _handleFruitTap(int index, PixelItem fruit) async {
    if (_pickedIndices.contains(index)) return;
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

    if (_isComplete) {
      await Future.delayed(const Duration(milliseconds: 800));
      _playWinSequence();
    }
  }

  void _playWinSequence() async {
    try {
      await _winPlayer.play(AssetSource('audio/yaay.mp3'));
    } catch (e) {
      debugPrint("Win sound error: $e");
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
                  curve: Curves.easeInBack,
                  child: Image.asset(fruit.mainImage, height: 100),
                ),
              ),
            );
          }),
          if (_isComplete)
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
              ),
            ),
          if (_isComplete)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                  child: PulseButton(
                      onPressed: widget.onNext!,
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        size: 90,
                        color: widget.fruit.primaryColor,
                      )
                  )
              ),
            ),
        ],
      ),
    );
  }
}