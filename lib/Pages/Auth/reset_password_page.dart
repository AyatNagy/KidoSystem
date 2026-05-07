// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/Auth/parent_login_screen.dart';
import 'package:kido/Widgets/Auth/password_strength_turtle%20.dart';
import 'package:kido/Widgets/text_field_item.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/utils/validators.dart';
import '../../bloc/reset_password/reset_password_cubit.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otpCode;
  const ResetPassword({super.key, required this.email, required this.otpCode});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String currentPassword = "";
  final _formKey = GlobalKey<FormState>();

  String? validateConfirmPassword(String? value) {
    final passwordValidation = Validators.validatePassword(value);
    if (passwordValidation != null) return passwordValidation;
    if (value != newPasswordController.text) return "Passwords do not match!";
    return null;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Password changed successfully!",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomGradientButton(
                  title: "OK",
                  onPressed: () {
                    // Close dialog
                    Navigator.of(context).pop();
                    // Navigate to login page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => ParentLogin()),
                      (route) => false,
                    );
                  },
                  colors: const [
                    Color(0xff3DF0C4),
                    Color(0xff3BDBE7),
                    Color(0xff2C8FF9),
                  ],
                  width: double.infinity,
                  borderRadius: 30,
                  fontSize: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            _showSuccessDialog();
          } else if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<ResetPasswordCubit>();
          final isLoading = state is ResetPasswordLoading;

          Future<void> handleResetPassword() async {
            if (_formKey.currentState!.validate()) {
              final newPassword = newPasswordController.text.trim();
              cubit.resetPassword(widget.email, widget.otpCode, newPassword);
            }
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
                  const SizedBox(width: 8),
                  Image.asset('assets/images/log.png', height: 40, width: 40),
                  const SizedBox(width: 6),
                  Image.asset('assets/images/Kido.png', height: 40, width: 40),
                ],
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            fieldController: newPasswordController,
                            fieldIcon: const Icon(Icons.lock),
                            fieldLabel: "New Password",
                            fieldObscure: !isNewPasswordVisible,
                            onChanged: (value) {
                              setState(() {
                                currentPassword = value;
                              });
                            },
                            suffixIcon: IconButton(
                              onPressed:
                                  () => setState(
                                    () =>
                                        isNewPasswordVisible =
                                            !isNewPasswordVisible,
                                  ),
                              icon: Icon(
                                isNewPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xff837F7F),
                              ),
                            ),
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 8),
                          PasswordStrengthTurtle(password: currentPassword),
                          const SizedBox(height: 16),
                          CustomTextField(
                            fieldController: confirmPasswordController,
                            fieldIcon: const Icon(Icons.lock_outline),
                            fieldLabel: "Confirm Password",
                            fieldObscure: !isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              onPressed:
                                  () => setState(
                                    () =>
                                        isConfirmPasswordVisible =
                                            !isConfirmPasswordVisible,
                                  ),
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xff837F7F),
                              ),
                            ),
                            validator: validateConfirmPassword,
                          ),
                          const SizedBox(height: 40),
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Color(0xff2C8FF9),
                              )
                              : CustomGradientButton(
                                title: "Change Password",
                                onPressed: handleResetPassword,
                                colors: const [
                                  Color(0xff3DF0C4),
                                  Color(0xff3BDBE7),
                                  Color(0xff2C8FF9),
                                ],
                                width: double.infinity,
                                borderRadius: 30,
                                fontSize: 22,
                              ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed:
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ParentLogin(),
                                  ),
                                ),
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff837F7F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
