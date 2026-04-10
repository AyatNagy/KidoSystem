import 'package:flutter/material.dart';

// --- 1. الرسام (The Painter) للتفاحة ثلاثية الأبعاد ---
class ThreeDApplePainter extends CustomPainter {
  final Color primaryColor;
  final Color depthColor;
  final Color leafColor;
  final Color stemColor;

  ThreeDApplePainter({
    // الألوان الافتراضية للتفاحة
    this.primaryColor = const Color(0xFFE57373), // أحمر فاتح ولطيف
    this.depthColor = const Color(0xFFC62828), // أحمر داكن للعمق
    this.leafColor = const Color(0xFF81C784), // أخضر فاتح للورقة
    this.stemColor = const Color(0xFF8D6E63), // بني للمقبض (الجذع)
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

    // --- رسم العمق أولاً (الظل الجانبي والخلفي) جسم التفاحة ---
    Path pathDepth = Path();
    // شكل التفاحة الرئيسي (خلفي) - شكل دائري غير منتظم قليلاً
    pathDepth.moveTo(
      width * 0.5 + depthOffset,
      height * 0.15 + depthOffset,
    ); // أعلى المنتصف
    pathDepth.cubicTo(
      width * 0.9 + depthOffset,
      height * 0.15 + depthOffset, // منحنى أيمن علوي
      width * 1.0 + depthOffset,
      height * 0.6 + depthOffset, // منتصف أيمن
      width * 0.5 + depthOffset,
      height * 0.9 + depthOffset,
    ); // أسفل المنتصف
    pathDepth.cubicTo(
      width * 0.0 + depthOffset,
      height * 0.6 + depthOffset, // منتصف أيسر
      width * 0.1 + depthOffset,
      height * 0.15 + depthOffset, // منحنى أيسر علوي
      width * 0.5 + depthOffset,
      height * 0.15 + depthOffset,
    ); // قمة
    pathDepth.close();

    canvas.drawPath(pathDepth, paintDepth);

    // --- رسم الوجه الأمامي للتفاحة ---
    Path pathFront = Path();
    // شكل التفاحة الرئيسي (أمامي)
    pathFront.moveTo(width * 0.5, height * 0.15); // أعلى المنتصف
    pathFront.cubicTo(
      width * 0.9,
      height * 0.15, // منحنى أيمن علوي
      width * 1.0,
      height * 0.6, // منتصف أيمن
      width * 0.5,
      height * 0.9,
    ); // أسفل المنتصف
    pathFront.cubicTo(
      width * 0.0,
      height * 0.6, // منتصف أيسر
      width * 0.1,
      height * 0.15, // منحنى أيسر علوي
      width * 0.5,
      height * 0.15,
    ); // قمة
    pathFront.close();

    canvas.drawPath(pathFront, paintFront);

    // --- رسم الجذع (Stem) ثلاثي الأبعاد ---
    Paint paintStemFront =
        Paint()
          ..color = stemColor
          ..style = PaintingStyle.fill;
    Paint paintStemDepth =
        Paint()
          ..color = stemColor.withOpacity(0.7)
          ..style = PaintingStyle.fill;

    // رسم العمق للجذع (خلفي)
    Path stemDepth = Path();
    stemDepth.moveTo(
      width * 0.48 + depthOffset,
      height * 0.0 + depthOffset,
    ); // قمة أيسر
    stemDepth.lineTo(
      width * 0.52 + depthOffset,
      height * 0.0 + depthOffset,
    ); // قمة أيمن
    stemDepth.lineTo(
      width * 0.50 + depthOffset,
      height * 0.2 + depthOffset,
    ); // قاعدة
    stemDepth.close();
    canvas.drawPath(stemDepth, paintStemDepth);

    // رسم الوجه الأمامي للجذع
    Path stemFront = Path();
    stemFront.moveTo(width * 0.48, height * 0.0); // قمة أيسر
    stemFront.lineTo(width * 0.52, height * 0.0); // قمة أيمن
    stemFront.lineTo(width * 0.50, height * 0.2); // قاعدة
    stemFront.close();
    canvas.drawPath(stemFront, paintStemFront);

    // --- رسم الورقة (Leaf) ثلاثية الأبعاد ---
    Paint paintLeafFront =
        Paint()
          ..color = leafColor
          ..style = PaintingStyle.fill;
    Paint paintLeafDepth =
        Paint()
          ..color = leafColor.withOpacity(0.7)
          ..style = PaintingStyle.fill;

    // رسم العمق للورقة (خلفي)
    Path leafDepth = Path();
    leafDepth.moveTo(
      width * 0.50 + depthOffset,
      height * 0.1 + depthOffset,
    ); // قاعدة الورقة (على الجذع)
    leafDepth.cubicTo(
      width * 0.75 + depthOffset,
      height * 0.0 + depthOffset, // منحنى أيمن علوي
      width * 0.85 + depthOffset,
      height * 0.2 + depthOffset, // منتصف أيمن
      width * 0.50 + depthOffset,
      height * 0.1 + depthOffset,
    ); // عودة للقاعدة
    leafDepth.close();
    canvas.drawPath(leafDepth, paintLeafDepth);

    // رسم الوجه الأمامي للورقة
    Path leafFront = Path();
    leafFront.moveTo(width * 0.50, height * 0.1); // قاعدة الورقة
    leafFront.cubicTo(
      width * 0.75,
      height * 0.0, // منحنى أيمن علوي
      width * 0.85,
      height * 0.2, // منتصف أيمن
      width * 0.50,
      height * 0.1,
    ); // عودة للقاعدة
    leafFront.close();
    canvas.drawPath(leafFront, paintLeafFront);

    // إضافة لمعة صغيرة ولطيفة (Highlight) على التفاحة
    Paint paintHighlight =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width * 0.3, height * 0.35),
      width * 0.08,
      paintHighlight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 2. الـ Widget المتحرك (The Animated Widget) للتفاحة اللطيفة ---
class AnimatedCuteApple extends StatefulWidget {
  final double size;

  const AnimatedCuteApple({super.key, this.size = 100});

  @override
  State<AnimatedCuteApple> createState() => _AnimatedCuteAppleState();
}

class _AnimatedCuteAppleState extends State<AnimatedCuteApple>
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
        // حسابات الحركة (متزامنة مع الحرف "A" والرقم "1" ولوحة الألوان)
        double verticalOffset = _animation.value * -15.0; // يصعد 15 بكسل
        double rotationAngle =
            (_animation.value - 0.5) * 0.1; // ميلان خفيف جداً (المرجحة)

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // التفاحة نفسها مع الحركة والميلان والورقة
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
                  painter: ThreeDApplePainter(),
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
