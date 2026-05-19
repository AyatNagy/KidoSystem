// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/l10n/l10n_extension.dart';
import '../../Models/child.dart';
import '../../Widgets/Layout/header_clipper.dart';
import '../../Widgets/Buttons/puls_button.dart';
import '../../bloc/dashoard.dart';
import '../../bloc/parent_children/parent_children_cubit.dart';
import '../../constants.dart';
import '../../data/dashboard.dart';

class Dashboard extends StatelessWidget {
  final Map<String, dynamic> childData;
  final VoidCallback? onSwitchChild;

  const Dashboard({
    super.key,
    required this.childData,
    this.onSwitchChild,
  });

  Child get _childModel => Child(
        id: (childData['id'] as num?)?.toInt(),
        username: childData['username'] as String? ?? '',
        password: '',
        name: childData['name'] as String? ?? 'Kid',
      );

  int get _childId => (childData['id'] as num?)?.toInt() ?? 0;

  int get _allowedLevel =>
      (childData['allowedLevel'] as int?) ??
      (childData['level'] as int?) ??
      1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()
        ..loadDashboardData(
          child: _childModel,
          childId: _childId,
          allowedLevel: _allowedLevel,
          childMeta: childData,
        ),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final l10n = context.l10n;
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
                  child: RefreshIndicator(
                    color: AppColors.kidoPink,
                    onRefresh: () async {
                      final cubit = context.read<ParentChildrenCubit>();
                      final bloc = context.read<DashboardBloc>();
                      try {
                        await cubit.loadChildren();
                      } catch (_) {}
                      if (!context.mounted) return;
                      Map<String, dynamic> meta = childData;
                      final childrenState = cubit.state;
                      if (childrenState is ParentChildrenReady) {
                        for (final c in childrenState.children) {
                          if (c['id'] == childData['id']) {
                            meta = c;
                            break;
                          }
                        }
                      }
                      await bloc.refresh(childMeta: meta);
                    },
                    child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          l10n.dashboard,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildModernHeroCard(state, l10n),
                        const SizedBox(height: 35),
                        Text(
                          l10n.learningJourney,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildCreativeTaskGrid(state, l10n),
                        const SizedBox(height: 100),
                      ],
                    ),
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

  Widget _buildModernHeroCard(DashboardState state, dynamic l10n) {
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
                      '${state.selectedChild?.name ?? l10n.defaultKidName}!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      l10n.everythingLooksGreat,
                      style: const TextStyle(color: AppColors.textGray, fontSize: 14),
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
                l10n.accuracy,
                "${state.accuracy}%",
                Icons.track_changes_rounded,
                AppColors.kidoBlue,
              ),
              _buildMetric(
                l10n.badges,
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

  Widget _buildCreativeTaskGrid(DashboardState state, dynamic l10n) {
    List<Map<String, dynamic>> taskItems = [];
    if (state.level == 3) {
      taskItems = level3Data(state.progress);
    } else if (state.level == 2) {
      taskItems = level2Data(state.progress);
    } else {
      taskItems = level1Data(state.progress);
    }
    // Only categories for this child's allowed level; hide empty catalog slots.
    taskItems = taskItems.where((item) {
      final title = item['title'] as String? ?? '';
      final progressKey = _progressKeyForTitle(title, state.level);
      return state.progress.containsKey(progressKey);
    }).toList();

    return Column(
      children: taskItems
          .map((item) => _buildModernTaskCard(item, state.previousProgress, l10n))
          .toList(),
    );
  }

  String _progressKeyForTitle(String title, int level) {
    if (level == 3) {
      switch (title.toLowerCase()) {
        case 'veggie':
          return 'Vegetables';
        default:
          return title;
      }
    }
    if (level == 1) {
      switch (title.toLowerCase()) {
        case 'feelings':
          return 'Emotions';
        case 'pegboard':
          return 'PegBoard';
        default:
          return title;
      }
    }
    return title;
  }

  Widget _buildModernTaskCard(
      Map<String, dynamic> item,
      Map<String, double> prevProgress,
      dynamic l10n,
      ) {
    final String rawTitle = item['title'] ?? 'Task';
    final String title = l10n.categoryTitle(rawTitle);
    final String symbol = item['symbol'] ?? '✨';
    final double currentVal = (item['progress'] as num? ?? 0.0).toDouble();
    final double previousVal = prevProgress[rawTitle] ?? currentVal;
    final bool isUp = currentVal >= previousVal;
    final Color kidoColor = _getKidoColorByTitle(rawTitle);

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
      onPressed: onSwitchChild ?? () => Navigator.of(context).maybePop(),
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