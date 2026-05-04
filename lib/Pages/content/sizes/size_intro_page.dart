import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
import 'package:kido/Pages/content/sizes/size_lesson_page.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/enum/size_goal.dart';

class SizeIntroPage extends StatefulWidget {
  final SizeGoal goal;
  const SizeIntroPage({super.key, required this.goal});

  @override
  State<SizeIntroPage> createState() => _SizeIntroPageState();
}

class _SizeIntroPageState extends State<SizeIntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late SizeLessonData data;

  @override
  void initState() {
    super.initState();
    data = SizeLessonMapper.get(widget.goal);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    scale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استدعاء الكونفج
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding, // استخدام بادينج متجاوب
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: scale,
                builder:
                    (_, child) =>
                        Transform.scale(scale: scale.value, child: child),
                child: Image.asset(
                  data.correctImage,
                  // استخدام نسبة من طول الشاشة (مثلا 30%)
                  height: config.imageHeight(0.3),
                ),
              ),
              SizedBox(height: config.localHeight * 0.04), // مسافة متجاوبة
              Text(
                data.title,
                style: TextStyle(
                  fontSize: config.headline, // خط متجاوب
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: config.localHeight * 0.05),
              CustomGradientButton(
                title: "ابدأ",
                width: double.infinity,
                // يمكنك إضافة height: config.buttonHeight لو الزرار بيقبل
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SizeLessonPage(goal: widget.goal),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
