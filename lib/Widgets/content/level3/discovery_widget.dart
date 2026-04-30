// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Widgets/kido_action_button.dart';
import 'package:kido/Widgets/next_button.dart';
import '../../../Models/level3/discovery.dart';
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

class _DiscoveryPageState extends State<DiscoveryPage> {
  bool _showNextButton = false;
  double _scale = 1.0;
  double _imageRotation = 0.0;

  void _handleInteraction() {
    HapticFeedback.mediumImpact();

    final String fileName = widget.model.soundPath
        .replaceFirst('assets/audio/', '')
        .replaceFirst('audio/', '');

    AudioService.play(fileName: fileName);

    setState(() {
      _showNextButton = true;
      _scale = 1.15;
      _imageRotation = 0.1;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _scale = 1.0;
          _imageRotation = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final res = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: model.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: GestureDetector(
                  onTap: _handleInteraction,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    tween: Tween(begin: 1.0, end: _scale),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          height: res.localHeight * 0.35,
                          width: res.localWidth * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: _showNextButton ? model.primaryColor : Colors.white,
                              width: 8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: model.primaryColor.withOpacity(0.15),
                                blurRadius: 25 * value,
                                offset: Offset(0, 10 * value),
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      tween: Tween(begin: 0.0, end: _imageRotation),
                      builder: (context, rotation, imageChild) {
                        return Transform.rotate(
                          angle: rotation,
                          child: Padding(
                            padding: EdgeInsets.all(res.isTablet ? 50.0 : 30.0),
                            child: imageChild,
                          ),
                        );
                      },
                      child: Image.asset(model.mainImage, fit: BoxFit.contain),
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
                      width: res.imageWidth(0.45),
                      decoration: BoxDecoration(
                        color: model.primaryColor.withOpacity(_showNextButton ? 0.2 : 0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Image.asset(
                      model.extraImage!,
                      height: res.localHeight * 0.2,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              )
            else
              const Spacer(),

            Padding(
              padding: res.pagePadding.copyWith(top: 0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KidoActionButton(
                    heroTag: "replay_button",
                    icon: Icons.refresh_rounded,
                    color: model.primaryColor,
                    onPressed: _handleInteraction,
                  ),
                  if (_showNextButton)
                    NextButton(
                      color: model.primaryColor,
                      onPressed: widget.onNextPressed,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}