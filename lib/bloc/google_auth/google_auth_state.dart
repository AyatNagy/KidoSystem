part of 'google_auth_cubit.dart';

abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final Map<String, dynamic> response;

  GoogleAuthSuccess({required this.response});
}

class GoogleAuthFailure extends GoogleAuthState {
  final String errorMessage;

  GoogleAuthFailure(this.errorMessage);
}
