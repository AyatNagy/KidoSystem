import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());

    try {
      final response = await ApiService.loginUser(email, password);

      if (response != null) {
        emit(LoginSuccess(response: response));
      } else {
        emit(LoginFailure("Login failed. Check your credentials."));
      }
    } catch (e) {
      emit(LoginFailure("Error during login: ${e.toString()}"));
    }
  }
}

