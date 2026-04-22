// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Models/data.dart';
import 'package:kido/Pages/content/MatchTheSame/game_over_screen.dart';

class MyFlipCardGame extends StatefulWidget {
  const MyFlipCardGame({super.key});

  @override
  State<MyFlipCardGame> createState() => _MyFlipCardGameState();
}

class _MyFlipCardGameState extends State<MyFlipCardGame> {
  int _previousIndex = -1;
  int _time = 3;
  int gameDuration = -3;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  late bool _isFinished;
  late Timer _timer;
  late Timer _durationTimer;
  late int _left;
  late List _data;
  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // AssetSource تاخد المسار بدون كلمة assets/
  Future<void> _playSound(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _time = (_time - 1);
      });
    });
  }

  void startDuration() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        gameDuration = (gameDuration + 1);
      });
    });
  }

  void startGameAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _start = true;
        _timer.cancel();
      });
    });
  }

  void initializeGameData() {
    _data = createShuffledListFromImageSource();
    _cardFlips = getInitialItemStateList();
    _cardStateKeys = createFlipCardStateKeysList();
    _time = 3;
    _left = (_data.length ~/ 2);
    _isFinished = false;
  }

  @override
  void initState() {
    startTimer();
    startDuration();
    startGameAfterDelay();
    initializeGameData();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _durationTimer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  int _getCrossAxisCount() {
    int total = _data.length;
    if (total <= 8) return 4;
    if (total <= 12) return 4;
    if (total <= 16) return 4;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return _isFinished
        ? GameOverScreen(duration: gameDuration)
        : Scaffold(
          backgroundColor: const Color(0xFFF0F4FF),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(
                        Icons.grid_view_rounded,
                        '$_left',
                        'Remaining',
                      ),
                      _divider(),
                      _buildStat(
                        Icons.timer_outlined,
                        '${gameDuration}s',
                        'Duration',
                      ),
                      _divider(),
                      _buildStat(
                        Icons.hourglass_top_rounded,
                        '$_time',
                        'Countdown',
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(),
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return _start
                            ? FlipCard(
                              key: _cardStateKeys[index],
                              onFlip: () async {
                                if (!_flip) {
                                  _flip = true;
                                  _previousIndex = index;
                                  await _playSound('audio/card flip.wav');
                                } else {
                                  _flip = false;
                                  if (_previousIndex != index) {
                                    if (_data[_previousIndex] != _data[index]) {
                                      _wait = true;
                                      await _playSound('audio/wrong.mp3');

                                      Future.delayed(
                                        const Duration(milliseconds: 1500),
                                        () {
                                          _cardStateKeys[_previousIndex]
                                              .currentState!
                                              .toggleCard();
                                          _previousIndex = index;
                                          _cardStateKeys[_previousIndex]
                                              .currentState!
                                              .toggleCard();

                                          Future.delayed(
                                            const Duration(milliseconds: 160),
                                            () {
                                              setState(() {
                                                _wait = false;
                                              });
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      _cardFlips[_previousIndex] = false;
                                      _cardFlips[index] = false;
                                      await _playSound('audio/match.ogg');

                                      setState(() {
                                        _left -= 1;
                                      });

                                      if (_cardFlips.every((t) => t == false)) {
                                        await _playSound('audio/win.wav');
                                        Future.delayed(
                                          const Duration(milliseconds: 400),
                                          () {
                                            setState(() {
                                              _isFinished = true;
                                              _start = false;
                                            });
                                            _durationTimer.cancel();
                                          },
                                        );
                                      }
                                    }
                                  }
                                }
                                setState(() {});
                              },
                              flipOnTouch: _wait ? false : _cardFlips[index],
                              direction: FlipDirection.HORIZONTAL,
                              front: _buildCardFront(),
                              back: _buildCardBack(index),
                            )
                            : _buildCardBack(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3F8EFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.question_mark_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildCardBack(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(_data[index], fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF2D2D2D),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _divider() =>
      Container(height: 36, width: 1, color: Colors.grey.withOpacity(0.2));
}
