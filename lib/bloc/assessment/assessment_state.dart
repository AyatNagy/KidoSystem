part of 'assessment_cubit.dart';

abstract class AssessmentState {}

class AssessmentInitial extends AssessmentState {}

class AssessmentLoading extends AssessmentState {}

class AssessmentSuccess extends AssessmentState {
  final AssessmentResult result;

  AssessmentSuccess(this.result);
}

class AssessmentError extends AssessmentState {
  final String message;

  AssessmentError(this.message);
}
