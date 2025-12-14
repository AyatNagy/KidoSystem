import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword(String email, String otpCode, String newPassword) async {
    emit(ResetPasswordLoading());

    try {
      final response = await ApiService.resetPassword(email, otpCode, newPassword);

      if (response != null && response['success'] == true) {
        emit(ResetPasswordSuccess(response: response));
      } else {
        emit(ResetPasswordFailure(response?['message'] ?? "Failed to reset password"));
      }
    } catch (e) {
      emit(ResetPasswordFailure("Error: ${e.toString()}"));
    }
  }
}

