import '../Models/child.dart';
import '../Models/progress_report.dart';
import '../api_service/api_services.dart';
import '../data/lesson_catalog.dart';
import '../utils/dashboard_progress_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState {
  final Child? selectedChild;
  final int childId;
  final int level;
  final Map<String, double> progress;
  final Map<String, double> previousProgress;
  final bool isLoading;

  final int completedLessons;
  final int totalLessons;
  final int accuracy;
  final int badges;
  final bool isImproving;

  final ProgressReport? report;
  final int? assessmentScore;
  final String? assessmentLevel;

  DashboardState({
    this.selectedChild,
    this.childId = 0,
    this.level = 1,
    this.progress = const {},
    this.previousProgress = const {},
    this.isLoading = true,
    this.completedLessons = 0,
    this.totalLessons = 0,
    this.accuracy = 0,
    this.badges = 0,
    this.isImproving = true,
    this.report,
    this.assessmentScore,
    this.assessmentLevel,
  });

  DashboardState copyWith({
    Child? selectedChild,
    int? childId,
    int? level,
    Map<String, double>? progress,
    Map<String, double>? previousProgress,
    bool? isLoading,
    int? completedLessons,
    int? totalLessons,
    int? accuracy,
    int? badges,
    bool? isImproving,
    ProgressReport? report,
    int? assessmentScore,
    String? assessmentLevel,
  }) {
    return DashboardState(
      selectedChild: selectedChild ?? this.selectedChild,
      childId: childId ?? this.childId,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      previousProgress: previousProgress ?? this.previousProgress,
      isLoading: isLoading ?? this.isLoading,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      accuracy: accuracy ?? this.accuracy,
      badges: badges ?? this.badges,
      isImproving: isImproving ?? this.isImproving,
      report: report ?? this.report,
      assessmentScore: assessmentScore ?? this.assessmentScore,
      assessmentLevel: assessmentLevel ?? this.assessmentLevel,
    );
  }
}

class DashboardBloc extends Cubit<DashboardState> {
  DashboardBloc() : super(DashboardState());

  Future<void> loadDashboardData({
    required Child child,
    required int childId,
    required int allowedLevel,
    Map<String, dynamic>? childMeta,
  }) async {
    emit(state.copyWith(isLoading: true));

    final level = allowedLevel.clamp(1, 3);
    final previousProgress = Map<String, double>.from(state.progress);

    ProgressReport? report;
    try {
      report = await ApiService.fetchChildProgressAsParent(childId);
    } catch (_) {
      report = null;
    }

    final progress = DashboardProgressMapper.buildProgress(
      allowedLevel: level,
      report: report,
    );

    final completed =
        report?.completedLessons ??
        (childMeta?['completedLessons'] as num?)?.toInt() ??
        0;
    final reportTotal = report?.totalLessons ?? 0;
    final total = reportTotal > 0
        ? reportTotal
        : LessonCatalog.totalLessonsUpToLevel(level);
    final pct =
        report?.completionPercentage ??
        (total > 0 ? ((completed / total) * 100).round() : 0);

    int? assessmentScore;
    String? assessmentLevel;
    final assessment = childMeta?['latestAssessment'];
    if (assessment is Map) {
      assessmentScore = (assessment['score'] as num?)?.toInt();
      assessmentLevel = assessment['level']?.toString();
    }

    final improving =
        previousProgress.isEmpty ||
        progress.entries.every((e) {
          final prev = previousProgress[e.key] ?? 0;
          return e.value >= prev;
        });

    emit(
      DashboardState(
        selectedChild: child,
        childId: childId,
        level: level,
        progress: progress,
        previousProgress:
            previousProgress.isEmpty ? progress : previousProgress,
        isLoading: false,
        completedLessons: completed,
        totalLessons: total,
        accuracy: pct.clamp(0, 100),
        badges: assessmentScore ?? completed.clamp(0, 99),
        isImproving: improving,
        report: report,
        assessmentScore: assessmentScore,
        assessmentLevel: assessmentLevel,
      ),
    );
  }

  Future<void> refresh({Map<String, dynamic>? childMeta}) async {
    final child = state.selectedChild;
    if (child == null || state.childId == 0) return;
    await loadDashboardData(
      child: child,
      childId: state.childId,
      allowedLevel: state.level,
      childMeta: childMeta,
    );
  }
}
