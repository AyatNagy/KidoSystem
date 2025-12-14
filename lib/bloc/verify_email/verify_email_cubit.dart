import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit() : super(VerifyEmailInitial());

  void updateOtpCode(String otpCode) {
    if (state is VerifyEmailInitial) {
      emit((state as VerifyEmailInitial).copyWith(otpCode: otpCode, errorMessage: null));
    } else if (state is VerifyEmailFailure) {
      emit(VerifyEmailInitial(otpCode: otpCode));
    }
  }

  Future<void> verifyOtp(String email, String otpCode) async {
    if (otpCode.length != 4) {
      emit(VerifyEmailFailure("Please enter the 4-digit code", otpCode: otpCode));
      return;
    }

    emit(VerifyEmailLoading());

    try {
      final result = await ApiService.verifyOtp(email, otpCode);

      if (result != null) {
        emit(VerifyEmailSuccess());
      } else {
        emit(VerifyEmailFailure("Invalid or expired OTP", otpCode: otpCode));
      }
    } catch (e) {
      emit(VerifyEmailFailure("Invalid or expired OTP", otpCode: otpCode));
    }
  }

  void dismissError() {
    if (state is VerifyEmailInitial) {
      emit((state as VerifyEmailInitial).copyWith(errorMessage: null));
    } else if (state is VerifyEmailFailure) {
      emit(VerifyEmailInitial());
    }
  }
}

