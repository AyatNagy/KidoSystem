import 'package:flutter/material.dart';
import 'package:kido/Models/sense_data.dart';
import 'package:kido/Widgets/content/animated_feature.dart';

class SenseFaceView extends StatelessWidget {
  final SenseData data;
  final double width;
  final double height;
  final bool isPlaying;
  final String faceImage;

  const SenseFaceView({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    required this.faceImage,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(faceImage, fit: BoxFit.contain)),
        Positioned(
          top: height * data.topFactor,
          left: width * data.leftFactor,
          child: AnimatedFeature(
            image: data.featureImage,
            width: width * data.widthFactor,
            isPlaying: isPlaying,
          ),
        ),
      ],
    );
  }
}
