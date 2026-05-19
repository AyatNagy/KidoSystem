import 'package:flutter/material.dart';
import 'package:kido/Models/level2/size_model.dart';
import 'package:kido/Pages/content/level2/sizes/size_lesson_page.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/enum/size_goal.dart';

import '../../../../data/content/level2/size/size_data.dart';

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

    _startAutoNavigation();
  }

  void _startAutoNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final bool? isCompleted = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => SizeLessonPage(goal: widget.goal)),
      );

      if (mounted && isCompleted == true) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: scale,
                  builder:
                      (_, child) =>
                          Transform.scale(scale: scale.value, child: child),
                  child: Image.asset(
                    data.correctImage,
                    height: config.imageHeight(0.3),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: config.localHeight * 0.04),
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: config.headline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
