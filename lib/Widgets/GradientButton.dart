import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const GradientButton({
    super.key,
    required this.title,
    required this.gradientColors,
    required this.onPressed, required double height, required double fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
          elevation: 3,
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
