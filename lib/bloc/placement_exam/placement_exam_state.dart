part of 'placement_exam_cubit.dart';

abstract class PlacementExamState {}

class PlacementExamInitial extends PlacementExamState {}

class PlacementExamLoading extends PlacementExamState {}

class PlacementExamLoaded extends PlacementExamState {
  final PlacementExamResult result;
  PlacementExamLoaded(this.result);
}

class PlacementExamPassed extends PlacementExamState {
  final Map<String, dynamic> level;
  PlacementExamPassed(this.level);
}

class PlacementExamRetry extends PlacementExamState {
  final Map<String, dynamic>? exam;
  PlacementExamRetry(this.exam);
}

class PlacementExamError extends PlacementExamState {
  final String message;
  PlacementExamError(this.message);
}
