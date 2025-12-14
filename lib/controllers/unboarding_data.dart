import 'dart:ui';

import 'package:kido/Models/OnboardModel.dart';

final List<OnboardModel> onboardData = [
  OnboardModel(
    image: 'assets/images/learn.jpeg',
    title: 'Learn',
    color: Color(0xFF6A37A8),
    desc: 'Discover fun lessons with letters, numbers, shapes, and more!',
    gradientColors: [
    Color(0xFFD1A6FF),
    Color(0xFF6A37A8),
    Color(0xFF4C148F),
      ],
  ),
  OnboardModel(
    image: 'assets/images/play.png',
    title: 'Play',
    color: Color(0xFF277D8D),
    desc: 'Enjoy interactive games and quizzes that make learning exciting.',
    gradientColors: [
    Color(0xFF75E6F0), 
    Color(0xFF277D8D), 
    Color(0xFF0E4C58), 
  ],
  ),
  OnboardModel(
    image: 'assets/images/connect.png',
    title: 'Connect',
    color: Color(0xFFCC5E33),
    desc: 'Track your child’s progress and stay in touch with teachers.',
    gradientColors: [
    Color(0xFFFFB482), 
    Color(0xFFCC5E33), 
    Color(0xFF8A2F07), 
  ],
  ),
  OnboardModel(
    image: 'assets/images/guide.jpeg',
    title: 'Guide',
    color: Color(0xFF2E8B57),
    desc: 'Assess levels, assign activities, and create extra exams when needed.',
    gradientColors: [
    Color(0xFF9AF7C2), 
    Color(0xFF2E8B57), 
    Color(0xFF0F5E33),
  ],
  ),
];
