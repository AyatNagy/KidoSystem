// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/child.dart';
import '../../Widgets/Layout/header_clipper.dart';
import '../../Widgets/Buttons/puls_button.dart';
import '../../bloc/dashoard.dart';
import '../../constants.dart';
import '../../data/dashboard.dart';

class Dashboard extends StatelessWidget {
  final Child child;
  final int level;
  final double score;

  const Dashboard({
    super.key,
    required this.child,
    required this.level,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..loadDashboardData(child, level, score),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: state.isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.kidoPink,
              ),
            )
                : Stack(
              children: [
                _buildKidoGradientHeader(),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildModernHeroCard(state),
                        const SizedBox(height: 35),
                        const Text(
                          "Learning Journey",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildCreativeTaskGrid(state),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 20,
                  child: _buildSwitchButton(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKidoGradientHeader() {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.kidoPink.withOpacity(0.9),
              AppColors.kidoOrange.withOpacity(0.9),
              AppColors.kidoYellow.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white.withOpacity(0.15),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeroCard(DashboardState state) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDDE7F5).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kidoPink,
                      AppColors.kidoOrange,
                      AppColors.kidoYellow,
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    (state.selectedChild?.name != null && state.selectedChild!.name.isNotEmpty)
                        ? state.selectedChild!.name[0].toUpperCase()
                        : "K",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kidoOrange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${state.selectedChild?.name ?? 'Kid'}!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Text(
                      "Everything looks great today!",
                      style: TextStyle(color: AppColors.textGray, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(
                "Accuracy",
                "${state.accuracy}%",
                Icons.track_changes_rounded,
                AppColors.kidoBlue,
              ),
              _buildMetric(
                "Badges",
                "${state.badges}",
                Icons.stars_rounded,
                AppColors.kidoYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeTaskGrid(DashboardState state) {
    List<Map<String, dynamic>> taskItems = [];
    if (state.level == 3) {
      taskItems = level3Data(state.progress);
    } else if (state.level == 2) {
      taskItems = level2Data(state.progress);
    } else {
      taskItems = level1Data(state.progress);
    }
    return Column(
      children: taskItems
          .map((item) => _buildModernTaskCard(item, state.previousProgress))
          .toList(),
    );
  }

  Widget _buildModernTaskCard(
      Map<String, dynamic> item,
      Map<String, double> prevProgress,
      ) {
    final String title = item['title'] ?? 'Task';
    final String symbol = item['symbol'] ?? '✨';
    final double currentVal = (item['progress'] as num? ?? 0.0).toDouble();
    final double previousVal = prevProgress[title] ?? currentVal;
    final bool isUp = currentVal >= previousVal;
    final Color kidoColor = _getKidoColorByTitle(title);

    final bool isImagePath = symbol.contains("assets/");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE0E0E0).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kidoColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: isImagePath
                  ? Image.asset(symbol, width: 32, fit: BoxFit.contain)
                  : Text(symbol, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: currentVal.clamp(0.0, 1.0), // Prevents layout explosion layout errors
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: kidoColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${(currentVal * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kidoColor,
                ),
              ),
              Icon(
                isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: isUp ? AppColors.kidoGreen : AppColors.kidoPink,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getKidoColorByTitle(String title) {
    switch (title.toLowerCase()) {
      case 'letters':
        return AppColors.kidoPink;
      case 'numbers':
        return AppColors.kidoOrange;
      case 'veggie':
        return AppColors.kidoGreen;
      case 'fruits':
        return AppColors.kidoBlue;
      case 'feelings':
        return AppColors.kidoPink;
      case 'clean up':
        return AppColors.kidoOrange;
      default:
        return AppColors.kidoBlue;
    }
  }

  Widget _buildSwitchButton(BuildContext context) {
    return PulseButton(
      onPressed: () => context.read<DashboardBloc>().toggleChild(),
      child: Container(
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.kidoPink, AppColors.kidoOrange],
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.swap_horizontal_circle_outlined,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}