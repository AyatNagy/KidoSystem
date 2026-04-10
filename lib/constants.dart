import 'package:flutter/material.dart';

class AppColors {
  static const Color purpleMain = Color(0xFF9063F5);
  static const Color textDark = Color(0xFF333333);
  static const Color textGray = Color(0xFF8E8E8E);

  // Card Gradients
  static const List<Color> alphabetGrad = [
    Color(0xFFE2FBE9),
    Color(0xFFC4FFDD),
  ];

  static const List<Color> numbersGrad = [Color(0xFFFFF9E3), Color(0xFFFFF5BD)];

  static const List<Color> colorsGrad = [Color(0xFFF0EAFD), Color(0xFFE3D5FF)];

  static const List<Color> puzzleGrad = [Color(0xFFE3F2FD), Color(0xFFD4F1FF)];

  // *** إضافة تدرج الخضروات هنا ***
  static const List<Color> vegetablesGrad = [
    Color(0xFFDCEDC8), // أخضر فاتح جداً (Lime 100)
    Color(0xFFAED581), // أخضر عشبي (Lime 300)
  ];

  // تدرج إضافي للفاكهة إذا حبتي تميزيها
  static const List<Color> fruitGrad = [
    Color(0xFFFFEBEE), // أحمر وردي خفيف
    Color(0xFFFFCDD2), // وردي أعمق قليلاً
  ];
}
