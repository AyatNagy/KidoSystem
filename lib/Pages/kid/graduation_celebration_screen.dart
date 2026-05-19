import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kido/Pages/kid/graduation_certifcate_screen.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/audio_service.dart';

/// Full-screen celebration after the level 3 final exam (`post_level3`) is passed.
class GraduationCelebrationScreen extends StatefulWidget {
  final String childName;
  final int score;
  final int total;
  final int stars;

  const GraduationCelebrationScreen({
    super.key,
    required this.childName,
    required this.score,
    required this.total,
    required this.stars,
  });

  @override
  State<GraduationCelebrationScreen> createState() =>
      _GraduationCelebrationScreenState();
}

class _GraduationCelebrationScreenState
    extends State<GraduationCelebrationScreen> {
  late final ConfettiController _confettiTop;
  late final ConfettiController _confettiBurst;

  // Create a local, dedicated player instance to isolate lifecycle contexts on Web
  late final AudioPlayer _localCelebrationPlayer;

  @override
  void initState() {
    super.initState();
    _confettiTop = ConfettiController(duration: const Duration(seconds: 18));
    _confettiBurst = ConfettiController(duration: const Duration(seconds: 14));
    _localCelebrationPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 1. Fire off the visual confetti immediately
      _confettiTop.play();
      _confettiBurst.play();

      // 2. Safely trigger the dedicated audio player
      try {
        // Give the web layout engine an extra moment to settle down
        await Future.delayed(const Duration(milliseconds: 400));

        if (mounted) {
          // Tell the global background audio service to clear out its state
          AudioService.stop();

          // Use the clean local player instance with your proven asset path mapping
          await _localCelebrationPlayer.play(
            AssetSource('audio/graduation.mp3'),
          );
        }
      } catch (e) {
        debugPrint("Web local audio engine encountered a problem: $e");
      }
    });
  }

  @override
  void dispose() {
    // Safely dispose of everything locally to protect against memory leaks
    _localCelebrationPlayer.stop();
    _localCelebrationPlayer.dispose();
    _confettiTop.dispose();
    _confettiBurst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final pastelGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(AppColors.kidoPink, Colors.white, 0.62)!,
        Color.lerp(AppColors.kidoBlue, Colors.white, 0.55)!,
        Color.lerp(AppColors.kidoYellow, Colors.white, 0.5)!,
        Color.lerp(AppColors.kidoGreen, Colors.white, 0.58)!,
      ],
      stops: const [0.0, 0.35, 0.65, 1.0],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: pastelGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // 1. Center Hero Animation Layer
              Positioned.fill(
                top: media.size.height * 0.15,
                bottom: media.size.height * 0.12,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/gif/graduation.gif',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              // 2. Confetti Layers
              Positioned(
                top: media.size.height * 0.02,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: ConfettiWidget(
                    confettiController: _confettiTop,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.04,
                    numberOfParticles: 12,
                    maxBlastForce: 15,
                    minBlastForce: 6,
                    gravity: 0.12,
                    colors: AppColors.kidoColors,
                  ),
                ),
              ),
              Center(
                child: IgnorePointer(
                  child: ConfettiWidget(
                    confettiController: _confettiBurst,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 35,
                    maxBlastForce: 22,
                    minBlastForce: 10,
                    gravity: 0.09,
                    colors: AppColors.kidoColors,
                  ),
                ),
              ),

              // 3. Foreground Text UI & Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Text(
                      'You did it!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: (media.size.width * 0.09).clamp(26.0, 40.0),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        shadows: const [
                          Shadow(
                            color: Colors.white24,
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Graduation day',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: (media.size.width * 0.055).clamp(18.0, 26.0),
                        fontWeight: FontWeight.w600,
                        color: AppColors.purpleMain.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Way to go, ${widget.childName}!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (media.size.width * 0.042).clamp(15.0, 20.0),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 44,
                          color:
                              index < widget.stars
                                  ? AppColors.kidoOrange
                                  : Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.score} / ${widget.total} on your final exam',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (media.size.width * 0.038).clamp(14.0, 18.0),
                        color: AppColors.textDark.withOpacity(0.75),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Spacer(),

                    CustomGradientButton(
                      title: "YAY! LET'S GO!",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (context) => GraduationCertificateScreen(
                                  childName: widget.childName,
                                  score: widget.score,
                                  total: widget.total,
                                ),
                          ),
                        );
                      },
                      width: double.infinity,
                      borderRadius: 30,
                      fontSize: (media.size.width * 0.05).clamp(18.0, 24.0),
                      colors: const [AppColors.kidoPink, AppColors.kidoOrange],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
