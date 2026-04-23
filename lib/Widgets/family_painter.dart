// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// --- 1. الرسام (The Painter) للأيقونة العائلية ---
class FamilyPainter extends CustomPainter {
  final Color primaryColor;
  final Color detailColor;

  FamilyPainter({
    // تدرج لوني أزرق سماوي للعائلة (Sky Blue)
    this.primaryColor = const Color(0xFF64B5F6), // أزرق سماوي فاتح ولطيف
    this.detailColor = const Color(0xFF1976D2), // أزرق سماوي أعمق للعمق
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double depthOffset = width * 0.08; // مقدار العمق

    final paintFront =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;

    final paintDepth =
        Paint()
          ..color = detailColor
          ..style = PaintingStyle.fill;

    // --- رسم العمق أولاً (الظل الجانبي والخلفي) للأيقونة ---
    Path pathDepth = Path();

    // شكل الشخص الكبير (الخلفي)
    pathDepth.moveTo(
      width * 0.35 + depthOffset,
      height * 0.15 + depthOffset,
    ); // قمة الرأس
    pathDepth.quadraticBezierTo(
      width * 0.5 + depthOffset,
      height * 0.05 + depthOffset,
      width * 0.65 + depthOffset,
      height * 0.15 + depthOffset,
    ); // منحنى الرأس
    pathDepth.lineTo(
      width * 0.65 + depthOffset,
      height * 0.5 + depthOffset,
    ); // جانب الكتف
    pathDepth.lineTo(
      width * 0.35 + depthOffset,
      height * 0.5 + depthOffset,
    ); // جانب الكتف الأيسر
    pathDepth.close();

    // شكل الشخص الأصغر (الخلفي)
    pathDepth.moveTo(
      width * 0.55 + depthOffset,
      height * 0.45 + depthOffset,
    ); // قمة الرأس الصغير
    pathDepth.quadraticBezierTo(
      width * 0.65 + depthOffset,
      height * 0.35 + depthOffset,
      width * 0.75 + depthOffset,
      height * 0.45 + depthOffset,
    ); // منحنى الرأس الصغير
    pathDepth.lineTo(
      width * 0.75 + depthOffset,
      height * 0.75 + depthOffset,
    ); // جانب الكتف الصغير
    pathDepth.lineTo(
      width * 0.55 + depthOffset,
      height * 0.75 + depthOffset,
    ); // جانب الكتف الصغير الأيسر
    pathDepth.close();

    canvas.drawPath(pathDepth, paintDepth);

    // --- رسم الوجه الأمامي للأيقونة العائلية ---
    Path pathFront = Path();

    // شكل الشخص الكبير (الأمامي) - شكل بسيط يشبه الحرف U المقلوب
    pathFront.moveTo(width * 0.35, height * 0.15); // قمة الرأس الأيسر
    pathFront.quadraticBezierTo(
      width * 0.5,
      height * 0.05,
      width * 0.65,
      height * 0.15,
    ); // منحنى الرأس العلوي
    pathFront.lineTo(width * 0.65, height * 0.5); // جانب الكتف الأيمن
    pathFront.quadraticBezierTo(
      width * 0.5,
      height * 0.6,
      width * 0.35,
      height * 0.5,
    ); // منحنى الكتف السفلي
    pathFront.close();

    // شكل الشخص الأصغر (الأمامي) - بجانب الشخص الكبير
    pathFront.moveTo(width * 0.55, height * 0.45); // قمة الرأس الصغير الأيسر
    pathFront.quadraticBezierTo(
      width * 0.65,
      height * 0.35,
      width * 0.75,
      height * 0.45,
    ); // منحنى الرأس الصغير العلوي
    pathFront.lineTo(width * 0.75, height * 0.75); // جانب الكتف الصغير الأيمن
    pathFront.quadraticBezierTo(
      width * 0.65,
      height * 0.85,
      width * 0.55,
      height * 0.75,
    ); // منحنى الكتف الصغير السفلي
    pathFront.close();

    canvas.drawPath(pathFront, paintFront);

    // إضافة تفاصيل صغيرة (نقاط كرتونية خفيفة) لتأثير ثلاثي الأبعاد
    Paint paintDetail =
        Paint()
          ..color = detailColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width * 0.45, height * 0.3),
      width * 0.06,
      paintDetail,
    ); // تفصيل للشخص الكبير
    canvas.drawCircle(
      Offset(width * 0.65, height * 0.55),
      width * 0.05,
      paintDetail,
    ); // تفصيل للشخص الأصغر
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 2. الـ Widget المتحرك (The Animated Widget) لأيقونة العائلة اللطيفة ---
class AnimatedFamilyIcon extends StatefulWidget {
  final double size;

  const AnimatedFamilyIcon({super.key, this.size = 100});

  @override
  State<AnimatedFamilyIcon> createState() => _AnimatedFamilyIconState();
}

class _AnimatedFamilyIconState extends State<AnimatedFamilyIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // إعداد وحدة التحكم في الحركة (تستغرق ثانيتين للدورة الواحدة)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // حركة سلسة وطويلة قليلاً
    )..repeat(reverse: true); // تجعل الحركة تذهب وتعود باستمرار

    // أنميشن من 0 إلى 1 للتحكم في كل الحركات معاً
    _animation = CurvedAnimation(
      parent: _controller,
      curve:
          Curves.easeInOutBack, // منحنى حركة مريح وفيه "مرونة" (Bounce effect)
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // ضروري جداً لتوفير موارد الجهاز
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // حسابات الحركة (متزامنة مع الحرف "A" والرقم "1" ولوحة الألوان والفاكهة)
        double verticalOffset = _animation.value * -15.0; // يصعد 15 بكسل
        double rotationAngle =
            (_animation.value - 0.5) * 0.1; // ميلان خفيف جداً (المرجحة)

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة العائلية نفسها مع الحركة والميلان
            Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..translate(0.0, verticalOffset) // الصعود والنزول
                    ..rotateZ(rotationAngle), // الميلان
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  // استدعاء الرسام المعرف فوق في نفس الملف
                  painter: FamilyPainter(),
                ),
              ),
            ),

            const SizedBox(height: 10), // مسافة بين الحرف وظله
            // الظل التفاعلي في الأسفل
            Opacity(
              opacity: 0.15 - (_animation.value * 0.08), // الظل يبهت عند الصعود
              child: Transform.scale(
                scaleX: 1.0 - (_animation.value * 0.25), // الظل يصغر عند الصعود
                child: Container(
                  width: widget.size * 0.35,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, spreadRadius: 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
