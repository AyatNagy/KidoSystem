// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final List<Color> gradient;
  final Widget graphic;
  final double? progress;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.gradient,
    required this.graphic,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasProgress = progress != null && progress! > 0;
    final double currentProgress = progress ?? 0.0;
    final bool isMastered = currentProgress >= 0.9;

    // 👇 لو Image أو gif معمول بـ Image.asset
    final bool isImageWidget = graphic is Image;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,

              // 👇 الصور منغير padding
              padding:
                  isImageWidget ? EdgeInsets.zero : const EdgeInsets.all(15),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: gradient.last.withOpacity(hasProgress ? 0.25 : 0.1),
                    blurRadius: hasProgress ? 25 : 15,
                    spreadRadius: hasProgress ? 2 : 0,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color:
                      hasProgress
                          ? gradient.first.withOpacity(0.1)
                          : Colors.transparent,
                  width: 1.5,
                ),
              ),

              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress
                  if (hasProgress)
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: currentProgress,
                        strokeWidth: 4,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          gradient.first,
                        ),
                        backgroundColor: gradient.first.withOpacity(0.05),
                      ),
                    ),

                  // 👇 الصور تتملى
                  if (isImageWidget)
                    Positioned.fill(
                      child: Opacity(
                        opacity: hasProgress ? 0.8 : 1.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: graphic,
                        ),
                      ),
                    )
                  // 👇 الانيميشنز تفضل فى النص
                  else
                    Center(
                      child: Opacity(
                        opacity: hasProgress ? 0.8 : 1.0,
                        child: graphic,
                      ),
                    ),

                  // Verified
                  if (isMastered)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(
                        Icons.verified_rounded,
                        color: gradient.first,
                        size: 22,
                      ),
                    ),

                  // Percentage
                  if (hasProgress)
                    Positioned(
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: gradient.first.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${(currentProgress * 100).toInt()}%",
                          style: TextStyle(
                            color: gradient.first,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
