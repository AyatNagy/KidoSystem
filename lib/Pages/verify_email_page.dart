import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'package:kido/Widgets/otp_input_widget.dart';
import 'package:kido/bloc/verify_email/verify_email_cubit.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final GlobalKey<OtpInputWidgetState> _otpInputKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyEmailCubit(),
      child: BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
        listener: (context, state) {
          if (state is VerifyEmailSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ParentLogin()),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<VerifyEmailCubit>();
          final isLoading = state is VerifyEmailLoading;
          final errorMessage =
              state is VerifyEmailFailure
                  ? state.errorMessage
                  : (state is VerifyEmailInitial ? state.errorMessage : null);

          return Scaffold(
            appBar: AppBar(title: const Text("Verify Email")),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Enter the verification code sent to:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 5),

                  Text(
                    widget.email,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  /// OTP INPUT
                  OtpInputWidget(
                    key: _otpInputKey,
                    onCompleted: (otp) {
                      cubit.updateOtpCode(otp);
                      // Auto-verify when all 4 digits are entered
                      cubit.verifyOtp(widget.email, otp);
                    },
                  ),

                  const SizedBox(height: 20),

                  if (errorMessage != null)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                // Get OTP from the widget directly
                                final otpCode =
                                    _otpInputKey.currentState
                                        ?.getCurrentOtp() ??
                                    "";
                                final currentState = state;
                                String finalOtp = otpCode;

                                // Fallback to state if widget doesn't have it
                                if (finalOtp.isEmpty) {
                                  if (currentState is VerifyEmailInitial) {
                                    finalOtp = currentState.otpCode;
                                  } else if (currentState
                                      is VerifyEmailFailure) {
                                    finalOtp = currentState.otpCode;
                                  }
                                }

                                cubit.verifyOtp(widget.email, finalOtp);
                              },
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text("Verify"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
