import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Models/level3/bubbleModel.dart';
import '../../../../Widgets/content/bubble.dart';
import '../../../../data/colors.dart';

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
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
      if (!_hasWon) _addNewBubble();
    });
  }

  void _addNewBubble() {
    if (!mounted) return;
    setState(() {
      _bubbles.add(BubbleModel(
        id: DateTime.now().millisecondsSinceEpoch,
        xPosition: _random.nextDouble(),
        color: kidoColors[_random.nextInt(kidoColors.length)],
        size: 90.0 + _random.nextDouble() * 30.0,
      ));
    });
  }

  void _handleBubbleRemoval(int id, {required bool isTapped}) {
    if (_hasWon) return;
    setState(() {
      _bubbles.removeWhere((b) => b.id == id);
      if (isTapped) {
        HapticFeedback.mediumImpact();
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
      backgroundColor: const Color(0xFFFDF5E6),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.08,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
              itemBuilder: (context, index) => const Icon(Icons.star, size: 20, color: Colors.blueGrey),
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
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Text("🌟 $_score / ${widget.goalScore}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
        ],
      ),
    );
  }
}