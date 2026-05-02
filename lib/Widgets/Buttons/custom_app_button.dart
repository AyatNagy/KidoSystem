import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final List<Color> colors;
  final double width;
  final double borderRadius;
  final double fontSize;

  const CustomGradientButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.colors = const [
      Color(0xff3DF0C4),
      Color(0xff3BDBE7),
      Color(0xff2C8FF9),
    ],
    this.width = 200,
    this.borderRadius = 25,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
