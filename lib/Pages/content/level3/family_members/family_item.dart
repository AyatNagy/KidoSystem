// ignore_for_file: deprecated_member_use
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
      _player?.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      debugPrint('Error initializing AudioPlayer: $e');
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _bounceAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0.08), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 0.08, end: -0.08), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: -0.08, end: 0.04), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 0.04, end: 0), weight: 25),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _player?.dispose(); // Clean release
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_isPlaying || _player == null) return;

    setState(() => _isPlaying = true);
    _controller.forward(from: 0);

    try {
      String soundFile = widget.sound;
      if (soundFile.startsWith('assets/')) {
        soundFile = soundFile.substring(7);
      }

      debugPrint('Playing audio: $soundFile');
      await _player?.stop();
      await _player?.play(AssetSource(soundFile));
    } catch (e) {
      debugPrint('Sound Error: $e');
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.035;
    final paddingVal = screenWidth * 0.015;

    return GestureDetector(
      onTap: _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingVal * 2,
              vertical: paddingVal,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _isPlaying
                  ? const Color.fromARGB(255, 255, 152, 0)
                  : const Color.fromARGB(255, 116, 90, 46),
              boxShadow: _isPlaying
                  ? [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 152, 0).withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
                  : null,
            ),
            child: Text(
              widget.text,
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