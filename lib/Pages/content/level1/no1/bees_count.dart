import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kido/Widgets/Buttons/puls_button.dart';
import 'package:kido/constants.dart';
import '../../../../Widgets/content/level1/background_colors.dart';
import '../../../../Widgets/content/level1/no1/bee_count.dart';
import '../../../../Widgets/responsive_provider.dart';
import '../../../../data/level1/bee_count.dart';
import '../../../../services/audio_service.dart';

class BeeCountingPage extends StatefulWidget {
  final VoidCallback? onNext;
  const BeeCountingPage({super.key, this.onNext});

  @override
  State<BeeCountingPage> createState() => _BeeCountingPageState();
}

class _BeeCountingPageState extends State<BeeCountingPage>
    with TickerProviderStateMixin {
  int _count = 0;
  bool _isAnimating = false;
  bool _hasWon = false;
  // حذفنا الـ Player المحلي لاستخدام الـ AudioService
  late AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // تشغيل صوت التعليمات عند البداية
    AudioService.play(fileName: 'instructions/bee_intro.mp3');
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    // الشرط ده مهم جداً: بيمنع التفاعل لو النحلة بتتحرك (Animating)
    // أو لو فيه صوت لسه شغال (عشان نضمن الترتيب)
    if (_isAnimating || _count >= 4) return;

    setState(() => _isAnimating = true);

    // 1. تشغيل الأنميشن الأول
    _moveController.reset();
    await _moveController.forward();

    // 2. زيادة العداد بعد وصول النحلة
    setState(() {
      _count++;
      _isAnimating = false;
    });

    // 3. تشغيل صوت الرقم واستخدامه كـ "حاجز" زمني
    // الـ await هنا بتخلي الميثود متخلصش غير لما الصوت يخلص
    await AudioService.play(fileName: 'numeric_ar/kid-$_count.mp3');

    // 4. لو وصلنا للعدد النهائي
    if (_count == 4) {
      setState(() => _hasWon = true);
      await Future.delayed(const Duration(milliseconds: 500));
      await AudioService.play(fileName: 'yaay.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final double sw = responsive.localWidth;
    final double sh = responsive.localHeight;
    final landingPositions = BeeCountingData.beeCount(sw, sh);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundColors(),

          // الوردة
          Positioned(
            top: sh * 0.12,
            left: sw * 0.5 - responsive.imageWidth(0.25),
            child: AnimatedScale(
              scale: _isAnimating ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                "assets/images/flower.png",
                height: responsive.imageHeight(0.25),
                width: responsive.imageWidth(0.50),
              ),
            ),
          ),

          // النحل اللي استقر مكانه
          for (int i = 0; i < _count; i++)
            Positioned(
              left: landingPositions[i].dx,
              top: landingPositions[i].dy,
              child: Image.asset(
                "assets/images/bee.png",
                height: responsive.imageHeight(0.06),
                width: responsive.imageWidth(0.12),
              ),
            ),

          // النحلة اللي بتطير حالياً
          if (_isAnimating)
            AnimatedBuilder(
              animation: _moveController,
              builder:
                  (context, child) => FlyingBee(
                    value: _moveController.value,
                    start: Offset(
                      responsive.imageWidth(0.10),
                      sh - responsive.imageHeight(0.25),
                    ),
                    end:
                        landingPositions[_count], // بتطير للمكان التالي بناءً على الـ _count الحالي
                    width: responsive.imageWidth(0.15),
                    height: responsive.imageHeight(0.08),
                  ),
            ),

          // بيت النحل (مساحة الضغط)
          Positioned(
            bottom: sh * 0.05,
            left: sw * 0.01,
            child: GestureDetector(
              onTap: _handleTap,
              child: SizedBox(
                width: responsive.imageWidth(0.85),
                height: responsive.imageHeight(0.55),
                child: Image.asset(
                  "assets/images/bee-house.gif",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // تأثير الفوز
          if (_hasWon)
            IgnorePointer(
              child: Positioned.fill(
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // زر التالي
          if (_hasWon)
            Positioned(
              bottom: sh * 0.05,
              right: sw * 0.05,
              child: PulseButton(
                onPressed: widget.onNext!,
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.kidoOrange,
                  size: responsive.imageHeight(0.10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
