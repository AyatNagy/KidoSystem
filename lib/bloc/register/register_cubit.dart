import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Models/user.dart';
import 'package:kido/api_service/api_services.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(User user) async {
    emit(RegisterLoading());

    try {
      final success = await ApiService.registerUser(user);

      if (success) {
        emit(RegisterSuccess(user: user));
      } else {
        emit(RegisterFailure("Registration failed. Try again!"));
      }
    } catch (e) {
      emit(RegisterFailure("Error during registration: ${e.toString()}"));
    }
  }
}

