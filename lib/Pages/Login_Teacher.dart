import 'package:flutter/material.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../config/ResponsiveConfig.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void handle() {
    if (_formKey.currentState!.validate()) {
      print("success");
    }
  }

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
                "Hi, Teacher!",
                style: TextStyle(
                  fontSize: config.headline,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      offset: const Offset(0.5, 0.5),
                      color: Colors.black26,
                    )
                  ],
                ),
              ),

              SizedBox(height: config.localHeight * 0.02),

              // IMAGE
              Image.asset(
                'assets/images/te.png',
                height: config.imageHeight(0.32),
                width: config.imageWidth(0.8),
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
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
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

                    // SIGN IN BUTTON
                    Container(
                      width: config.localWidth * 0.45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff3DF0C4),
                            Color(0xff3BDBE7),
                            Color(0xff2C8FF9)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: handle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              vertical: config.localHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
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
                      onPressed: () {},
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: const Color(0xff837F7F),
                          fontSize: config.body,
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
