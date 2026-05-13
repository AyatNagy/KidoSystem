// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Models/progress_report.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/api_service/api_services.dart';
import 'package:kido/bloc/parent_children/parent_children_cubit.dart';
import 'package:kido/data/lesson_catalog.dart';

String _initialLetter(String name) {
  final n = name.trim();
  if (n.isEmpty) return '?';
  return String.fromCharCodes(n.runes.take(1));
}

const _level1Colors = [Color(0xFF6EC6F5), Color(0xFF3A8EE6)];
const _level2Colors = [Color(0xFFFFB347), Color(0xFFFF6B35)];
const _level3Colors = [Color(0xFFB06EF5), Color(0xFF7B2FF7)];

List<Color> _levelGradient(int level) {
  if (level == 1) return _level1Colors;
  if (level == 2) return _level2Colors;
  return _level3Colors;
}

Color _levelAccent(int level) => _levelGradient(level).last;

class ParentProgressDashboard extends StatefulWidget {
  const ParentProgressDashboard({super.key});

  @override
  State<ParentProgressDashboard> createState() =>
      _ParentProgressDashboardState();
}

class _ParentProgressDashboardState extends State<ParentProgressDashboard>
    with SingleTickerProviderStateMixin {
  final Map<int, ProgressReport?> _reports = {};
  bool _loadingDetails = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDetailReports() async {
    final state = context.read<ParentChildrenCubit>().state;
    if (state is! ParentChildrenReady) return;
    setState(() => _loadingDetails = true);

    final tasks = <Future<void>>[];
    for (final c in state.children) {
      final rawId = c['id'];
      if (rawId == null) continue;
      final childId = (rawId as num).toInt();
      tasks.add(() async {
        final report = await ApiService.fetchChildProgressAsParent(childId);
        if (!mounted) return;
        setState(() => _reports[childId] = report);
      }());
    }
    await Future.wait(tasks);
    if (mounted) setState(() => _loadingDetails = false);
  }

  Future<void> _onRefresh() async {
    await context.read<ParentChildrenCubit>().loadChildren();
    await _loadDetailReports();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: BlocConsumer<ParentChildrenCubit, ParentChildrenState>(
          listenWhen: (_, curr) => curr is ParentChildrenReady,
          listener: (context, state) {
            if (state is ParentChildrenReady) _loadDetailReports();
          },
          builder: (context, state) {
            return FadeTransition(
              opacity: _fadeAnim,
              child: RefreshIndicator(
                color: const Color(0xFF6EC6F5),
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ── Header ──
                    SliverToBoxAdapter(child: _buildHeader(config)),

                    // ── Content ──
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: config.localWidth * 0.05,
                      ),
                      sliver: _buildBody(context, config, state),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic config) {
    return Container(
      margin: EdgeInsets.all(config.localWidth * 0.05),
      padding: EdgeInsets.symmetric(
        horizontal: config.localWidth * 0.05,
        vertical: config.localHeight * 0.022,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A8EE6), Color(0xFF6EC6F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A8EE6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تقدّم الأطفال',
                  style: TextStyle(
                    fontSize: config.headline * 0.75,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: config.localHeight * 0.005),
                Text(
                  'مستوى كل طفل وإنجاز الدروس حسب الفئة',
                  style: TextStyle(
                    fontSize: config.body * 0.85,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          if (_loadingDetails)
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    dynamic config,
    ParentChildrenState state,
  ) {
    if (state is ParentChildrenLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is ParentChildrenReady && state.children.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                'لا يوجد أطفال بعد\nأضيفي طفلاً من الصفحة الرئيسية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: config.body,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is ParentChildrenReady) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
          final child = state.children[i];
          final childId = (child['id'] as num?)?.toInt();
          return Padding(
            padding: EdgeInsets.only(bottom: config.localHeight * 0.018),
            child: _ChildProgressCard(
              config: config,
              child: child,
              report: childId != null ? _reports[childId] : null,
            ),
          );
        }, childCount: state.children.length),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

class _ChildProgressCard extends StatelessWidget {
  final dynamic config;
  final Map<String, dynamic> child;
  final ProgressReport? report;

  const _ChildProgressCard({
    required this.config,
    required this.child,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final name = child['name'] as String? ?? 'طفل';
    final level = (child['level'] as int?) ?? 1;
    final completed =
        (child['completedLessons'] as num?)?.toInt() ??
        report?.completedLessons ??
        0;
    final expected =
        (child['expectedLessons'] as num?)?.toInt() ??
        LessonCatalog.totalLessonsUpToLevel(level);
    final pct =
        expected > 0 ? ((completed / expected) * 100).round().clamp(0, 100) : 0;

    final gradColors = _levelGradient(level);
    final accent = _levelAccent(level);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.fromLTRB(
              config.localWidth * 0.04,
              10,
              config.localWidth * 0.04,
              4,
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              config.localWidth * 0.04,
              0,
              config.localWidth * 0.04,
              18,
            ),
            shape: const RoundedRectangleBorder(),
            collapsedShape: const RoundedRectangleBorder(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradColors),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: config.localHeight * 0.012),
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _initialLetter(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: config.localWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: config.body * 1.05,
                              color: const Color(0xFF1A2340),
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              _LevelBadge(level: level, colors: gradColors),
                              SizedBox(width: 8),
                              Text(
                                '$pct% مكتمل',
                                style: TextStyle(
                                  fontSize: config.body * 0.78,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // ── Progress bar ──
            subtitle: Padding(
              padding: EdgeInsets.only(top: config.localHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الإنجاز الكلي',
                        style: TextStyle(
                          fontSize: config.body * 0.78,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        '$completed / $expected درس',
                        style: TextStyle(
                          fontSize: config.body * 0.78,
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  _AnimatedProgressBar(
                    value: expected > 0 ? completed / expected : 0,
                    gradient: gradColors,
                  ),
                ],
              ),
            ),
            // ── Expanded: categories ──
            children: [
              const Divider(height: 24, thickness: 0.5),
              if (report == null || report!.grouped.isEmpty)
                _NoDetailWidget(config: config)
              else
                ..._buildGrouped(config, report!),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGrouped(dynamic config, ProgressReport r) {
    final widgets = <Widget>[];
    final levelKeys = r.grouped.keys.toList()..sort();

    for (final levelName in levelKeys) {
      final cats = r.grouped[levelName];
      if (cats == null || cats.isEmpty) continue;

      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: config.localHeight * 0.008),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A8EE6), Color(0xFF6EC6F5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                levelName,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: config.body * 0.95,
                  color: const Color(0xFF1A2340),
                ),
              ),
            ],
          ),
        ),
      );

      final catKeys = cats.keys.toList()..sort();
      for (final catName in catKeys) {
        final lessons = cats[catName] ?? [];
        final done = lessons.where((l) => l.isCompleted).length;
        final total = lessons.length;
        final catPct = total > 0 ? done / total : 0.0;

        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: config.localHeight * 0.009),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: config.localWidth * 0.04,
                vertical: config.localHeight * 0.012,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8EEF6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        catName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: config.body * 0.88,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              catPct == 1.0
                                  ? const Color(0xFF66BB6A).withOpacity(0.12)
                                  : const Color(0xFF3A8EE6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$done / $total',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: config.body * 0.82,
                            color:
                                catPct == 1.0
                                    ? const Color(0xFF388E3C)
                                    : const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: config.localHeight * 0.007),
                  _AnimatedProgressBar(
                    value: catPct,
                    gradient:
                        catPct == 1.0
                            ? const [Color(0xFF66BB6A), Color(0xFF43A047)]
                            : const [Color(0xFF6EC6F5), Color(0xFF3A8EE6)],
                    height: 6,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      widgets.add(SizedBox(height: config.localHeight * 0.008));
    }
    return widgets;
  }
}

class _LevelBadge extends StatelessWidget {
  final int level;
  final List<Color> colors;
  const _LevelBadge({required this.level, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'المستوى $level',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double value;
  final List<Color> gradient;
  final double height;

  const _AnimatedProgressBar({
    required this.value,
    required this.gradient,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(height),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              width: constraints.maxWidth * value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(height),
                boxShadow: [
                  BoxShadow(
                    color: gradient.last.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NoDetailWidget extends StatelessWidget {
  final dynamic config;
  const _NoDetailWidget({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⏳', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'التفصيل حسب الفئة يظهر بعد إضافة:\nGET /api/child/:childId/progress',
              style: TextStyle(
                fontSize: config.body * 0.82,
                height: 1.5,
                color: const Color(0xFF7B5800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
