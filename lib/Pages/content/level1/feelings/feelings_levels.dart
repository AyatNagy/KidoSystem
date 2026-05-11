import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'draganddrop_feelings.dart';
import 'emotion_page_view.dart';

class TreehouseLevels extends StatelessWidget {
  const TreehouseLevels({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: SizedBox(
        width: config.localWidth,
        height: config.localHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/tree-levels.png',
                fit: BoxFit.cover,
              ),
            ),

            _buildResponsiveLevel(
              context,
              config: config,
              leftPercent: 0.01,
              topPercent: 0.7,
              imagePath: 'assets/images/level1-feelings.png',
              destination: const DraganddropFeelings(),
              sizeFactor: 0.3,
            ),

            _buildResponsiveLevel(
              context,
              config: config,
              leftPercent: 0.65,
              topPercent: 0.6,
              imagePath: 'assets/images/level2-feelings.png',
              destination: const EmotionsPageView(),
              sizeFactor: 0.32,
            ),

            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveLevel(
    BuildContext context, {
    required dynamic config,
    required double leftPercent,
    required double topPercent,
    required String imagePath,
    required Widget destination,
    required double sizeFactor,
  }) {
    return Positioned(
      left: config.localWidth * leftPercent,
      top: config.localHeight * topPercent,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: SizedBox(
          width: config.localWidth * sizeFactor,
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
