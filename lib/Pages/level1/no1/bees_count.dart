import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Widgets/Buttons/puls_button.dart';
import 'package:kido/constants.dart';
import '../../../../services/audio_service.dart';
import '../../../Widgets/content/level1/background_colors.dart';
import '../../../Widgets/content/level1/no1/bee_count.dart';
import '../../../Widgets/responsive_provider.dart';
import '../../../data/level1/bee_count.dart';

class BeeCountingPage extends StatefulWidget {
  final VoidCallback? onNext;
  const BeeCountingPage({super.key, this.onNext});

  @override
  State<BeeCountingPage> createState() => _BeeCountingPageState();
}

class _BeeCountingPageState extends State<BeeCountingPage> with TickerProviderStateMixin {
  int _count = 0;
  bool _isAnimating = false;
  bool _hasWon = false;
  final AudioPlayer _effectPlayer = AudioPlayer();
  late AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _moveController.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (_isAnimating || _count >= 7) return;

    setState(() => _isAnimating = true);
    HapticFeedback.lightImpact();
    _moveController.reset();
    await _moveController.forward();

    setState(() {
      _count++;
      _isAnimating = false;
    });

    await AudioService.play(fileName: 'numeric_ar/kid-$_count.mp3');

    if (_count == 7) {
      setState(() => _hasWon = true);
      await Future.delayed(const Duration(milliseconds: 700));
      _effectPlayer.play(AssetSource('audio/yaay.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final double sw = responsive.localWidth;
    final double sh = responsive.localHeight;
    final landingPositions = BeeCountingData.beeCount(sw, sh);

    return Scaffold(
      body: Stack(
          children: [
            const BackgroundColors(),
            Positioned(
              top: sh * 0.12,
              left: sw * 0.5 - responsive.imageWidth(0.25),
              child: AnimatedScale(
                scale: _isAnimating ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  "assets/images/flower.png",
                  height: responsive.imageHeight(0.25),
                  width: responsive.imageWidth(0.50),
                ),
              ),
            ),

            for (int i = 0; i < _count; i++)
              Positioned(
                left: landingPositions[i].dx,
                top: landingPositions[i].dy,
                child: Image.asset(
                    "assets/images/bee.png",
                    height: responsive.imageHeight(0.06),
                    width: responsive.imageWidth(0.12)),
              ),

            if (_isAnimating)
              AnimatedBuilder(
                animation: _moveController,
                builder: (context, child) => FlyingBee(
                  value: _moveController.value,
                  start: Offset(responsive.imageWidth(0.10), sh - responsive.imageHeight(0.25)),
                  end: landingPositions[_count],
                  width: responsive.imageWidth(0.15),
                  height: responsive.imageHeight(0.08),
                ),
              ),

            Positioned(
              bottom: sh * 0.05,
              left: sw * 0.01,
              child: GestureDetector(
                onTap: _handleTap,
                child: SizedBox(
                  width: responsive.imageWidth(0.85),
                  height: responsive.imageHeight(0.55),
                  child: Image.asset(
                      "assets/images/bee-house.gif",
                      fit: BoxFit.contain
                  ),
                ),
              ),
            ),

            if (_hasWon)
              IgnorePointer(
                child: Positioned.fill(
                  child: Lottie.asset(
                      'assets/lottie/confetti.json',
                      fit: BoxFit.cover
                  ),
                ),
              ),

            if (_hasWon)
              Positioned(
                bottom: sh * 0.05,
                right: sw * 0.05,
                child: PulseButton(
                  onPressed: widget.onNext!,
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