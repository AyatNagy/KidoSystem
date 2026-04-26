// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../constants.dart';
import '../../../../data/level1/countToys.dart';
import '../../../../services/audio_service.dart';

class CreativeKidoDrag extends StatefulWidget {
  const CreativeKidoDrag({super.key});

  @override
  State<CreativeKidoDrag> createState() => _CreativeKidoDragState();
}

class _CreativeKidoDragState extends State<CreativeKidoDrag> {
  int _count = 0;
  final AudioPlayer _winPlayer = AudioPlayer();
  bool _hasWon = false;

  @override
  void dispose() {
    _winPlayer.dispose();
    super.dispose();
  }

  String _toArabic(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String input = number.toString();
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }

  Future<void> _handleSuccess(int index) async {
    setState(() => _count++);
    await AudioService.play(fileName: 'numeric_ar/kid-$_count.mp3');
    if (_count == pals.length && !_hasWon) {
      _hasWon = true;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 800));
      _playWinSequence();
    }
  }

  void _playWinSequence() async {
    try {
      await _winPlayer.play(AssetSource('audio/yaay.mp3'));
    } catch (e) {
      debugPrint("Win sound error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF1F8E9)],
          ),
        ),
        child: Stack(
          children: [
            _buildTargetGrid(),
            Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: _buildArabicCounter()
            ),
            _buildToySource(),
            if (_hasWon) Positioned.fill(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildArabicCounter() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Text(
            _toArabic(_count),
            key: ValueKey(_count),
            style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: AppColors.kidoRed
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetGrid() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Wrap(
          spacing: 25, runSpacing: 25,
          alignment: WrapAlignment.center,
          children: List.generate(
              pals.length, (index) => _buildSingleTarget(index)),
        ),
      ),
    );
  }

  Widget _buildSingleTarget(int index) {
    return DragTarget<int>(
      onWillAccept: (data) => data == index,
      onAccept: (data) {
        HapticFeedback.mediumImpact();
        _handleSuccess(data);
      },
      builder: (context, candidate, _) {
        final isHovering = candidate.isNotEmpty;
        final isFilled = _count > index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: isHovering ? Colors.greenAccent : Colors.white,
                width: 4),
            color: isHovering ? Colors.white : Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: isFilled
                ? Icon(
                pals[index]['icon'], color: pals[index]['color'], size: 50)
                : Icon(
                Icons.add_circle_outline, color: Colors.white.withOpacity(0.5),
                size: 40),
          ),
        );
      },
    );
  }

  Widget _buildToySource() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(45)),
        child: Wrap(
          spacing: 15, runSpacing: 15,
          alignment: WrapAlignment.center,
          children: List.generate(pals.length, (index) {
            if (_count > index) return const SizedBox(width: 75, height: 75);
            return Draggable<int>(
              data: index,
              feedback: _ToyIcon(index: index, isDragging: true),
              childWhenDragging: const Opacity(
                  opacity: 0, child: _ToyIcon(index: 0)),
              onDragStarted: () => HapticFeedback.lightImpact(),
              child: _ToyIcon(index: index),
            );
          }),
        ),
      ),
    );
  }
}

class _ToyIcon extends StatelessWidget {
  final int index;
  final bool isDragging;
  const _ToyIcon({required this.index, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    final pal = pals[index];
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 75, height: 75,
        decoration: BoxDecoration(
          color: pal['color'],
          borderRadius: BorderRadius.circular(22),
          boxShadow: [if (isDragging) const BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))],
        ),
        child: Icon(pal['icon'], color: Colors.white, size: 40),
      ),
    );
  }
}