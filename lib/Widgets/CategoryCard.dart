import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final List<Color> gradient;
  final Widget graphic;
  final double? progress;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
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

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  color: hasProgress ? gradient.first.withOpacity(0.1) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (hasProgress)
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: currentProgress,
                        strokeWidth: 4,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation<Color>(gradient.first),
                        backgroundColor: gradient.first.withOpacity(0.05),
                      ),
                    ),

                  Center(
                    child: Opacity(
                      opacity: hasProgress ? 0.8 : 1.0,
                      child: graphic,
                    ),
                  ),

                  if (isMastered)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.verified_rounded,
                        color: gradient.first,
                        size: 22,
                      ),
                    ),

                  if (hasProgress)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}