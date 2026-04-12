import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/child.dart';
import '../../Widgets/headerClipper.dart';
import '../../Widgets/puls_button.dart';
import '../../bloc/dashoard.dart';
import '../../data/dashboard.dart';

class Dashboard extends StatelessWidget {
  final Child child;
  final int level;
  final double score;

  const Dashboard({
    super.key,
    required this.child,
    required this.level,
    required this.score
  });

  static const Color kidoPink = Color(0xFFFF85A1);   // وردي هادئ
  static const Color kidoOrange = Color(0xFFFFB366); // برتقالي مشمش
  static const Color kidoYellow = Color(0xFFFFE066); // أصفر كريمي
  static const Color kidoGreen = Color(0xFF88D498);
  static const Color kidoBlue = Color(0xFF8ECAE6);
  static const Color bgColor = Color(0xFFF9FBFF);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..loadDashboardData(child, level, score),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bgColor,
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator(color: kidoPink))
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
                                fontWeight: FontWeight.w900
                            )
                        ),
                        const SizedBox(height: 30),
                        _buildModernHeroCard(state),
                        const SizedBox(height: 35),
                        const Text(
                            "Learning Journey",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF434343),
                                letterSpacing: -0.5
                            )
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
              kidoPink.withOpacity(0.9),
              kidoOrange.withOpacity(0.9),
              kidoYellow.withOpacity(0.8)
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
              child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.15)),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: CircleAvatar(radius: 30, backgroundColor: Colors.white.withOpacity(0.1)),
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
              offset: const Offset(0, 15)
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [kidoPink, kidoOrange, kidoYellow])
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    (state.selectedChild?.name != null && state.selectedChild!.name.isNotEmpty)
                        ? state.selectedChild!.name[0].toUpperCase()
                        : "K",
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: kidoOrange),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${state.selectedChild?.name}!",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF434343)
                        )
                    ),
                    const Text(
                        "Everything looks great today!",
                        style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14
                        )
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
                  kidoBlue
              ),
              _buildMetric(
                  "Badges",
                  "${state.badges}",
                  Icons.stars_rounded,
                  kidoYellow
              ),
            ],
          )
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
                color: Color(0xFF434343)
            )
        ),
        Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9E9E9E),
                fontWeight: FontWeight.w500
            )
        ),
      ],
    );
  }

  Widget _buildCreativeTaskGrid(DashboardState state) {
    final items = state.level == 3 ? level3Data(state.progress) : level2Data(state.progress);
    return Column(
      children: items.map((item) => _buildModernTaskCard(item, state.previousProgress)).toList(),
    );
  }

  Widget _buildModernTaskCard(Map<String, dynamic> item, Map<String, double> prevProgress) {
    final String title = item['title'];
    final String symbol = item['symbol'];
    final double currentVal = (item['progress'] as num).toDouble();
    final double previousVal = prevProgress[title] ?? currentVal;
    final bool isUp = currentVal >= previousVal;
    final Color kidoColor = _getKidoColorByTitle(title);

    bool isImagePath = symbol.contains("assets/");

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
              offset: const Offset(0, 8)
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF434343))),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(height: 10, decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(10))),
                    FractionallySizedBox(
                      widthFactor: currentVal,
                      child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              color: kidoColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)
                          )
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
              Text("${(currentVal * 100).toInt()}%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kidoColor)
              ),
              Icon(
                  isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: isUp ? kidoGreen : kidoPink,
                  size: 20
              ),
            ],
          )
        ],
      ),
    );
  }

  Color _getKidoColorByTitle(String title) {
    switch (title.toLowerCase()) {
      case 'letters': return kidoPink;
      case 'numbers': return kidoOrange;
      case 'veggie': return kidoGreen;
      case 'fruits': return kidoBlue;
      case 'feelings': return kidoPink;
      case 'clean up': return kidoOrange;
      default: return kidoBlue;
    }
  }

  Widget _buildSwitchButton(BuildContext context) {
    return PulseButton(
      onPressed: () => context.read<DashboardBloc>().toggleChild(),
      child: Container(
        height: 70, width: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [kidoPink, kidoOrange]),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: kidoPink.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: const Icon(Icons.swap_horizontal_circle_outlined, color: Colors.white, size: 35),
      ),
    );
  }
}