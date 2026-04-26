// ignore_for_file: deprecated_member_use
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/draganddrop_question.dart';
import '../../../curcle_painter.dart';
import '../../../draganddrop.dart';
import '../../../puls_button.dart';

class DragDropLessonPage extends StatefulWidget {
  final DragDropQuestion questionData;
  final VoidCallback onNext;
  final Color firstColor;
  final Color secondColor;
  final String letterAudio;

  const DragDropLessonPage({
    super.key,
    required this.questionData,
    required this.onNext,
    required this.letterAudio,
    this.firstColor = const Color(0xFFE0F7FA),
    this.secondColor = const Color(0xFFB2EBF2),
  });

  @override
  State<DragDropLessonPage> createState() => _DragDropLessonPageState();
}

class _DragDropLessonPageState extends State<DragDropLessonPage> {
  bool _isFinished = false;
  late final AudioPlayer _audioPlayer;

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

  void _playSound(String path) async {
    String cleanPath = path.replaceAll('assets/', '');
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(cleanPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.firstColor, widget.secondColor],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -40,
            child: _buildBlob(150, Colors.white.withOpacity(0.4)),
          ),
          Positioned(
            top: 250,
            right: -20,
            child: _buildBlob(100, Colors.white.withOpacity(0.3)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              child: CustomPaint(painter: CurvePainter()),
            ),
          ),
          SafeArea(
            child: DragDropWidget(
              question: widget.questionData,
              onDragStart: () => _playSound(widget.letterAudio),
              onWrongDrop: () {
                HapticFeedback.vibrate();
                _playSound('audio/wrong.mp3');
              },
              onAnswered: (answers) {
                if (answers.length == widget.questionData.targets.length) {
                  HapticFeedback.heavyImpact();
                  _playSound('audio/yaay.mp3');
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    _playSound(widget.letterAudio);
                  });
                  setState(() {
                    _isFinished = true;
                  });
                }
              },
            ),
          ),
          if (_isFinished)
            IgnorePointer(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                repeat: false,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (_isFinished)
            Positioned(
              bottom: 50,
              right: 40,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: PulseButton(
                      onPressed: widget.onNext,
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        size: 90,
                        color: widget.firstColor,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}