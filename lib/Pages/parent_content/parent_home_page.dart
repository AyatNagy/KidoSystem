// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/kid/child_level_select_page.dart';
import 'package:kido/Pages/kid/child_profile_setup_page.dart';
import 'package:kido/Pages/parent_content/profile_page.dart';
import 'package:kido/Pages/parent_content/student_data_screen.dart';
import 'package:kido/bloc/assessment/assessment_cubit.dart';
import 'package:kido/bloc/parent_children/parent_children_cubit.dart';
import 'package:kido/config/app_locale_scope.dart';
import 'package:kido/constants.dart';
import 'package:kido/l10n/app_localizations.dart';
import '../../Widgets/responsive_provider.dart';
import 'parent_dashboard_flow.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParentChildrenCubit()..loadChildren(),
      child: const _ParentHomeView(),
    );
  }
}

class _ParentHomeView extends StatefulWidget {
  const _ParentHomeView();

  @override
  State<_ParentHomeView> createState() => _ParentHomeViewState();
}

class _ParentHomeViewState extends State<_ParentHomeView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _levelUpdateAnimController;

  @override
  void initState() {
    super.initState();
    _levelUpdateAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _levelUpdateAnimController.dispose();
    super.dispose();
  }

  Future<void> _persistFromReadyState() async {
    final cubit = context.read<ParentChildrenCubit>();
    final state = cubit.state;
    if (state is ParentChildrenReady) {
      await cubit.saveAndEmit(List<Map<String, dynamic>>.from(state.children));
    }
  }

  Future<void> _openChildDashboard(Map<String, dynamic> child) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChildLevelSelectPage(
          childName: child['name'] ?? '',
          childId: child['id'] as int? ?? 0,
          recommendedLevel:
          child['allowedLevel'] as int? ?? child['level'] as int? ?? 1,
        ),
      ),
    );
    if (mounted) {
      await context.read<ParentChildrenCubit>().loadChildren();
    }
  }

  Future<void> _editChild(Map<String, dynamic> child) async {
    final setup = await Navigator.push<ChildProfileSetupResult>(
      context,
      MaterialPageRoute(
        builder: (_) => ChildProfileSetupPage(childName: child['name'] ?? ''),
      ),
    );
    if (!mounted || setup == null) return;

    final pickedLevel = await Navigator.push<ChildLevelSelectResult>(
      context,
      MaterialPageRoute(
        builder: (_) => ChildLevelSelectPage(
          childName: setup.childName,
          childId: child['id'] as int? ?? 0,
          recommendedLevel:
          child['allowedLevel'] as int? ?? child['level'] as int?,
        ),
      ),
    );
    if (!mounted || pickedLevel == null) return;

    child['name'] = setup.childName;
    child['avatar'] = setup.avatarAsset;
    child['allowedLevel'] = pickedLevel.level;
    child['level'] = pickedLevel.level;
    await _persistFromReadyState();
  }

  Future<void> _goToAddChild() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentData()),
    );

    if (result != null && result is Map<String, dynamic>) {
      final newChild = {
        if (result['childId'] != null) 'id': result['childId'],
        'name': result['name'] ?? '',
        'avatar': result['avatar'],
        'level': result['level'] ?? 1,
        'allowedLevel': result['level'] ?? 1,
        'score': (result['score'] as num?)?.toDouble() ?? 0.0,
      };

      final cubit = context.read<ParentChildrenCubit>();
      final state = cubit.state;
      final existing =
      state is ParentChildrenReady
          ? List<Map<String, dynamic>>.from(state.children)
          : <Map<String, dynamic>>[];

      await cubit.saveAndEmit([...existing, newChild]);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChildLevelSelectPage(
            childName: newChild['name'] as String,
            childId: newChild['id'] as int? ?? 0,
            recommendedLevel: newChild['allowedLevel'] as int?,
          ),
        ),
      );
    }
  }

  Future<void> _onLevelUnlocked(dynamic result) async {
    await context.read<ParentChildrenCubit>().loadChildren();

    _levelUpdateAnimController.forward().then(
          (_) => _levelUpdateAnimController.reverse(),
    );

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.orange, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.levelUnlocked(result.currentAllowedLevel),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      BlocListener<AssessmentCubit, AssessmentState>(
        listener: (context, state) {
          if (state is AssessmentSuccess && state.result.levelUnlocked) {
            _onLevelUnlocked(state.result);
          }
        },
        child: _buildHomeContent(context, config),
      ),
      const ParentDashboardFlow(),
      ProfilePage(
        onLanguageChanged: (Locale newLocale) {
          AppLocaleScope.of(context).setLocale(newLocale);
        },
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _buildBottomNav(l10n),
    );
  }

  Widget _buildHomeContent(BuildContext context, dynamic config) {
    return Stack(
      children: [
        SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<ParentChildrenCubit>().loadChildren(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(config.localWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, config),
                  SizedBox(height: config.localHeight * 0.03),
                  Text(
                    AppLocalizations.of(context)!.yourChildren,
                    style: TextStyle(
                      fontSize: config.title,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.02),
                  BlocBuilder<ParentChildrenCubit, ParentChildrenState>(
                    builder: (context, state) {
                      if (state is ParentChildrenLoading) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: config.localHeight * 0.08,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is ParentChildrenReady) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.notice != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.amber.shade900,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            state.notice!,
                                            style: TextStyle(
                                              fontSize: config.body * 0.85,
                                              color: Colors.amber.shade900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (state.children.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.noChildrenYet,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: config.body,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...state.children.map((child) {
                                final int level =
                                    (child['allowedLevel'] as int?) ??
                                        (child['level'] as int?) ??
                                        1;
                                final childName =
                                    child['name'] as String? ??
                                        AppLocalizations.of(context)!.unknown;
                                final double progress = (level / 3.0).clamp(
                                  0.0,
                                  1.0,
                                );

                                return ScaleTransition(
                                  scale:
                                  _levelUpdateAnimController.isAnimating
                                      ? Tween<double>(
                                    begin: 1.0,
                                    end: 1.05,
                                  ).animate(
                                    CurvedAnimation(
                                      parent:
                                      _levelUpdateAnimController,
                                      curve: Curves.elasticInOut,
                                    ),
                                  )
                                      : const AlwaysStoppedAnimation(1.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      onTap: () => _openChildDashboard(child),
                                      onLongPress: () => _editChild(child),
                                      child: _buildChildCard(
                                        context,
                                        config,
                                        name: childName,
                                        level: level,
                                        progress: progress,
                                        avatarAsset: child['avatar'] as String?,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  _buildAddChildButton(config),
                  SizedBox(height: config.localHeight * 0.15),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: _buildAIChatCard(config),
        ),
      ],
    );
  }

  Color _levelColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF2C8FF9);
      case 2:
        return const Color(0xFFFF8A65);
      case 3:
        return const Color(0xFFF06292);
      default:
        return const Color(0xFF2C8FF9);
    }
  }

  Widget _buildHeader(BuildContext context, dynamic config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.welcomeBack,
          style: TextStyle(fontSize: config.body, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildChildCard(
      BuildContext context,
      dynamic config, {
        required String name,
        required int level,
        required double progress,
        String? avatarAsset,
      }) {
    final l10n = AppLocalizations.of(context)!;
    final color = _levelColor(level);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(config.localWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child:
            avatarAsset != null
                ? ClipOval(
              child: Image.asset(
                avatarAsset,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : Image.asset('assets/images/characters/boy.gif'),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: config.body,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${l10n.levelLabel} $level',
                  style: TextStyle(
                    fontSize: config.body * 0.85,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    color: color,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${l10n.levelLabel} $level',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.holdToEdit,
                style: TextStyle(
                  fontSize: config.body * 0.7,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildButton(dynamic config) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: config.localHeight * 0.1,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: _goToAddChild,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.add_circled,
                size: config.headline,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.addChild,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: config.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIChatCard(dynamic config) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(config.localWidth * 0.05),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.sparkles,
            color: Colors.white,
            size: config.headline,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.needAdvice,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: config.body,
                  ),
                ),
                Text(
                  l10n.askAiProgress,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: config.body * 0.8),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(
              l10n.chat,
              style: TextStyle(fontSize: config.body * 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(AppLocalizations l10n) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) async {
        setState(() => _selectedIndex = index);
        if (index == 1) {
          await context.read<ParentChildrenCubit>().loadChildren();
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.home),
          label: l10n.navHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.graph_square),
          label: l10n.navDashboard,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.person),
          label: l10n.navProfile,
        ),
      ],
    );
  }
}