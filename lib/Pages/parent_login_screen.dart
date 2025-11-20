import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/forgot_by_email_pagel.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import 'parent_signup_screen.dart';
import '../api_service/api_services.dart';
import 'student_data_screen.dart';
import '../Widgets/ResponsiveProvider.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final response = await ApiService.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentData()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Check your credentials."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void handleGoogle() => print("Google Login");
  void handleFacebook() => print("Facebook Login");

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: config.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: config.localHeight * 0.02),

              // LOGO
              Row(
                children: [
                  Image.asset(
                    'assets/images/log.png',
                    height: config.imageHeight(0.07),
                  ),
                  SizedBox(width: config.localWidth * 0.02),
                  Image.asset(
                    'assets/images/kido.png',
                    height: config.imageHeight(0.07),
                  ),
                ],
              ),

              SizedBox(height: config.localHeight * 0.03),

              // TITLE
              Text(
                "Hi, Parent!",
                style: TextStyle(
                  fontSize: config.headline,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      blurRadius: 2,
                      offset: Offset(0.5, 0.5),
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),

              SizedBox(height: config.localHeight * 0.02),

              // IMAGE
              Image.asset(
                'assets/images/parent_sign in.png',
                height: config.imageHeight(0.33),
                width: config.imageWidth(0.80),
                fit: BoxFit.contain,
              ),

              SizedBox(height: config.localHeight * 0.03),

              // FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // EMAIL
                    CustomTextField(
                      fieldController: emailController,
                      fieldIcon: const Icon(Icons.email),
                      fieldLabel: "Email",
                      fieldObscure: false,
                      validator: Validators.validateEmail,
                    ),

                    SizedBox(height: config.localHeight * 0.02),

                    // PASSWORD
                    CustomTextField(
                      fieldController: passwordController,
                      fieldIcon: const Icon(Icons.lock),
                      fieldLabel: "Password",
                      fieldObscure: !isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                            () => isPasswordVisible = !isPasswordVisible,
                          );
                        },
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xff837F7F),
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),

                    SizedBox(height: config.localHeight * 0.04),

                    // SIGN-IN BUTTON
                    Container(
                      width: config.localWidth * 0.50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff3DF0C4),
                            Color(0xff3BDBE7),
                            Color(0xff2C8FF9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            vertical: config.localHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  height: config.localHeight * 0.03,
                                  width: config.localHeight * 0.03,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: config.title,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),

                    SizedBox(height: config.localHeight * 0.02),

                    // FORGET PASSWORD
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotByEmail(),
                          ),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: const Color(0xff837F7F),
                          fontSize: config.body,
                        ),
                      ),
                    ),

                    SizedBox(height: config.localHeight * 0.02),

                    // DIVIDER
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or sign in with",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: config.body,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),

                    SizedBox(height: config.localHeight * 0.03),

                    // GOOGLE BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: handleGoogle,
                        icon: Image.asset(
                          'assets/images/google.png',
                          height: config.localHeight * 0.05,
                        ),
                        label: Text(
                          "Sign in with Google",
                          style: TextStyle(
                            fontSize: config.body,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: config.localHeight * 0.02,
                          ),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: config.localHeight * 0.02),

                    // FACEBOOK BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: handleFacebook,
                        icon: Image.asset(
                          'assets/images/facebook.png',
                          height: config.localHeight * 0.05,
                        ),
                        label: Text(
                          "Sign in with Facebook",
                          style: TextStyle(
                            fontSize: config.body,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: config.localHeight * 0.02,
                          ),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: config.localHeight * 0.03),

                    // CREATE ACCOUNT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: const Color(0xff837F7F),
                            fontSize: config.body,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ParentSignup(),
                              ),
                            );
                          },
                          child: Text(
                            "Create one",
                            style: TextStyle(
                              color: const Color(0xff2C8FF9),
                              fontSize: config.body,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: config.localHeight * 0.03),
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
