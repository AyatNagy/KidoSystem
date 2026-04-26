// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/constants.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/level3/bubble_model.dart';
import '../../../../Widgets/content/bubble.dart';
import '../../../puls_button.dart';

class BubblePopGame extends StatefulWidget {
  final String targetLetter;
  final String audioPath;
  final int goalScore;
  final VoidCallback? onNext;

  const BubblePopGame({
    super.key,
    required this.targetLetter,
    required this.audioPath,
    this.goalScore = 5,
    this.onNext,
  });

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  final List<BubbleModel> _bubbles = [];
  final Random _random = Random();
  late Timer _timer;
  late final AudioPlayer _audioPlayer;
  int _score = 0;
  bool _hasWon = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _timer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
      if (!_hasWon) _addNewBubble();
    });
  }

  void _addNewBubble() {
    if (!mounted) return;
    final List<Color> kidoSelection = [
      AppColors.kidoPink,
      AppColors.kidoOrange,
      AppColors.kidoGreen,
      AppColors.kidoBlue,
    ];

    setState(() {
      _bubbles.add(
        BubbleModel(
          id: DateTime.now().millisecondsSinceEpoch,
          xPosition: _random.nextDouble(),
          color: kidoSelection[_random.nextInt(kidoSelection.length)],
          size: 85.0 + _random.nextDouble() * 25.0,
        ),
      );
    });
  }

  void _handleBubbleRemoval(int id, {required bool isTapped}) {
    if (_hasWon) return;
    setState(() {
      _bubbles.removeWhere((b) => b.id == id);
      if (isTapped) {
        HapticFeedback.lightImpact();
        String path = widget.audioPath.replaceAll('assets/', '');
        _audioPlayer.play(AssetSource(path));

        _score++;
        if (_score >= widget.goalScore) _handleWin();
      }
    });
  }

  void _handleWin() {
    HapticFeedback.mediumImpact();
    _audioPlayer.play(AssetSource('audio/yaay.mp3'));

    setState(() {
      _hasWon = true;
      _bubbles.clear();
    });
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemBuilder:
                  (context, index) => const Icon(
                    Icons.cloud_queue_rounded,
                    size: 40,
                    color: AppColors.kidoBlue,
                  ),
            ),
          ),

          ..._bubbles.map(
            (bubble) => BubbleWidget(
              key: ValueKey(bubble.id),
              bubble: bubble,
              letter: widget.targetLetter,
              onPop: () => _handleBubbleRemoval(bubble.id, isTapped: true),
              onExpired: () => _handleBubbleRemoval(bubble.id, isTapped: false),
            ),
          ),

          _buildAppBar(),

          if (_hasWon)
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                repeat: false,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (_hasWon)
            Center(
              child: PulseButton(
                onPressed: widget.onNext!,
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 100,
                  color: AppColors.kidoGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kidoBlue.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("⭐", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(
                  "$_score / ${widget.goalScore}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}