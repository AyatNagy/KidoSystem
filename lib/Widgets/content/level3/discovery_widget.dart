// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Widgets/Buttons/replay_button.dart';
import 'package:kido/constants.dart';
import '../../../Models/level3/discovery.dart';
import '../../../Pages/level3/vegetables/vegetable_sound.dart';
import '../../../services/audio_service.dart';
import '../../responsive_provider.dart';

class DiscoveryPage extends StatefulWidget {
  final DiscoveryItem model;
  final VoidCallback onNextPressed;

  const DiscoveryPage({
    super.key,
    required this.model,
    required this.onNextPressed,
  });

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bgController;
  bool _isSpeaking = false;

  List<Color> get _grad => [
    widget.model.primaryColor,
    widget.model.primaryColor.withOpacity(0.7),
    widget.model.background,
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _handleInteraction();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _handleInteraction() {
    if (_isSpeaking) return;

    setState(() => _isSpeaking = true);
    HapticFeedback.mediumImpact();
    _pulseController.repeat(reverse: true);

    final String fileName = widget.model.soundPath
        .replaceFirst('assets/audio/', '')
        .replaceFirst('audio/', '');

    AudioService.play(fileName: fileName);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSpeaking = false);
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final res = ResponsiveProvider.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(
                    -0.3 + _bgController.value * 0.6,
                    -0.4 + _bgController.value * 0.4,
                  ),
                  radius: 1.4,
                  colors: [
                    _grad[0].withOpacity(0.4),
                    _grad[1].withOpacity(0.3),
                    _grad[2].withOpacity(0.8),
                    AppColors.bgColor,
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          Positioned(top: -80, left: -80, child: Blob(color: _grad[0], size: 260)),
          Positioned(bottom: -60, right: -60, child: Blob(color: _grad[1], size: 220)),

          if (model.extraImage != null)
            Positioned(
              left: 0.75 * size.width,
              top: 0.20 * size.height,
              child: Image.asset(
                model.extraImage!,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: 0, end: -30, duration: 2.seconds, curve: Curves.easeInOut,)
                  .rotate(begin: -0.05, end: 0.05, duration: 3.seconds,)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds,),
            ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44, height: 44,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: _grad[0], size: 20),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _handleInteraction,
                      child: AnimatedSwitcher(
                        duration: 500.ms,
                        child: Image.asset(
                          model.mainImage,
                          key: ValueKey(model.mainImage),
                          width: size.width * 0.8,
                          fit: BoxFit.contain,
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 2.seconds)
                            .moveY(begin: 8, end: -8, duration: 2.seconds),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: res.pagePadding.copyWith(top: 0, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.2).animate(
                          CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
                        ),
                        child: ReplayButton(
                            color: model.primaryColor,
                            onPressed: _handleInteraction
                        ),
                      ),
                      NextButton(
                        color: model.primaryColor,
                        shadowColor: model.primaryColor.withOpacity(0.9),
                        onPressed: widget.onNextPressed,
                      )
                    ],
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