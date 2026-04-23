import 'package:flutter/material.dart';
import 'package:kido/Models/size_lesson_data.dart';
import 'package:kido/Pages/content/sizes/size_lesson_page.dart';
import 'package:kido/Widgets/custom_app_button.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: scale,
              builder:
                  (_, child) =>
                      Transform.scale(scale: scale.value, child: child),
              child: Image.asset(data.correctImage, height: 250),
            ),

            const SizedBox(height: 30),

            Text(
              data.title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomGradientButton(
                title: "ابدأ",
                width: double.infinity,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SizeLessonPage(goal: widget.goal),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
