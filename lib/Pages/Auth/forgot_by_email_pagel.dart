import 'package:flutter/material.dart';

import 'package:kido/Pages/Auth/verify_code_page.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/Widgets/text_field_item.dart';
import 'package:kido/utils/validators.dart';

class ForgotByEmail extends StatefulWidget {
  const ForgotByEmail({super.key});

  @override
  State<ForgotByEmail> createState() => _ForgotByEmailState();
}

class _ForgotByEmailState extends State<ForgotByEmail> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/forgotpass.png',
                height: 250,
                width: 339,
              ),
              const SizedBox(height: 10),
              Text(
                "Forgot password ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
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
              Text(
                "Donot worry! Enter your email below to receive a code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),
              CustomTextField(
                fieldController: emailController,
                fieldIcon: Icon(Icons.email),
                fieldLabel: "Email",
                fieldObscure: false,
                validator: Validators.validateEmail,
              ),

              const SizedBox(height: 15),

              CustomGradientButton(
                title: "Send verification code",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerifyCode()),
                    );
                  }
                },
                colors: const [
                  Color(0xff3DF0C4),
                  Color(0xff3BDBE7),
                  Color(0xff2C8FF9),
                ],
                width: double.infinity,
                borderRadius: 30,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParentLogin()),
                  );
                },
                child: Text(
                  "cancel",
                  style: TextStyle(color: Color(0xff837F7F)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
