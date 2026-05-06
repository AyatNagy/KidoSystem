import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../content/feelings/feelings_levels.dart';

class CloudSelectionPage extends StatelessWidget {
  const CloudSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: SizedBox(
        width: config.localWidth,
        height: config.localHeight,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: const Color(0xFFA9DEF9))),

            _buildFloatingCloud(
              context,
              config: config,
              leftPercent: 0.1,
              topPercent: 0.2,
              imagePath: 'assets/images/selfcare.png',
              destination: const Placeholder(),
              sizeFactor: 0.7,
              bobDelay: 0,
            ),

            _buildFloatingCloud(
              context,
              config: config,
              leftPercent: 0.3,
              topPercent: 0.5,
              imagePath: 'assets/images/feelings.png',
              destination: const TreehouseLevels(),
              sizeFactor: 0.7,
              bobDelay: 500,
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

  Widget _buildFloatingCloud(
    BuildContext context, {
    required dynamic config,
    required double leftPercent,
    required double topPercent,
    required String imagePath,
    required Widget destination,
    required double sizeFactor,
    required int bobDelay,
  }) {
    return Positioned(
      left: config.localWidth * leftPercent,
      top: config.localHeight * topPercent,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 15),
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutSine,
        builder: (context, value, child) {
          return Transform.translate(offset: Offset(0, value), child: child);
        },
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
      ),
    );
  }
}
