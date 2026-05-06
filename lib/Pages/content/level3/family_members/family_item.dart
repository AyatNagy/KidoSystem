import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FamilyItem extends StatefulWidget {
  final String sound;
  final String image;
  final String text;
  final double imageSize;

  const FamilyItem({
    super.key,
    required this.image,
    required this.text,
    required this.sound,
    required this.imageSize,
  });

  @override
  State<FamilyItem> createState() => _FamilyItemState();
}

class _FamilyItemState extends State<FamilyItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  AudioPlayer? _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    try {
      _player = AudioPlayer();
    } catch (e) {
      debugPrint('Error initializing AudioPlayer: $e');
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.8,
          end: 0.85,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.85,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _bounceAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0.1), weight: 25),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: -0.1),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.1, end: 0.06),
        weight: 25,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 0.06, end: 0), weight: 25),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
      _player?.release();
    } catch (e) {
      debugPrint('Error in dispose: $e');
    }
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_isPlaying || _player == null) return;

    if (!mounted) return;
    setState(() => _isPlaying = true);

    _controller.forward(from: 0);

    try {
      // Remove 'assets/' prefix if present
      String soundFile = widget.sound;
      if (soundFile.startsWith('assets/')) {
        soundFile = soundFile.substring(7);
      }

      debugPrint('Playing sound from: $soundFile');

      // Try using setSourceUrl for better web compatibility
      await _player?.play(AssetSource(soundFile));

      await Future.delayed(const Duration(milliseconds: 1500));
    } catch (e) {
      debugPrint('Sound Error: $e');
      // Try alternative method for web
      try {
        String soundFile = widget.sound;
        if (soundFile.startsWith('assets/')) {
          soundFile = soundFile.substring(7);
        }
        await _player?.setSource(AssetSource(soundFile));
        await _player?.resume();
        await Future.delayed(const Duration(milliseconds: 1500));
      } catch (e2) {
        debugPrint('Alternative audio method failed: $e2');
        await Future.delayed(const Duration(milliseconds: 700));
      }
    }

    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.030;
    final paddingVal = screenWidth * 0.013;

    return GestureDetector(
      onTap: _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _bounceAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  widget.image,
                  width: widget.imageSize,
                  height: widget.imageSize,
                  fit: BoxFit.contain,
                ),
              ),
              if (_isPlaying)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      bottom: -15,
                      child: Icon(
                        Icons.volume_up,
                        size: 35,
                        color: const Color.fromARGB(255, 255, 193, 7),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingVal * 2,
              vertical: paddingVal,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  _isPlaying
                      ? const Color.fromARGB(255, 255, 152, 0)
                      : const Color.fromARGB(255, 116, 90, 46),
              boxShadow:
                  _isPlaying
                      ? [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            255,
                            152,
                            0,
                          ).withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                      : null,
            ),
            child: Text(
              _isPlaying ? '🔊 ${widget.text}' : widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSound(String assetPath) async {
    await _player.play(AssetSource(assetPath));
  }
}
