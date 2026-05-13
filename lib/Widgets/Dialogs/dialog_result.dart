// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../config/progress.dart';
import '../../utils/placement_level.dart';

class ExamResultDialog {
  static Future<dynamic> show(
      BuildContext context, {
        required int score,
        required int total,
        required String examId,
        required bool onboardingPlacement,
      }) async {
    final double percentage = score / total;
    bool passed = percentage >= 0.70;
    int stars = _calculateStars(percentage);
    int nextLevelToUnlock = 1;
    String unlockMessage = "Keep practicing to unlock new levels!";
    if (onboardingPlacement) {
      nextLevelToUnlock = placementLevelFromScoreFraction(percentage);
      await ProgressManager.unlockUpTo(nextLevelToUnlock);
      passed = true;
      stars = nextLevelToUnlock >= 3 ? 3 : (nextLevelToUnlock == 2 ? 2 : 1);
      unlockMessage = "Your level is set to $nextLevelToUnlock!";
    } else if (passed) {
      if (examId == "exam1") {
        nextLevelToUnlock = 2;
        unlockMessage = "Level 1 & 2 UNLOCKED!";
        await ProgressManager.unlockUpTo(2);
      } else if (examId == "exam2") {
        nextLevelToUnlock = 3;
        unlockMessage = "Level 1, 2, & 3 UNLOCKED!";
        await ProgressManager.unlockUpTo(3);
      }
    }

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.bounceOut.transform(anim1.value),
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: _DialogContent(
                passed: passed,
                score: score,
                total: total,
                stars: stars,
                unlockMessage: unlockMessage,
                onDone: () {
                  Navigator.pop(context);
                  Navigator.pop(context, nextLevelToUnlock);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static int _calculateStars(double percentage) {
    if (percentage >= 0.85) return 3;
    if (percentage >= 0.70) return 2;
    if (percentage >= 0.50) return 1;
    return 0;
  }
}


class _DialogContent extends StatelessWidget {
  final bool passed;
  final int score;
  final int total;
  final int stars;
  final String unlockMessage;
  final VoidCallback onDone;

  const _DialogContent({
    required this.passed,
    required this.score,
    required this.total,
    required this.stars,
    required this.unlockMessage,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.fromLTRB(24, 100, 24, 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColors.kidoPink.withOpacity(0.2), width: 4),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
              const BoxShadow(color: Color(0xFFF3F3F3), offset: Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                passed ? "AWESOME!" : "GOOD TRY!",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.kidoPink, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              _ScorePill(score: score, total: total),
              const SizedBox(height: 25),
              _StarRating(stars: stars),
              const SizedBox(height: 25),
              Text(
                unlockMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.blueGrey.shade700),
              ),
              const SizedBox(height: 35),
              _ContinueButton(onPressed: onDone),
            ],
          ),
        ),
        _FloatingMascot(passed: passed),
      ],
    );
  }
}

class _ScorePill extends StatelessWidget {
  final int score, total;
  const _ScorePill({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(color: AppColors.kidoOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text("Score: $score / $total", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.kidoOrange)),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int stars;
  const _StarRating({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool active = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Transform.rotate(
            angle: index == 1 ? 0 : (index == 0 ? -0.15 : 0.15),
            child: Icon(
                Icons.stars_rounded,
                size: index == 1 ? 75 : 60,
                color: active ? AppColors.kidoOrange : Colors.grey.shade200
            ),
          ),
        );
      }),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.kidoPink, Color(0xFFFF7BB0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          alignment: Alignment.center,
          child: const Text("CONTINUE ➔", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}

class _FloatingMascot extends StatelessWidget {
  final bool passed;
  const _FloatingMascot({required this.passed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -15,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 6),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: CircleAvatar(
          radius: 75,
          backgroundColor: const Color(0xFFF0F9FF),
          child: ClipOval(child: Image.asset(passed ? 'assets/gif/finish.gif' : 'assets/gif/not-finish.gif', fit: BoxFit.cover)),
        ),
      ),
    );
  }
}