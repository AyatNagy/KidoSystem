import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/forgot_by_email_pagel.dart';
import '../Widgets/appBar.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import 'parent_signup_screen.dart';
import '../api_service/api_services.dart';
import 'student_data_screen.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../api_service/auth_services.dart';

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
  final GoogleAuthServices googleSignIn = GoogleAuthServices();
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
              backgroundColor: Colors.green
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StudentData())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Login failed. Check your credentials."),
              backgroundColor: Colors.red
          ),
        );
      }
    }
  }

  Future<void> handleGoogle() async {
    final result = await googleSignIn.signinWithGoogle();
    if (!mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Google Login Successful"),
            backgroundColor: Colors.green
        ),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentData())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Google Login Failed"),
            backgroundColor: Colors.red
        ),
      );
    }
  }

  void handleFacebook() => print("Facebook Login");

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KidoAppBar(),
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            children: [
              Text(
                "Hi, Parent!",
                style: TextStyle(
                    fontSize: config.headline,
                    fontWeight: FontWeight.bold
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    'assets/images/parent_sign in.png',
                    height: config.localHeight * 0.25,
                    width: config.localWidth * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        fieldController: emailController,
                        fieldIcon: const Icon(Icons.email),
                        fieldLabel: "Email",
                        fieldObscure: false,
                        validator: Validators.validateEmail,
                      ),
                      SizedBox(height: config.localHeight*0.001,),
                      CustomTextField(
                        fieldController: passwordController,
                        fieldIcon: const Icon(Icons.lock),
                        fieldLabel: "Password",
                        fieldObscure: !isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ?
                            Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xff837F7F),
                          ),
                          onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                        ),
                        validator: Validators.validatePassword,
                      ),
                      SizedBox(height: config.localHeight*0.01,),
                      Container(
                        width: config.localWidth * 0.55,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff3DF0C4),
                              Color(0xff3BDBE7),
                              Color(0xff2C8FF9)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: config.localHeight * 0.012),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: _isLoading
                              ? SizedBox(
                            height: config.localHeight * 0.03,
                            width: config.localHeight * 0.03,
                            child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3
                            ),
                          )
                              : Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: config.title,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForgotByEmail())
                        ),
                        child: Text(
                            "Forget Password?",
                            style: TextStyle(
                                color: const Color(0xff837F7F),
                                fontSize: config.body
                            )
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("or sign in with")
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: handleGoogle,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(config.localHeight * 0.015),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                            child: Image.asset(
                                'assets/images/google.png',
                                height: config.localHeight * 0.05
                            ),
                          ),
                          SizedBox(width: config.localWidth * 0.05),
                          OutlinedButton(
                            onPressed: handleFacebook,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(config.localHeight * 0.015),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                            child: Image.asset(
                                'assets/images/facebook.png',
                                height: config.localHeight * 0.05
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: const Color(0xff837F7F),
                                  fontSize: config.body
                              )
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ParentSignup())
                            ),
                            child: Text(
                                "Create one",
                                style: TextStyle(
                                    color: const Color(0xff2C8FF9),
                                    fontSize: config.body,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
