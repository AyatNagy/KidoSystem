import '../Models/child.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState {
  final List<Child> children;
  final int selectedChildIndex;
  final int level;
  final Map<String, double> progress;
  final Map<String, double> previousProgress;
  final bool isLoading;

  final int completedLessons;
  final int totalLessons;
  final int accuracy;
  final int badges;
  final bool isImproving;

  DashboardState({
    this.children = const [],
    this.selectedChildIndex = 0,
    this.level = 1,
    this.progress = const {},
    this.previousProgress = const {},
    this.isLoading = true,
    this.completedLessons = 0,
    this.totalLessons = 0,
    this.accuracy = 0,
    this.badges = 0,
    this.isImproving = true,
  });

  Child? get selectedChild =>
      children.isNotEmpty ? children[selectedChildIndex] : null;

  DashboardState copyWith({
    List<Child>? children,
    int? selectedChildIndex,
    int? level,
    Map<String, double>? progress,
    Map<String, double>? previousProgress,
    bool? isLoading,
    int? completedLessons,
    int? totalLessons,
    int? accuracy,
    int? badges,
    bool? isImproving,
  }) {
    return DashboardState(
      children: children ?? this.children,
      selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      previousProgress: previousProgress ?? this.previousProgress,
      isLoading: isLoading ?? this.isLoading,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      accuracy: accuracy ?? this.accuracy,
      badges: badges ?? this.badges,
      isImproving: isImproving ?? this.isImproving,
    );
  }
}

class DashboardBloc extends Cubit<DashboardState> {
  DashboardBloc() : super(DashboardState());

  void loadDashboardData(
    Child initialChild,
    int selectedLevel,
    double score,
  ) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 800));

    Map<String, double> yesterdayProgress =
        selectedLevel == 3
            ? {
              "Letters": 0.40,
              "Numbers": 0.50,
              "Vegetables": 0.20,
              "Fruits": 0.10,
            }
            : {
              "Emotions": 0.30,
              "Self-Care": 0.50,
              "Social": 0.20,
              "Motor": 0.30,
            };

    Map<String, double> todayProgress =
        selectedLevel == 3
            ? {
              "Letters": score,
              "Numbers": 0.45,
              "Vegetables": 0.25,
              "Fruits": 0.15,
            }
            : {
              "Emotions": score,
              "Self-Care": 0.60,
              "Social": 0.40,
              "Motor": 0.35,
            };

    emit(
      DashboardState(
        children: [
          initialChild,
          Child(name: "Sibling", username: "tester", password: "123"),
        ],
        selectedChildIndex: 0,
        level: selectedLevel,
        progress: todayProgress,
        previousProgress: yesterdayProgress,
        isLoading: false,
        completedLessons: (score * 10).toInt(),
        totalLessons: 20,
        accuracy: 88,
        badges: 3,
        isImproving: true,
      ),
    );
  }

  void toggleChild() {
    final nextIndex = (state.selectedChildIndex + 1) % state.children.length;
    final nextLevel = nextIndex == 0 ? 3 : 1;

    Map<String, double> nextDayProgress =
        nextLevel == 3
            ? {"Letters": 0.7, "Numbers": 0.2, "Vegetables": 0.9, "Fruits": 0.4}
            : {"Emotions": 0.95, "Self-Care": 0.3, "Social": 0.5, "Motor": 0.8};

    emit(
      state.copyWith(
        selectedChildIndex: nextIndex,
        level: nextLevel,
        progress: nextDayProgress,
        previousProgress: state.progress,
        completedLessons: nextLevel == 3 ? 14 : 6,
        accuracy: nextLevel == 3 ? 92 : 75,
        badges: nextLevel == 3 ? 5 : 2,
        isImproving: nextLevel == 3,
        isLoading: false,
      ),
    );
  }
}
