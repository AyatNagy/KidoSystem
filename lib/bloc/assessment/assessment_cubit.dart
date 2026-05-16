import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Models/exams/assessment_result.dart';
import 'package:kido/api_service/api_services.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  AssessmentCubit() : super(AssessmentInitial());

  Future<void> submitAssessment({
    required int score,
    required int level,
    required int childId,
  }) async {
    emit(AssessmentLoading());

    try {
      final result = await ApiService.submitAssessment(
        score: score,
        level: level,
        childId: childId,
      );

      if (result == null) {
        emit(AssessmentError('No response from server'));
        return;
      }

      if (result['success'] == true) {
        final assessmentResult = AssessmentResult.fromJson(result);
        emit(AssessmentSuccess(assessmentResult));
      } else {
        final msg = result['message'] as String? ?? 'Submission failed';
        emit(AssessmentError(msg));
      }
    } catch (e) {
      emit(AssessmentError(e.toString()));
    }
  }

  void reset() => emit(AssessmentInitial());
}
