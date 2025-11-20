import 'package:flutter/material.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'package:kido/Widgets/text_field_item.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/utils/validators.dart';
import 'package:kido/Pages/home_page.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String? validateConfirmPassword(String? value) {
    final passwordValidation = Validators.validatePassword(value);
    if (passwordValidation != null) {
      return passwordValidation;
    }

    // Then check if passwords match
    if (value != newPasswordController.text) {
      return "Passwords do not match!";
    }
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Password changed successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                CustomGradientButton(
                  title: "OK",
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.popUntil(context, (route) => route.isFirst);
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

  void handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Add API call to reset password
      // final newPassword = newPasswordController.text.trim();
      // final response = await ApiService.resetPassword(newPassword);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        // Show success dialog instead of SnackBar
        _showSuccessDialog();
      });
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Image.asset(
              'assets/images/log.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 6),
            Image.asset(
              'assets/images/Kido.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Change Password",
                style: TextStyle(
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isNewPasswordVisible = !isNewPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xff837F7F),
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      fieldController: confirmPasswordController,
                      fieldIcon: const Icon(Icons.lock_outline),
                      fieldLabel: "Confirm Password",
                      fieldObscure: !isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
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
                    CustomGradientButton(
                      title: _isLoading ? "" : "Change Password",
                      onPressed: _isLoading ? () {} : handleResetPassword,
                      colors: const [
                        Color(0xff3DF0C4),
                        Color(0xff3BDBE7),
                        Color(0xff2C8FF9),
                      ],
                      width: double.infinity,
                      borderRadius: 30,
                      fontSize: 22,
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(
                          color: Color(0xff2C8FF9),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff837F7F),
                          fontWeight: FontWeight.w600,
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
  }
}
