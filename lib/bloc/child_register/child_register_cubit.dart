import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Models/child.dart';
import 'package:kido/api_service/api_services.dart';

part 'child_register_state.dart';

class ChildRegisterCubit extends Cubit<ChildRegisterState> {
  ChildRegisterCubit() : super(ChildRegisterInitial());

  Future<void> registerChild(Child child) async {
    emit(ChildRegisterLoading());

    try {
      final response = await ApiService.registerChild(child);

      if (response != null && response['success'] == true) {
        final childData = response['child'];
        final registeredChild = Child(
          id: childData['id'],
          username: childData['username'],
          password: child.password, // Keep original password (not hashed)
          name: childData['name'],
          dateOfBirth: childData['dateOfBirth'] != null
              ? DateTime.tryParse(childData['dateOfBirth'])
              : null,
          motherId: childData['motherId'],
          createdAt: childData['createdAt'] != null
              ? DateTime.tryParse(childData['createdAt'])
              : null,
        );
        emit(ChildRegisterSuccess(child: registeredChild));
      } else {
        final errorMessage = response?['message'] ?? "Child registration failed. Try again!";
        emit(ChildRegisterFailure(errorMessage));
      }
    } catch (e) {
      emit(ChildRegisterFailure("Error during child registration: ${e.toString()}"));
    }
  }
}

