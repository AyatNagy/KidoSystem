import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/api_service/api_services.dart';

part 'child_login_state.dart';

class ChildLoginCubit extends Cubit<ChildLoginState> {
  ChildLoginCubit() : super(ChildLoginInitial());

  Future<void> login(String username, String password) async {
    emit(ChildLoginLoading());

    try {
      final result = await ApiService.loginChild(username.trim(), password);

      if (result != null &&
          result['success'] == true &&
          result['child'] != null) {
        final child = result['child'] as Map<String, dynamic>;
        final name = child['name'] as String? ?? username.trim();
        final allowed = (child['allowedLevel'] as num?)?.toInt();
        emit(ChildLoginSuccess(childName: name, allowedLevel: allowed));
        return;
      }

      final msg =
          result != null && result['message'] is String
              ? result['message'] as String
              : 'Could not sign in. Check username and password.';
      emit(ChildLoginFailure(msg));
    } catch (e) {
      emit(ChildLoginFailure(e.toString()));
    }
  }
}
