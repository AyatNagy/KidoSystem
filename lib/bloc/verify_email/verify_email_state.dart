part of 'verify_email_cubit.dart';

abstract class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {
  final String otpCode;
  final bool isLoading;
  final String? errorMessage;

  VerifyEmailInitial({
    this.otpCode = "",
    this.isLoading = false,
    this.errorMessage,
  });

  VerifyEmailInitial copyWith({
    String? otpCode,
    bool? isLoading,
    String? errorMessage,
  }) {
    return VerifyEmailInitial(
      otpCode: otpCode ?? this.otpCode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailSuccess extends VerifyEmailState {}

class VerifyEmailFailure extends VerifyEmailState {
  final String errorMessage;
  final String otpCode;

  VerifyEmailFailure(this.errorMessage, {this.otpCode = ""});
}

