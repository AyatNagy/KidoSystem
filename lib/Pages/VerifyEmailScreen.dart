import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'package:kido/Widgets/otp_field.dart';
import 'package:kido/bloc/verify_email/verify_email_cubit.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  String getOtp() => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyEmailCubit(),
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

                  /// OTP Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: OtpField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          enabled: !isLoading,
                          isError: errorMessage != null,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_focusNodes[index - 1]);
                            }

                            if (getOtp().length == 4) {
                              cubit.updateOtpCode(getOtp());
                              cubit.verifyOtp(widget.email, getOtp());
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Error from cubit (زي ما هو)
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
                                final otp = getOtp();
                                cubit.updateOtpCode(otp);
                                cubit.verifyOtp(widget.email, otp);
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
