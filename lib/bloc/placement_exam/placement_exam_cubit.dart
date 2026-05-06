import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Models/exams/placement_exam_model.dart';
import 'package:kido/api_service/api_services.dart';

part 'placement_exam_state.dart';

class PlacementExamCubit extends Cubit<PlacementExamState> {
  PlacementExamCubit() : super(PlacementExamInitial());

  Future<void> fetchPlacementExam({
    required int age,
    required int childId,
  }) async {
    emit(PlacementExamLoading());

    try {
      final result = await ApiService.getPlacementExam(
        age: age,
        childId: childId,
      );
      emit(PlacementExamLoaded(result));
    } catch (e) {
      emit(PlacementExamError('Failed to load placement exam'));
    }
  }

  Future<void> submitPlacementExam({
    required int childId,
    required int placementExamId,
    required double score,
  }) async {
    emit(PlacementExamLoading());
    try {
      final result = await ApiService.submitPlacementExam(
        childId: childId,
        placementExamId: placementExamId,
        score: score,
      );

      if (result['passed'] == true) {
        emit(PlacementExamPassed(result['level']));
      } else {
        emit(PlacementExamRetry(result['retryPlacementExam']));
      }
    } catch (e) {
      emit(PlacementExamError(e.toString()));
    }
  }
}
