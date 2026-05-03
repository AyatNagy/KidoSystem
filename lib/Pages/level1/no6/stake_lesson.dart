// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Widgets/content/level1/background_colors.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import '../../../Widgets/content/level1/stack_painter.dart';
import '../../../data/level1/stickes.dart';

class StakeDrag extends StatefulWidget {
  final VoidCallback? onNext;
  const StakeDrag({super.key, this.onNext});

  @override
  State<StakeDrag> createState() => _StakesDragState();
}

class _StakesDragState extends State<StakeDrag> {
  final Map<int, bool> _isCompleted = {0: false, 1: false, 2: false};
  bool _hasWon = false;

  void _checkWin() {
    if (_isCompleted.values.every((v) => v == true)) {
      setState(() => _hasWon = true);
      AudioService.play(fileName: 'yaay.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveProvider.of(context);
    final sh = res.localHeight;
    final sw = res.localWidth;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundColors(),
          Positioned(
            top: sh * 0.1,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(3, (index) =>
                      Expanded(child: _buildStakeTarget(index, res))
                  ),
                ),
                Container(
                  width: sw * 0.9,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: sw * 0.8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(40),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: sh * 0.22,
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: stickes.map((item) {
                  if (_isCompleted[item['id']]!) return const Expanded(child: SizedBox());
                  return Expanded(
                    child: Draggable<int>(
                      data: item['id'],
                      feedback: Transform.scale(
                        scale: 1.2,
                        child: Image.asset(item['image'], width: sw * 0.18),
                      ),
                      childWhenDragging: Opacity(opacity: 0.1, child: Image.asset(item['image'], width: sw * 0.15)),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 2),
                        builder: (context, double val, child) {
                          return Transform.translate(
                            offset: Offset(0, 4 * (val > 0.5 ? 1 - val : val)),
                            child: Image.asset(item['image'], width: sw * 0.15),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (_hasWon) Positioned.fill(child: Lottie.asset('assets/lottie/confetti.json', fit: BoxFit.cover)),
        ],
      ),
    );
  }

  Widget _buildStakeTarget(int index, res) {
    return DragTarget<int>(
      onWillAccept: (data) => data == index && !_isCompleted[index]!,
      onAccept: (data) {
        setState(() => _isCompleted[index] = true);
        AudioService.play(fileName: 'win.wav');
        HapticFeedback.mediumImpact();
        _checkWin();
      },
      builder: (context, candidateData, rejectedData) {
        bool isFilled = _isCompleted[index]!;
        bool isHovering = candidateData.isNotEmpty;

        return Column(
          children: [
            SizedBox(
              width: res.localWidth * 0.25,
              height: res.localHeight * 0.38,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: Size(res.localWidth * 0.25, res.localHeight * 0.38),
                    painter: KidoStakePainter(
                      color: AppColors.kidoColors[index],
                      isFront: false,
                      isHovering: isHovering,
                    ),
                  ),
                  if (isFilled)
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.elasticOut,
                      builder: (context, double val, child) {
                        return Positioned(
                          bottom: 10 + (val * 5),
                          child: Transform(
                            alignment: Alignment.bottomCenter,
                            transform: Matrix4.identity()
                              ..translate(val * 5, 0.0)
                              ..rotateZ(index % 2 == 0 ? 0.7 : -0.7),
                            child: Image.asset(
                              stickes[index]['image'],
                              width: res.localWidth * 0.16,
                            ),
                          ),
                        );
                      },
                    ),
                  CustomPaint(
                    size: Size(res.localWidth * 0.25, res.localHeight * 0.38),
                    painter: KidoStakePainter(
                      color: AppColors.kidoColors[index],
                      isFront: true,
                      isHovering: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}