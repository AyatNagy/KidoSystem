import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/constants.dart';
import '../../../../Models/level3/bubbleModel.dart';
import '../../../../Widgets/content/bubble.dart';

class BubblePopGame extends StatefulWidget {
  final String targetLetter;
  final int goalScore;

  const BubblePopGame({
    super.key,
    required this.targetLetter,
    this.goalScore = 5,
  });

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  final List<BubbleModel> _bubbles = [];
  final Random _random = Random();
  late Timer _timer;
  int _score = 0;
  bool _hasWon = false;

  @override
  void initState() {
    super.initState();_timer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
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
      _bubbles.add(BubbleModel(
        id: DateTime.now().millisecondsSinceEpoch,
        xPosition: _random.nextDouble(),
        color: kidoSelection[_random.nextInt(kidoSelection.length)],
        size: 85.0 + _random.nextDouble() * 25.0,
      ));
    });
  }

  void _handleBubbleRemoval(int id, {required bool isTapped}) {
    if (_hasWon) return;
    setState(() {
      _bubbles.removeWhere((b) => b.id == id);
      if (isTapped) {
        HapticFeedback.lightImpact();
        _score++;
        if (_score >= widget.goalScore) _handleWin();
      }
    });
  }

  void _handleWin() {
    setState(() {
      _hasWon = true;
      _bubbles.clear();
    });
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
              itemBuilder: (context, index) => const Icon(
                  Icons.cloud_queue_rounded,
                  size: 30,
                  color: AppColors.kidoBlue
              ),
            ),
          ),

          ..._bubbles.map((bubble) => BubbleWidget(
            key: ValueKey(bubble.id),
            bubble: bubble,
            letter: widget.targetLetter,
            onPop: () => _handleBubbleRemoval(bubble.id, isTapped: true),
            onExpired: () => _handleBubbleRemoval(bubble.id, isTapped: false),
          )),
          _buildAppBar(),
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
                    offset: const Offset(0, 5)
                )
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