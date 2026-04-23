part of 'child_register_cubit.dart';

abstract class ChildRegisterState {}

class ChildRegisterInitial extends ChildRegisterState {}

class ChildRegisterLoading extends ChildRegisterState {}

class ChildRegisterSuccess extends ChildRegisterState {
  final Child child;

  ChildRegisterSuccess({required this.child});
}

class ChildRegisterFailure extends ChildRegisterState {
  final String errorMessage;

  ChildRegisterFailure(this.errorMessage);
}
