import 'dart:ui';
import 'package:kido/constants.dart';

List<Map<String, dynamic>> level3Data(Map<String, double> data) => [
  {
    "title": "Letters",
    "progress": data["Letters"] ?? 0,
    "symbol": "assets/images/letter_A.png",
    "gradient": [const Color(0xFF6C5CE7), const Color(0xFF8E7CFF)],
  },
  {
    "title": "Numbers",
    "progress": data["Numbers"] ?? 0,
    "symbol": "assets/images/number_1.png",
    "gradient": [const Color(0xFF0984E3), const Color(0xFF74B9FF)],
  },
  {
    "title": "Veggie",
    "progress": data["Vegetables"] ?? 0,
    "symbol": "assets/images/vegi.png",
    "gradient": [const Color(0xFF00B894), const Color(0xFF55E6C1)],
  },
  {
    "title": "Fruits",
    "progress": data["Fruits"] ?? 0,
    "symbol": "assets/images/apple.png",
    "gradient": [const Color(0xFFE17055), const Color(0xFFFF8DA1)],
  },
  {
    "title": "Animals",
    "progress": data["Animals"] ?? 0,
    "symbol": "assets/images/animal.jpg",
    "gradient": [AppColors.kidoOrange, AppColors.kidoColors[5]],
  },
  {
    "title": "Family",
    "progress": data["Family"] ?? 0,
    "symbol": "assets/images/family.jpg",
    "gradient": [AppColors.kidoYellow, AppColors.kidoColors[5]],
  },
];

List<Map<String, dynamic>> level1Data(Map<String, double> data) => [
  {
    "title": "Feelings",
    "progress": data["Emotions"] ?? 0,
    "symbol": "assets/images/feelings.jpg",
    "gradient": [AppColors.kidoPink, AppColors.kidoColors[3]],
  },
  {
    "title": "Self-Care",
    "progress": data["Self-Care"] ?? 0,
    "symbol": "assets/images/self-care.jpg",
    "gradient": [const Color(0xFFFDCB6E), const Color(0xFFFFE082)],
  },
  {
    "title": "Counting",
    "progress": data["Counting"] ?? 0,
    "symbol": "assets/images/counting.jpg",
    "gradient": [const Color(0xFF74B9FF), const Color(0xFFA2D2FF)],
  },
  {
    "title": "Senses",
    "progress": data["Senses"] ?? 0,
    "symbol": "assets/images/senses.jpg",
    "gradient": [const Color(0xFF55E6C1), const Color(0xFF8BFFDA)],
  },
  {
    "title": "Matching",
    "progress": data["Matching"] ?? 0,
    "symbol": "assets/images/matching.png",
    "gradient": [AppColors.purpleMain, AppColors.kidoColors[2]],
  },
  {
    "title": "Sorting",
    "progress": data["Sorting"] ?? 0,
    "symbol": "assets/images/sorting.png",
    "gradient": [AppColors.kidoOrange, AppColors.kidoColors[5]],
  },
  {
    "title": "PegBoard",
    "progress": data["PegBoard"] ?? 0,
    "symbol": "assets/images/pegboard.png",
    "gradient": [AppColors.kidoRed, AppColors.kidoColors[6]],
  },
];

List<Map<String, dynamic>> level2Data(Map<String, double> data) => [
  {
    "title": "Puzzle",
    "progress": data["Puzzle"] ?? 0,
    "symbol": "assets/images/puzzle.jpg",
    "gradient": [AppColors.kidoPink, AppColors.kidoColors[3]],
  },
  {
    "title": "Drawing-Lines",
    "progress": data["Drawing-Lines"] ?? 0,
    "symbol": "assets/images/drawing.jpg",
    "gradient": [const Color(0xFFFDCB6E), const Color(0xFFFFE082)],
  },
  {
    "title": "Shapes",
    "progress": data["Shapes"] ?? 0,
    "symbol": "assets/images/shapes.jpg",
    "gradient": [const Color(0xFF74B9FF), const Color(0xFFA2D2FF)],
  },
  {
    "title": "Sizes",
    "progress": data["Sizes"] ?? 0,
    "symbol": "assets/images/sizes.png",
    "gradient": [AppColors.purpleMain, AppColors.kidoColors[2]],
  },
  {
    "title": "Colors",
    "progress": data["Colors"] ?? 0,
    "symbol": "assets/images/colors.jpg",
    "gradient": [AppColors.purpleMain, AppColors.kidoColors[2]],
  },
];