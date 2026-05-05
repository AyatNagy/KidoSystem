import 'package:flutter/material.dart';

class ChoiceItem extends StatelessWidget {
  final String image;
  final bool isWrong;
  final bool canAnimate;
  final Animation<double> animation;
  final VoidCallback onTap;
  final Matrix4 transform;
  final double height;

  const ChoiceItem({
    super.key,
    required this.image,
    required this.isWrong,
    required this.canAnimate,
    required this.animation,
    required this.onTap,
    required this.transform,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: isWrong ? 0.3 : 1.0,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // بنشغل الأنيميشن والـ Glow بس لو الإجابة مش غلط والتايمر سمح بالتحريك
              bool shouldShowEffect = canAnimate && !isWrong;

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (shouldShowEffect)
                    Container(
                      width: height * 0.8,
                      height: height * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent.withOpacity(
                              0.5 * animation.value,
                            ),
                            blurRadius: 40 * animation.value,
                            spreadRadius: 15 * animation.value,
                          ),
                        ],
                      ),
                    ),
                  Container(
                    transform:
                        shouldShowEffect ? transform : Matrix4.identity(),
                    transformAlignment: Alignment.center,
                    child: child,
                  ),
                ],
              );
            },
            child: Image.asset(image, height: height, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
