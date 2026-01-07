import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/Auth/reset_password_page.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/Widgets/otp_field.dart';
import '../../bloc/verify_code/verify_code_cubit.dart';

class VerifyCode extends StatefulWidget {
  final String email;
  const VerifyCode({super.key, required this.email});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyCodeCubit(),
      child: BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          if (state is VerifyCodeSuccess) {
            // Skip verify-otp and go directly to reset password
            // The OTP will be verified during reset-password
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ResetPassword(
                      email: widget.email,
                      otpCode: state.otpCode,
                    ),
              ),
            );
          } else if (state is VerifyCodeFailure) {
            setState(() {
              for (var c in _controllers) c.clear();
              FocusScope.of(context).requestFocus(_focusNodes[0]);
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is VerifyCodeResendSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP resent successfully')),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<VerifyCodeCubit>();
          final isLoading = state is VerifyCodeLoading;
          final hasError = state is VerifyCodeFailure;

          Future<void> handleVerify() async {
            final otp = getOtp();
            if (otp.length == 4) {
              cubit.verifyOtp(widget.email, otp);
            } else {
              setState(() {
                for (var c in _controllers) c.clear();
                FocusScope.of(context).requestFocus(_focusNodes[0]);
              });
              cubit.verifyOtp(widget.email, otp);
            }
          }

          Future<void> handleResend() async {
            cubit.resendOtp(widget.email);
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 120,
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Image.asset('assets/images/log.png', height: 40, width: 40),
                  SizedBox(width: 6),
                  Image.asset('assets/images/Kido.png', height: 40, width: 40),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/verifycode.png',
                    height: 200,
                    width: 339,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter code",
                    style: TextStyle(
                      fontFamily:'nunito',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          offset: Offset(0.5, 0.5),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // OTP Fields Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: OtpField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          isError: hasError,
                          onChanged: (value) {
                            if (hasError) cubit.clearError();
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_focusNodes[index - 1]);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "We have sent the verification code to you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'nunito',
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: isLoading ? null : handleResend,
                    child: Text("Resend",
                     style: TextStyle(
                      fontFamily: 'nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                      )),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : CustomGradientButton(
                        title: "Verify",
                        onPressed: handleVerify,
                        colors: const [
                          Color(0xff3DF0C4),
                          Color(0xff3BDBE7),
                          Color(0xff2C8FF9),
                        ],
                        width: double.infinity,
                        borderRadius: 30,
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
