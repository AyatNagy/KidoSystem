import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

class DashboardState {
  final String childName;
  final Map<String, double> portageProgress;
  final String nextLesson;
  final bool isLoading;

  DashboardState({
    this.childName = "",
    this.portageProgress = const {},
    this.nextLesson = "",
    this.isLoading = true,
  });
}

class DashboardBloc extends Cubit<DashboardState> {
  DashboardBloc() : super(DashboardState());

  void loadDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(DashboardState(
      childName: "Habiba",
      portageProgress: {
        "Cognitive": 0.7,
        "Social": 0.4,
        "Motor": 0.9,
        "Self-Care": 0.5,
      },
      nextLesson: "Matching Emotions",
      isLoading: false,
    ));
  }
}

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  static const Color bgColor = Color(0xFFEFF3F6);
  static const Color lightShadow = Colors.white;
  static final Color darkShadow = Colors.black.withOpacity(0.1);
  static const Color textDark = Color(0xFF2D3436);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DashboardBloc()..loadDashboardData(),
    child: Scaffold(
    backgroundColor: bgColor,
    body: BlocBuilder<DashboardBloc, DashboardState>(
    builder: (context, state) {
    if (state.isLoading) {
    return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    _buildTopNavBar(),
    const SizedBox(height: 25),
    _build3DGradientHeader(state.childName),
    const SizedBox(height: 35),
    const Text("Developmental Growth",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark)),
    const SizedBox(height: 25),
    GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 25,
    crossAxisSpacing: 25,
    childAspectRatio: 0.9,
    children: [
    _buildNeumorphicCard("Cognitive", state.portageProgress["Cognitive"] ?? 0, const Color(0xFF6C5CE7), Icons.psychology),
    _buildNeumorphicCard("Social", state.portageProgress["Social"] ?? 0, const Color(0xFF0984E3), Icons.groups),
    _buildNeumorphicCard("Motor", state.portageProgress["Motor"] ?? 0, const Color(0xFF00B894), Icons.directions_run),
    _buildNeumorphicCard("Self-Care", state.portageProgress["Self-Care"] ?? 0, const Color(0xFFE17055), Icons.auto_awesome),
    ],
    ),
    const SizedBox(height: 35),
    _build3DActionCard(state.nextLesson),
    const SizedBox(height: 20),
    ],
    ),
    );
    },
    ),
    ),
    );
  }

  Widget _buildTopNavBar() {
    return const Center(
      child: Text("Kido Journey",
          style: TextStyle(
              color: textDark,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: 1.5)),
    );
  }

  Widget _build3DGradientHeader(String name) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E44AD), Color(0xFF6C5CE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6C5CE7).withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12)),
          BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 2, offset: const Offset(-3, -3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Habiba's Progress", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Text("Level Up Soon!",
                    style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicCard(String title, double val, Color accentColor, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: darkShadow, offset: const Offset(8, 8), blurRadius: 15),
          const BoxShadow(color: lightShadow, offset: Offset(-8, -8), blurRadius: 15),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              top: -15,
              child: Transform.rotate(
                angle: -math.pi / 6,
                child: Icon(icon, size: 100, color: accentColor.withOpacity(0.06)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(fontWeight: FontWeight.w900, color: textDark.withOpacity(0.8), fontSize: 16, letterSpacing: 0.5)),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bgColor,
                          boxShadow: [
                            BoxShadow(color: darkShadow.withOpacity(0.05), offset: const Offset(3, 3), blurRadius: 3, spreadRadius: -1),
                            const BoxShadow(color: lightShadow, offset: Offset(-3, -3), blurRadius: 3, spreadRadius: -1),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularProgressIndicator(
                          value: val,
                          strokeWidth: 10,
                          backgroundColor: accentColor.withOpacity(0.1),
                          color: accentColor,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text("${(val * 100).toInt()}%",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textDark)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DActionCard(String lesson) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFAB1A0).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rocket_launch, color: Color(0xFFE17055), size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("NEXT STEP",
                    style: TextStyle(letterSpacing: 2.0, fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFE17055))),
                const SizedBox(height: 3),
                Text(lesson,
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: textDark)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}