import 'package:flutter/material.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import 'student_data_screen.dart';
import '../Widgets/ResponsiveProvider.dart';

class ParentSignup extends StatefulWidget {
  const ParentSignup({super.key});

  @override
  State<ParentSignup> createState() => _ParentSignupState();
}

class _ParentSignupState extends State<ParentSignup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final phoneRegex = RegExp(
    r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
  );

  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void handleSignup() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentData()),
      );
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
              Row(
                children: [
                  Image.asset('assets/images/log.png', height: config.imageHeight(0.07)),
                  SizedBox(width: config.localWidth * 0.02),
                ],
              ),
              SizedBox(height: config.localHeight * 0.03),
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
                    )
                  ],
                ),
              ),
              SizedBox(height: config.localHeight * 0.02),
              Image.asset(
                'assets/images/parent_sign up.png',
                height: config.imageHeight(0.33),
                width: config.imageWidth(0.8),
                fit: BoxFit.contain,
              ),
              SizedBox(height: config.localHeight * 0.03),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      fieldController: usernameController,
                      fieldIcon: const Icon(Icons.account_circle),
                      fieldLabel: "Username",
                      fieldObscure: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter your username!";
                        if (value.length < 3) return "Username must be at least 3 characters long";
                        return null;
                      },
                    ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: nameController,
                      fieldIcon: const Icon(Icons.person),
                      fieldLabel: "Full Name",
                      fieldObscure: false,
                      validator: Validators.validateName,
                    ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: phoneController,
                      fieldIcon: const Icon(Icons.phone),
                      fieldLabel: "Phone Number",
                      fieldObscure: false,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter your phone!";
                        if (!phoneRegex.hasMatch(value)) return "Please enter a valid phone number";
                        return null;
                      },
                    ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: emailController,
                      fieldIcon: const Icon(Icons.email),
                      fieldLabel: "Email",
                      fieldObscure: false,
                      validator: Validators.validateEmail,
                    ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: passwordController,
                      fieldIcon: const Icon(Icons.lock),
                      fieldLabel: "Password",
                      fieldObscure: !isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => isPasswordVisible = !isPasswordVisible);
                        },
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xff837F7F),
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    SizedBox(height: config.localHeight * 0.04),
                    Container(
                      width: config.localWidth * 0.5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffF8AA3B), Color(0xffFF7A78), Color(0xffEE3187)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: config.localHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: config.title,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: config.localHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account?",
                          style: TextStyle(color: const Color(0xff837F7F), fontSize: config.body),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: const Color(0xffEE3187),
                              fontWeight: FontWeight.bold,
                              fontSize: config.body,
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
