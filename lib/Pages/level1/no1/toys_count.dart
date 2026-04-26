import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Widgets/puls_button.dart';
import 'package:kido/constants.dart';
import '../../../../services/audio_service.dart';
import '../../../Widgets/content/level1/background_colors.dart';
import '../../../Widgets/responsive_provider.dart';
import '../../../data/level1/bee_count.dart';

class ToyRewardPage extends StatefulWidget {
  final VoidCallback? onNext;
  const ToyRewardPage({super.key, this.onNext});

  @override
  State<ToyRewardPage> createState() => _ToyRewardPageState();
}

class _ToyRewardPageState extends State<ToyRewardPage> with TickerProviderStateMixin {
  late final AnimationController _boxController;
  int _toyCount = 0;
  bool _isOpening = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _boxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _boxController.value = 0;
  }

  @override
  void dispose() {
    _boxController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _openBox() async {
    if (_isOpening || _toyCount >= 3) return;
    setState(() => _isOpening = true);
    _boxController.reset();
    await _boxController.forward();

    setState(() {
      _toyCount++;
      _isOpening = false;
    });
    await AudioService.play(fileName: 'numeric_ar/kid-$_toyCount.mp3');
    if (_toyCount == 3) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
      } catch (e) {
        debugPrint("Celebration audio failed: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final sw = responsive.localWidth;
    final sh = responsive.localHeight;
    final positions = BeeCountingData.bearPositions(sw, sh);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundColors(),
          Center(
            child: GestureDetector(
              onTap: _openBox,
              child: Lottie.asset(
                'assets/lottie/gift box.json',
                controller: _boxController,
                width: responsive.imageWidth(0.6),
                onLoaded: (comp) {
                  _boxController.duration = comp.duration;
                  _boxController.forward(from: 0).then((_) => _boxController.stop());
                },
              ),
            ),
          ),

          for (int i = 0; i < _toyCount; i++)
            Positioned(
              left: positions[i].dx - (responsive.imageWidth(0.25) / 2),
              top: positions[i].dy,
              child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    "assets/images/bear-toy.png",
                    width: responsive.imageWidth(0.25),
                    height: responsive.imageHeight(0.15),
                    fit: BoxFit.contain,
                  )
              ),
            ),

          if (_toyCount == 3)
            Positioned.fill(
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  fit: BoxFit.cover,
                ),
            ),
          if (_toyCount == 3)
            Positioned(
              bottom: sh * 0.05,
              right: sw * 0.05,
              child: PulseButton(
                onPressed: () {
                  if (widget.onNext != null) {
                    widget.onNext!();
                  }
                },
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.kidoOrange,
                  size: responsive.imageHeight(0.10),
                ),
              ),
            ),
          ],
      ),
    );
  }
}