part of 'verify_code_cubit.dart';

abstract class VerifyCodeState {}

class VerifyCodeInitial extends VerifyCodeState {
  final bool hasError;

  VerifyCodeInitial({this.hasError = false});
}

class VerifyCodeLoading extends VerifyCodeState {}

class VerifyCodeSuccess extends VerifyCodeState {
  final Map<String, dynamic> response;
  final String otpCode;

  VerifyCodeSuccess({required this.response, required this.otpCode});
}

class VerifyCodeResendSuccess extends VerifyCodeState {}

class VerifyCodeFailure extends VerifyCodeState {
  final String errorMessage;

  VerifyCodeFailure(this.errorMessage);
}

