import 'dart:ui';

import 'package:kido/Models/OnboardModel.dart';

final List<OnboardModel> onboardData = [
  OnboardModel(
    image: 'assets/images/learn.jpeg',
    title: 'Learn',
    color: Color(0xFF6A37A8),
    desc: 'Discover fun lessons with letters, numbers, shapes, and more!',
  ),
  OnboardModel(
    image: 'assets/images/play.jpeg',
    title: 'Play',
    color: Color(0xFF277D8D),
    desc: 'Enjoy interactive games and quizzes that make learning exciting.',
  ),
  OnboardModel(
    image: 'assets/images/connect.png',
    title: 'Connect',
    color: Color(0xFFCC5E33),
    desc: 'Track your child’s progress and stay in touch with teachers.',
  ),
  OnboardModel(
    image: 'assets/images/guide.jpeg',
    title: 'Guide',
    color: Color(0xFF2E8B57),
    desc: 'Assess levels, assign activities, and create extra exams when needed.',
  ),
];
