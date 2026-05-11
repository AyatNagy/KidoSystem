import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'set_initial_level_state.dart';

/// Calls backend `setInitialLevel` via [ApiService.setChildAllowedLevel].
class SetInitialLevelCubit extends Cubit<SetInitialLevelState> {
  SetInitialLevelCubit() : super(SetInitialLevelInitial());

  Future<bool> setInitialLevel({
    required int childId,
    required int levelId,
  }) async {
    emit(SetInitialLevelLoading());

    try {
      final result = await ApiService.setChildAllowedLevel(
        childId: childId,
        levelId: levelId,
      );

      if (result != null && result['success'] == true) {
        final raw = result['allowedLevel'];
        final allowed =
            raw is int
                ? raw
                : (raw is num ? raw.toInt() : levelId);
        emit(SetInitialLevelSuccess(allowedLevel: allowed));
        return true;
      }

      final msg =
          result != null && result['message'] is String
              ? result['message'] as String
              : 'Could not update child level.';
      emit(SetInitialLevelFailure(msg));
      return false;
    } catch (e) {
      emit(SetInitialLevelFailure(e.toString()));
      return false;
    }
  }
}
