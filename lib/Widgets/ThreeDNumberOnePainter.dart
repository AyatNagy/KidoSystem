import 'package:flutter/material.dart';

// --- 1. الرسام (The Painter) لم رقم "1" ثلاثي الأبعاد ---
class ThreeDNumberOnePainter extends CustomPainter {
  final Color primaryColor;
  final Color depthColor;

  ThreeDNumberOnePainter({
    // اللون الأزرق الفاتح كما في التصميم
    this.primaryColor = const Color(0xFF64B5F6), // الأزرق الأساسي
    this.depthColor = const Color(0xFF1E88E5), // الأزرق الداكن للعمق
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
    // الساق الرئيسية (الخلفية)
    pathDepth.moveTo(
      width * 0.40 + depthOffset,
      height * 0.15 + depthOffset,
    ); // أعلى يسار (الشطبة)
    pathDepth.lineTo(
      width * 0.60 + depthOffset,
      height * 0.15 + depthOffset,
    ); // أعلى يمين
    pathDepth.lineTo(
      width * 0.60 + depthOffset,
      height * 0.85 + depthOffset,
    ); // أسفل يمين
    pathDepth.lineTo(
      width * 0.40 + depthOffset,
      height * 0.85 + depthOffset,
    ); // أسفل يسار
    pathDepth.close();

    // رسم العمق للشطبة العلوية
    Path pathBevelDepth = Path();
    pathBevelDepth.moveTo(
      width * 0.20 + depthOffset,
      height * 0.30 + depthOffset,
    ); // بداية الشطبة
    pathBevelDepth.lineTo(
      width * 0.40 + depthOffset,
      height * 0.15 + depthOffset,
    ); // قمة الشطبة
    pathBevelDepth.lineTo(
      width * 0.60 + depthOffset,
      height * 0.15 + depthOffset,
    ); // أعلى يمين (الرئيسي)
    pathBevelDepth.lineTo(
      width * 0.40 + depthOffset,
      height * 0.30 + depthOffset,
    ); // عودة للشطبة
    pathBevelDepth.close();

    canvas.drawPath(pathDepth, paintDepth);
    canvas.drawPath(pathBevelDepth, paintDepth);

    // --- رسم الوجه الأمامي رقم "1" ---
    Path pathFront = Path();
    pathFront.moveTo(width * 0.20, height * 0.30); // بداية الشطبة العلوية
    pathFront.lineTo(width * 0.40, height * 0.15); // قمة الشطبة (أعلى يسار)
    pathFront.lineTo(width * 0.60, height * 0.15); // أعلى يمين (الرئيسي)
    pathFront.lineTo(width * 0.60, height * 0.85); // أسفل يمين
    pathFront.lineTo(width * 0.40, height * 0.85); // أسفل يسار
    pathFront.lineTo(width * 0.40, height * 0.30); // عودة للشطبة
    pathFront.close();

    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 2. الـ Widget المتحرك (The Animated Widget) لرقم "1" ---
class AnimatedThreeDNumberOne extends StatefulWidget {
  final double size;

  const AnimatedThreeDNumberOne({super.key, this.size = 100});

  @override
  State<AnimatedThreeDNumberOne> createState() =>
      _AnimatedThreeDNumberOneState();
}

class _AnimatedThreeDNumberOneState extends State<AnimatedThreeDNumberOne>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // إعداد وحدة التحكم في الحركة (تستغرق ثانيتين للدورة الواحدة)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ), // حركة أبطأ قليلاً لتعطي إحساس بالثقل
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
        // حسابات الحركة
        double verticalOffset = _animation.value * -15.0; // يصعد 15 بكسل
        double rotationAngle =
            (_animation.value - 0.5) * 0.1; // ميلان خفيف جداً (المرجحة)

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الرقم نفسه مع الحركة والميلان
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
                  painter: ThreeDNumberOnePainter(),
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
