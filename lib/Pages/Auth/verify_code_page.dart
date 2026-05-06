import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Models/dailog_model.dart';
import 'package:kido/Pages/Auth/reset_password_page.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/Widgets/Dialogs/dialog_widget.dart';
import 'package:kido/Widgets/Auth/otp_field.dart';
import '../../bloc/verify_code/verify_code_cubit.dart';

class VerifyCode extends StatefulWidget {
  final String email;
  const VerifyCode({super.key, required this.email});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isSubmitting = false;
  bool _hasError = false;

  Timer? _timer;
  int _secondsLeft = 45;
  bool _canResend = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });

    _startCountdown();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  String getOtp() => _controllers.map((c) => c.text).join();

  void submitOtp(VerifyCodeCubit cubit) {
    if (_isSubmitting) return;

    final otp = getOtp();

    if (otp.length < 4) {
      return;
    }

    _isSubmitting = true;
    cubit.verifyOtp(widget.email, otp);
  }

  void _startCountdown() {
    _secondsLeft = 45;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void pasteOtp(String value, VerifyCodeCubit cubit) {
    if (value.length != 4) return;
    for (int i = 0; i < 4; i++) {
      _controllers[i].text = value[i];
    }
    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    Future.delayed(const Duration(milliseconds: 150), () {
      submitOtp(cubit);
    });
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => VerifyCodeCubit(),
      child: BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          if (state is VerifyCodeSuccess) {
            _isSubmitting = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ResetPassword(
                      email: widget.email,
                      otpCode: state.otpCode,
                    ),
              ),
            );
          } else if (state is VerifyCodeFailure) {
            _isSubmitting = false;
            HapticFeedback.vibrate();
            _triggerShake();
            setState(() {
              _hasError = true;
            });
          } else if (state is VerifyCodeResendSuccess) {
            _startCountdown();
            customDialog(
              context,
              DailogModel(
                title: "Success 🎉",
                message: "Verification code sent successfully",
                image: "assets/images/signin-success.png",
              ),
              titleColor: Colors.green,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<VerifyCodeCubit>();
          final isLoading = state is VerifyCodeLoading;

          final otpFilled = getOtp().length == 4;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 120,
              leading: Row(
                children: [
                  const SizedBox(width: 8),
                  Image.asset('assets/images/log.png', height: 40, width: 40),
                  const SizedBox(width: 6),
                  Image.asset('assets/images/Kido.png', height: 40, width: 40),
                ],
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      Image.asset(
                        'assets/images/verifycode.png',
                        height: screenHeight * 0.25,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      const Text(
                        "Enter code",
                        style: TextStyle(
                          fontFamily: 'nunito',
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              _shakeAnimation.value *
                                  (_shakeController.status ==
                                          AnimationStatus.forward
                                      ? 1
                                      : 0),
                              0,
                            ),
                            child: child,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: OtpField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                isError: _hasError,
                                enabled: !isLoading,
                                onChanged: (value) async {
                                  if (_hasError) {
                                    setState(() {
                                      _hasError = false;
                                    });
                                  }

                                  if (value.length > 1) {
                                    pasteOtp(value, cubit);
                                    return;
                                  }

                                  HapticFeedback.selectionClick();

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
                                    Future.delayed(
                                      const Duration(milliseconds: 150),
                                      () => submitOtp(cubit),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        "We have sent the verification code to you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      TextButton(
                        onPressed:
                            (_secondsLeft == 0 && !isLoading)
                                ? () => cubit.resendOtp(widget.email)
                                : null,
                        child: Text(
                          _secondsLeft == 0
                              ? "Resend code"
                              : "Resend in 00:${_secondsLeft.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _secondsLeft == 0 ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomGradientButton(
                        title: isLoading ? "Verifying..." : "Verify",
                        onPressed: () {
                          setState(() {
                            _hasError = getOtp().length < 4;
                          });

                          if (_hasError) {
                            _triggerShake();
                            HapticFeedback.vibrate();
                            return;
                          }

                          submitOtp(cubit);
                        },
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
              ),
            ),
          );
        },
      ),
    );
  }
}
