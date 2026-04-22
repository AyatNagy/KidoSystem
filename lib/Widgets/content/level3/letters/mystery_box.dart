// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/level3/discovery.dart';

class MysteryBox extends StatefulWidget {
  final DiscoveryItem model;
  final String boxLottiePath;
  final VoidCallback onComplete;

  const MysteryBox({
    super.key,
    required this.model,
    required this.onComplete,
    this.boxLottiePath = 'assets/lottie/open box.json',
  });

  @override
  State<MysteryBox> createState() => _MysteryBoxState();
}

class _MysteryBoxState extends State<MysteryBox> with TickerProviderStateMixin {
  late final AnimationController _boxController;
  late final AnimationController _idleController;
  late final AudioPlayer _audioPlayer;

  bool _isBoxOpen = false;
  bool _showLetter = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _boxController = AnimationController(vsync: this);

    _boxController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showLetter = true;
        });

        String soundPath = widget.model.soundPath.replaceAll('assets/', '');
        _audioPlayer.play(AssetSource(soundPath));
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          widget.onComplete();
        }
      }
    });

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, widget.model.background],
            radius: 1.2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: _handleTap,
                child: AnimatedBuilder(
                  animation: _idleController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        _isBoxOpen ? 0 : 12 * _idleController.value,
                      ),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_showLetter)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, -130 * value),
                              child: Transform.scale(
                                scale: value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.8),
                                        blurRadius: 30 * value,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    widget.model.mainImage,
                                    height: 160,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      Lottie.asset(
                        widget.boxLottiePath,
                        controller: _boxController,
                        onLoaded:
                            (comp) => _boxController.duration = comp.duration,
                        repeat: false,
                        height: 500,
                        width: 500,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    if (!_isBoxOpen) {
      HapticFeedback.mediumImpact();
      _idleController.stop();
      _audioPlayer.play(AssetSource('audio/pop.mp3'));
      setState(() {
        _isBoxOpen = true;
      });
      _boxController.forward();
    } else {
      setState(() {
        _isBoxOpen = false;
        _showLetter = false;
      });
      _boxController.reset();
      _idleController.repeat(reverse: true);
    }
  }
}
