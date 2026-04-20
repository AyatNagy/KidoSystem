import 'dart:ui';

List<Map<String, dynamic>> level3Data(Map<String, double> data) => [
  {
    "title": "Letters",
    "progress": data["Letters"] ?? 0,
    "symbol": "assets/images/letter_A.png",
    "gradient": [const Color(0xFF6C5CE7), const Color(0xFF8E7CFF)]
  },
  {
    "title": "Numbers",
    "progress": data["Numbers"] ?? 0,
    "symbol": "assets/images/number_1.png",
    "gradient": [const Color(0xFF0984E3), const Color(0xFF74B9FF)]
  },
  {
    "title": "Veggie",
    "progress": data["Vegetables"] ?? 0,
    "symbol": "assets/images/vegi.png",
    "gradient": [const Color(0xFF00B894), const Color(0xFF55E6C1)]
  },
  {
    "title": "Fruits",
    "progress": data["Fruits"] ?? 0,
    "symbol": "assets/images/apple.png",
    "gradient": [const Color(0xFFE17055), const Color(0xFFFF8DA1)]
  },
];

List<Map<String, dynamic>> level2Data(Map<String, double> data) => [
  {
    "title": "Feelings",
    "progress": data["Emotions"] ?? 0,
    "symbol": "😊",
    "gradient": [const Color(0xFFFD79A8), const Color(0xFFFFA3C5)]
  },
  {
    "title": "Clean Up",
    "progress": data["Self-Care"] ?? 0,
    "symbol": "🧼",
    "gradient": [const Color(0xFFFDCB6E), const Color(0xFFFFE082)]
  },
  {
    "title": "Friends",
    "progress": data["Social"] ?? 0,
    "symbol": "🤝",
    "gradient": [const Color(0xFF74B9FF), const Color(0xFFA2D2FF)]
  },
  {
    "title": "Action",
    "progress": data["Motor"] ?? 0,
    "symbol": "🏃",
    "gradient": [const Color(0xFF55E6C1), const Color(0xFF8BFFDA)]
  },
];