part of 'child_login_cubit.dart';

abstract class ChildLoginState {}

class ChildLoginInitial extends ChildLoginState {}

class ChildLoginLoading extends ChildLoginState {}

class ChildLoginSuccess extends ChildLoginState {
  final String childName;
  final int? allowedLevel;

  ChildLoginSuccess({required this.childName, this.allowedLevel});
}

class ChildLoginFailure extends ChildLoginState {
  final String errorMessage;

  ChildLoginFailure(this.errorMessage);
}
