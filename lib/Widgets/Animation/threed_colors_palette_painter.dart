import 'package:flutter/material.dart';

// --- 1. الرسام (The Painter) للوحة الألوان ثلاثية الأبعاد ---
class ThreeDColorsPalettePainter extends CustomPainter {
  final Color primaryColor;
  final Color depthColor;

  ThreeDColorsPalettePainter({
    // اللون البنفسجي الفاتح الأساسي للوحة
    this.primaryColor = const Color(0xFFE1BEE7), // بنفسجي فاتح
    this.depthColor = const Color(0xFFAB47BC), // بنفسجي داكن للعمق
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
          ..color = depthColor
          ..style = PaintingStyle.fill;

    // --- رسم العمق أولاً (الظل الجانبي والخلفي) ---
    Path pathDepth = Path();
    // شكل اللوحة الرئيسي (خلفي)
    pathDepth.moveTo(
      width * 0.15 + depthOffset,
      height * 0.15 + depthOffset,
    ); // أعلى يسار
    pathDepth.lineTo(
      width * 0.85 + depthOffset,
      height * 0.15 + depthOffset,
    ); // أعلى يمين
    pathDepth.lineTo(
      width * 0.85 + depthOffset,
      height * 0.75 + depthOffset,
    ); // أسفل يمين
    pathDepth.quadraticBezierTo(
      width * 0.5 + depthOffset,
      height * 0.95 + depthOffset,
      width * 0.15 + depthOffset,
      height * 0.75 + depthOffset,
    ); // منحنى سفلي (خلفي)
    pathDepth.close();

    // رسم العمق للثقب الخلفي
    Path holeDepth = Path();
    holeDepth.addOval(
      Rect.fromCircle(
        center: Offset(width * 0.25 + depthOffset, height * 0.25 + depthOffset),
        radius: width * 0.08,
      ),
    );

    canvas.drawPath(pathDepth, paintDepth);
    canvas.drawPath(holeDepth, paintDepth);

    // --- رسم الوجه الأمامي للوحة ---
    Path pathFront = Path();
    pathFront.moveTo(width * 0.15, height * 0.15); // أعلى يسار
    pathFront.lineTo(width * 0.85, height * 0.15); // أعلى يمين
    pathFront.lineTo(width * 0.85, height * 0.75); // أسفل يمين
    pathFront.quadraticBezierTo(
      width * 0.5,
      height * 0.95,
      width * 0.15,
      height * 0.75,
    ); // منحنى سفلي (أمامي)
    pathFront.close();

    // رسم الثقب الأمامي (Hole for thumb)
    Path holeFront = Path();
    holeFront.addOval(
      Rect.fromCircle(
        center: Offset(width * 0.25, height * 0.25),
        radius: width * 0.08,
      ),
    );

    // دمج المسارين لطرح الثقب من اللوحة
    Path finalPathFront = Path.combine(
      PathOperation.difference,
      pathFront,
      holeFront,
    );

    canvas.drawPath(finalPathFront, paintFront);

    // --- رسم بقع الألوان (Color Splashes) ---
    Paint paintSplash = Paint()..style = PaintingStyle.fill;

    // بقعة حمراء (أعلى يمين)
    paintSplash.color = Colors.red[400]!;
    canvas.drawCircle(
      Offset(width * 0.65, height * 0.35),
      width * 0.1,
      paintSplash,
    );

    // بقعة زرقاء (أسفل يمين)
    paintSplash.color = Colors.blue[400]!;
    canvas.drawCircle(
      Offset(width * 0.70, height * 0.65),
      width * 0.12,
      paintSplash,
    );

    // بقعة خضراء (أسفل يسار)
    paintSplash.color = Colors.green[400]!;
    canvas.drawCircle(
      Offset(width * 0.35, height * 0.75),
      width * 0.1,
      paintSplash,
    );

    // بقعة صفراء (في المنتصف)
    paintSplash.color = Colors.yellow[600]!;
    canvas.drawCircle(
      Offset(width * 0.5, height * 0.5),
      width * 0.08,
      paintSplash,
    );

    // --- رسم الفرشاة (Brush) ثلاثية الأبعاد ---
    Paint paintBrushHandleFront =
        Paint()
          ..color = const Color(0xFF8D6E63)
          ..style = PaintingStyle.fill; // بني فاتح (مقبض)
    Paint paintBrushHandleDepth =
        Paint()
          ..color = const Color(0xFF6D4C41)
          ..style = PaintingStyle.fill; // بني داكن (عمق)
    Paint paintBrushBristles =
        Paint()
          ..color = const Color(0xFFD7CCC8)
          ..style = PaintingStyle.fill; // بيج (شعر)

    // رسم العمق للمقبض (خلفي)
    Path brushHandleDepth = Path();
    brushHandleDepth.moveTo(
      width * 0.85 + depthOffset,
      height * 0.10 + depthOffset,
    ); // قمة
    brushHandleDepth.lineTo(
      width * 0.95 + depthOffset,
      height * 0.15 + depthOffset,
    ); // يمين
    brushHandleDepth.lineTo(
      width * 0.90 + depthOffset,
      height * 0.50 + depthOffset,
    ); // أسفل يمين
    brushHandleDepth.lineTo(
      width * 0.80 + depthOffset,
      height * 0.45 + depthOffset,
    ); // أسفل يسار
    brushHandleDepth.close();
    canvas.drawPath(brushHandleDepth, paintBrushHandleDepth);

    // رسم الوجه الأمامي للمقبض
    Path brushHandleFront = Path();
    brushHandleFront.moveTo(width * 0.85, height * 0.10); // قمة
    brushHandleFront.lineTo(width * 0.95, height * 0.15); // يمين
    brushHandleFront.lineTo(width * 0.90, height * 0.50); // أسفل يمين
    brushHandleFront.lineTo(width * 0.80, height * 0.45); // أسفل يسار
    brushHandleFront.close();
    canvas.drawPath(brushHandleFront, paintBrushHandleFront);

    // رسم شعر الفرشاة (Bristles) في الأسفل
    canvas.drawCircle(
      Offset(width * 0.85, height * 0.55),
      width * 0.1,
      paintBrushBristles,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 2. الـ Widget المتحرك (The Animated Widget) للوحة الألوان ---
class AnimatedColorsPalette extends StatefulWidget {
  final double size;

  const AnimatedColorsPalette({super.key, this.size = 100});

  @override
  State<AnimatedColorsPalette> createState() => _AnimatedColorsPaletteState();
}

class _AnimatedColorsPaletteState extends State<AnimatedColorsPalette>
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
        // حسابات الحركة (متزامنة مع الحرف "A" والرقم "1")
        double verticalOffset = _animation.value * -15.0; // يصعد 15 بكسل
        double rotationAngle =
            (_animation.value - 0.5) * 0.1; // ميلان خفيف جداً (المرجحة)

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // اللوحة نفسها مع الحركة والميلان والفرشاة
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
                  painter: ThreeDColorsPalettePainter(),
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
