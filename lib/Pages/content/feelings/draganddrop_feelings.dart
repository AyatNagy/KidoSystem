import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../Widgets/ResponsiveProvider.dart';
import '../../../controllers/feelings_data.dart';

class DraganddropFeelings extends StatefulWidget {
  const DraganddropFeelings({super.key});

  @override
  State<DraganddropFeelings> createState() => _DraganddropFeelingsState();
}

class _DraganddropFeelingsState extends State<DraganddropFeelings> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String currentBoyPhoto = 'assets/images/normal.png';
  bool isReacting = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _triggerReaction(Map<String, String> item) async {
    HapticFeedback.heavyImpact();

    if (item['sound'] != null) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(item['sound']!.replaceFirst('assets/', '')));
    }

    setState(() {
      currentBoyPhoto = item['reaction']!;
      isReacting = true;
      activeChoices.removeWhere((element) => element['id'] == item['id']);
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          currentBoyPhoto = 'assets/images/normal.png';
          isReacting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: DragTarget<Map<String, String>>(
        onWillAccept: (data) => !isReacting,
        onAccept: (item) => _triggerReaction(item),
        builder: (context, candidateData, rejectedData) {
          return Stack(
            children: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: config.localWidth,
                  height: config.localHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 20)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset(
                        currentBoyPhoto,
                        key: ValueKey(currentBoyPhoto),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              if (!isReacting)
                SafeArea(
                  child: Column(
                    children: [
                      _buildResetButton(),
                      const Spacer(),
                      _buildChoiceRow(),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChoiceRow() {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: activeChoices.length,
          itemBuilder: (context, index) {
            final item = activeChoices[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LongPressDraggable<Map<String, String>>(
                delay: Duration.zero,
                data: item,
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildIconCard(item['action']!, true),
                ),
                childWhenDragging: const SizedBox.shrink(),
                child: _buildIconCard(item['action']!, false),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconCard(String imagePath, bool isDragging) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: isDragging ? Colors.orangeAccent : Colors.lightBlueAccent,
            width: 6
        ),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.refresh, size: 60, color: Colors.blueGrey),
        onPressed: () {
          setState(() {
            currentBoyPhoto = 'assets/images/normal.png';
            activeChoices = [
              {'id': '1', 'action': 'assets/images/gift.png', 'reaction': 'assets/images/happy_boy.png', 'sound': 'assets/audio/happy.mp3'},
              {'id': '2', 'action': 'assets/images/medal.png', 'reaction': 'assets/images/proudBoy.png', 'sound': 'assets/audio/clap.mp3'},
              {'id': '3', 'action': 'assets/images/ghost.png', 'reaction': 'assets/images/scared_boy.png', 'sound': 'assets/audio/scream.mp3'},
              {'id': '4', 'action': 'assets/images/broken_heart.png', 'reaction': 'assets/images/sad_boy.png', 'sound': 'assets/audio/sad.wav'},
              {'id': '5', 'action': 'assets/images/popped_ballon.png', 'reaction': 'assets/images/angry_boy.png', 'sound': 'assets/audio/angry.mp3'}
            ];
          });
        },
      ),
    );
  }
}