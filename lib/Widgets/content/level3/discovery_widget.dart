// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Models/level3/discovery.dart';
import '../../../Widgets/puls_button.dart';
import '../../../constants.dart';

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

class _DiscoveryPageState extends State<DiscoveryPage> {
  bool _isTapped = false;
  bool _showNextButton = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playSound() async {
    try {
      String path = widget.model.soundPath.replaceFirst('assets/', '');
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleInteraction() {
    HapticFeedback.heavyImpact();
    _playSound();
    if (!_isTapped) {
      setState(() {
        _isTapped = true;
        _showNextButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = widget.model;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: GestureDetector(
                  onTap: _handleInteraction,
                  child: AnimatedScale(
                    scale: _isTapped ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                    child: Container(
                      height: size.height * 0.35,
                      width: size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: _isTapped ? model.primaryColor : Colors.white,
                          width: 8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: model.primaryColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Image.asset(
                          model.mainImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (model.extraImage != null)
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: size.width * 0.45,
                      decoration: BoxDecoration(
                        color: model.primaryColor.withOpacity(
                          _isTapped ? 0.2 : 0.05,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Image.asset(
                      model.extraImage!,
                      height: size.height * 0.2,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              )
            else
              const Spacer(),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _handleInteraction,
                      icon: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: model.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (_showNextButton)
                      PulseButton(
                        onPressed: widget.onNextPressed,
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 90,
                          color: widget.model.primaryColor,
                        ),
                      )
                    else
                      const SizedBox(width: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
