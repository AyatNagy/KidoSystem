// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Widgets/content/level1/background_colors.dart';
import 'package:lottie/lottie.dart';
// import 'package:audioplayers/audioplayers.dart'; // ممكن تمسحي ده لو مش محتاجة AudioPlayer هنا
import 'package:kido/Widgets/Buttons/puls_button.dart';
import 'package:kido/constants.dart';
import '../../../../Widgets/responsive_provider.dart';
import '../../../../config/responsive_config.dart';
import '../../../../services/audio_service.dart';

class MonkeyCountingPage extends StatefulWidget {
  final VoidCallback? onNext;
  const MonkeyCountingPage({super.key, this.onNext});

  @override
  State<MonkeyCountingPage> createState() => _MonkeyCountingPageState();
}

class _MonkeyCountingPageState extends State<MonkeyCountingPage> {
  int _count = 0;
  final int _totalBananas = 5;
  // حذفنا الـ _audioPlayer المحلي لأننا هنعتمد على الـ Service
  final List<bool> _isFed = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    // تشغيل صوت أول ما الصفحة تفتح
    _playWelcomeAudio();
  }

  void _playWelcomeAudio() async {
    await AudioService.play(fileName: 'level1/feed_monkey.mp3');
  }

  void _feedMonkey(int index) async {
    if (_isFed[index]) return;

    setState(() {
      _isFed[index] = true;
      _count++;
    });

    await AudioService.play(fileName: 'numeric_ar/kid-$_count.mp3');

    if (_count == _totalBananas) {
      await Future.delayed(const Duration(milliseconds: 700));
      await AudioService.play(fileName: 'yaay.mp3');
    }
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveConfig responsive = ResponsiveProvider.of(context);
    final sw = responsive.localWidth;
    final sh = responsive.localHeight;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundColors(),
          Center(
            child: DragTarget<int>(
              onAccept: (index) => _feedMonkey(index),
              builder: (context, candidateData, rejectedData) {
                return AnimatedScale(
                  scale: candidateData.isNotEmpty ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    "assets/images/monkey.png",
                    height: sh * 0.4,
                  ),
                );
              },
            ),
          ),

          for (int i = 0; i < _totalBananas; i++)
            if (!_isFed[i])
              Positioned(
                bottom: sh * 0.1,
                left: (sw / (_totalBananas + 1)) * (i + 1) - 30,
                child: Draggable<int>(
                  data: i,
                  feedback: _buildBanana(responsive, 1.2),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: _buildBanana(responsive, 1.0),
                  ),
                  child: _buildBanana(responsive, 1.0),
                ),
              ),

          if (_count == _totalBananas) ...[
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: sh * 0.05,
              right: sw * 0.05,
              child: PulseButton(
                onPressed: widget.onNext ?? () {},
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.kidoOrange,
                  size: responsive.imageHeight(0.10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBanana(ResponsiveConfig responsive, double scale) {
    return Transform.scale(
      scale: scale,
      child: Image.asset(
        "assets/images/fruits/banana.gif",
        width: responsive.imageWidth(0.15),
        height: responsive.imageHeight(0.1),
      ),
    );
  }
}
