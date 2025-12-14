import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());

    try {
      final response = await ApiService.forgetPassword(email);

      if (response != null) {
        emit(ForgetPasswordSuccess(response: response, email: email));
      } else {
        emit(ForgetPasswordFailure("Failed to send verification code"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("Error: ${e.toString()}"));
    }
  }
}

