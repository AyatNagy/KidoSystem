// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/kid/child_level_select_page.dart';
import 'package:kido/Pages/kid/child_profile_setup_page.dart';
import 'package:kido/Pages/parent_content/parent_progress_dashboard.dart';
import 'package:kido/Pages/parent_content/student_data_screen.dart';
import 'package:kido/bloc/parent_children/parent_children_cubit.dart';
import '../../Widgets/responsive_provider.dart';

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

class _ParentHomeViewState extends State<_ParentHomeView> {
  int _selectedIndex = 0;

  Future<void> _persistFromReadyState() async {
    final cubit = context.read<ParentChildrenCubit>();
    final state = cubit.state;
    if (state is ParentChildrenReady) {
      await cubit.saveAndEmit(
        List<Map<String, dynamic>>.from(state.children),
      );
    }
  }

  void _openChildDashboard(Map<String, dynamic> child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChildLevelSelectPage(
              childName: child['name'] ?? '',
              recommendedLevel: child['level'] as int?,
            ),
      ),
    );
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
        builder:
            (_) => ChildLevelSelectPage(
              childName: setup.childName,
              recommendedLevel: child['level'] as int?,
            ),
      ),
    );
    if (!mounted || pickedLevel == null) return;

    child['name'] = setup.childName;
    child['avatar'] = setup.avatarAsset;
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
          builder:
              (_) => ChildLevelSelectPage(
                childName: newChild['name'] as String,
                recommendedLevel: newChild['level'] as int?,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    final List<Widget> pages = [
      _buildHomeContent(config),
      const ParentProgressDashboard(),
      const Scaffold(body: Center(child: Text("Learn"))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent(dynamic config) {
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
                  _buildHeader(config),
                  SizedBox(height: config.localHeight * 0.03),
                  Text(
                    "Your Children",
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
                                    "No children added yet.\nTap \"Add Child\" to get started!",
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
                                final double score =
                                    (child['score'] as num?)?.toDouble() ?? 0.0;
                                final int level =
                                    (child['level'] as int?) ?? 1;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: GestureDetector(
                                    onTap: () => _openChildDashboard(child),
                                    onLongPress: () => _editChild(child),
                                    child: _buildChildCard(
                                      config,
                                      name:
                                          child['name'] as String? ??
                                          'Unknown',
                                      level: "Level $level",
                                      color: _levelColor(level),
                                      progress: score,
                                      avatarAsset: child['avatar'] as String?,
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

  Widget _buildHeader(dynamic config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(fontSize: config.body, color: Colors.grey),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Icon(
            CupertinoIcons.bell_fill,
            color: Colors.blueAccent,
            size: config.headline,
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard(
    dynamic config, {
    required String name,
    required String level,
    required Color color,
    required double progress,
    String? avatarAsset,
  }) {
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
                    : Icon(Icons.face, color: color),
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
                  level,
                  style: TextStyle(
                    fontSize: config.body * 0.85,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  color: color,
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${(progress.clamp(0.0, 1.0) * 100).toInt()}%",
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                "Hold to edit",
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
                "Add Child",
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
                  "Need advice?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: config.body,
                  ),
                ),
                Text(
                  "Ask our AI about progress",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: config.body * 0.8,
                  ),
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
            child: Text("Chat", style: TextStyle(fontSize: config.body * 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.graph_square),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.play_rectangle),
          label: "Learn",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
