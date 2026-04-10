import 'package:flutter/material.dart';
import 'package:kido/constants.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final List<Color> gradient;
  final Widget graphic; // This is where your generated image/icon goes
  final VoidCallback onTap;

  const CategoryCard({
    required this.title,
    required this.gradient,
    required this.graphic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: gradient.last.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(child: graphic),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
