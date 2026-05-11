// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Widgets/content/level1/background_colors.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import '../../../../Widgets/Buttons/next_button.dart';
import '../../../../Widgets/content/level1/no6/lesson1.dart';
import '../../../../data/content/level1/count_toys.dart';

class StakesDrag extends StatefulWidget {
  final VoidCallback? onNext;

  const StakesDrag({super.key, this.onNext});

  @override
  State<StakesDrag> createState() => _StakesDragState();
}

class _StakesDragState extends State<StakesDrag> {
  final List<int> _completedIndices = [];
  bool _hasWon = false;

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  Future<void> _handleSuccess(int index) async {
    if (_completedIndices.contains(index)) return;

    setState(() {
      _completedIndices.add(index);
    });

    await AudioService.play(fileName: 'win.wav');

    if (_completedIndices.length == pals.length && !_hasWon) {
      setState(() => _hasWon = true);
      await Future.delayed(const Duration(milliseconds: 500));
      await AudioService.play(fileName: 'yaay.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final sw = responsive.localWidth;
    final sh = responsive.localHeight;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundColors(),
          Positioned(
            top: sh * 0.1,
            left: 0,
            right: 0,
            child: _buildTargetGrid(responsive),
          ),
          _buildToySource(responsive),
          if (_hasWon) ...[
            Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),
            Positioned(
              bottom: sh * 0.05,
              right: sw * 0.05,
              child: NextButton(
                color: AppColors.kidoOrange,
                onPressed: () {
                  if (widget.onNext != null) {
                    widget.onNext!();
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTargetGrid(ResponsiveConfig responsive) {
    return Center(
      child: Wrap(
        spacing: 85,
        runSpacing: 55,
        alignment: WrapAlignment.center,
        children: List.generate(
          pals.length,
              (index) => _buildSingleTarget(index, responsive),
        ),
      ),
    );
  }

  Widget _buildSingleTarget(int index, ResponsiveConfig responsive) {
    return DragTarget<int>(
      onWillAccept: (data) {
        if (_completedIndices.contains(index)) return false;
        if (data != index) {
          AudioService.play(fileName: 'wrong.mp3');
          return false;
        }
        return true;
      },
      onAccept: (data) {
        _handleSuccess(data);
      },
      builder: (context, candidate, rejected) {
        final isHovering = candidate.isNotEmpty;
        final isFilled = _completedIndices.contains(index);
        final double size = responsive.imageWidth(0.26);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isHovering ? AppColors.kidoGreen : Colors.brown.withOpacity(0.5),
              width: 4,
            ),
            color: isHovering ? Colors.white : Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: Icon(
              pals[index]['icon'],
              color: isFilled ? pals[index]['color'] : Colors.brown.withOpacity(0.3),
              size: size * 0.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildToySource(ResponsiveConfig responsive) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: responsive.localHeight * 0.22,
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Wrap(
          spacing: 15,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(pals.length, (index) {
            final double sizew = responsive.imageWidth(0.18);

            if (_completedIndices.contains(index)) {
              return SizedBox(width: sizew, height: sizew);
            }

            return Draggable<int>(
              data: index,
              feedback: ToyIcon(index: index, isDragging: true, size: sizew * 1.1),
              childWhenDragging: Opacity(
                opacity: 0,
                child: ToyIcon(index: index, size: sizew),
              ),
              onDragStarted: () => HapticFeedback.lightImpact(),
              child: ToyIcon(index: index, size: sizew),
            );
          }),
        ),
      ),
    );
  }
}