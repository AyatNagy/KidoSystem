import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  VerifyCodeCubit() : super(VerifyCodeInitial());

  Future<void> verifyOtp(String email, String otp) async {
    if (otp.length != 4) {
      emit(VerifyCodeFailure("Please enter the 4-digit code"));
      return;
    }

    emit(VerifyCodeLoading());

    try {
      final response = await ApiService.verifyOtp(email, otp);

      if (response != null && response['success'] == true) {
        emit(VerifyCodeSuccess(response: response, otpCode: otp));
      } else {
        emit(VerifyCodeFailure(response?['message'] ?? 'Invalid OTP'));
      }
    } catch (e) {
      emit(VerifyCodeFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> resendOtp(String email) async {
    emit(VerifyCodeLoading());

    try {
      final response = await ApiService.forgetPassword(email);

      if (response != null && response['success'] == true) {
        emit(VerifyCodeResendSuccess());
      } else {
        emit(VerifyCodeFailure("Failed to resend OTP"));
      }
    } catch (e) {
      emit(VerifyCodeFailure("Error: ${e.toString()}"));
    }
  }

  void clearError() {
    if (state is VerifyCodeInitial) {
      emit(VerifyCodeInitial());
    } else if (state is VerifyCodeFailure) {
      emit(VerifyCodeInitial());
    }
  }
}

