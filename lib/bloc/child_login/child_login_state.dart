part of 'child_login_cubit.dart';

abstract class ChildLoginState {}

class ChildLoginInitial extends ChildLoginState {}

class ChildLoginLoading extends ChildLoginState {}

class ChildLoginSuccess extends ChildLoginState {
  final String childName;
  final int? allowedLevel;
  final int childId;

  ChildLoginSuccess({
    required this.childName,
    required this.childId,
    this.allowedLevel,
  });
}

class ChildLoginFailure extends ChildLoginState {
  final String errorMessage;

  ChildLoginFailure(this.errorMessage);
}
