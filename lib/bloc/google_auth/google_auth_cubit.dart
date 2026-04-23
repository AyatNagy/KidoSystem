import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/auth_services.dart';

part 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final GoogleAuthServices _googleAuthServices = GoogleAuthServices();

  GoogleAuthCubit() : super(GoogleAuthInitial());

  Future<void> signInWithGoogle() async {
    emit(GoogleAuthLoading());

    try {
      final result = await _googleAuthServices.signinWithGoogle();

      if (result != null) {
        emit(GoogleAuthSuccess(response: result));
      } else {
        emit(GoogleAuthFailure("Google Login Failed"));
      }
    } catch (e) {
      emit(GoogleAuthFailure("Error during Google login: ${e.toString()}"));
    }
  }
}
