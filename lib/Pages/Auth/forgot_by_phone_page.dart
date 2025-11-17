import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/choose_recovery_method_page.dart';
import 'package:kido/Pages/Auth/verify_code_page.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/Widgets/text_field_item.dart';

class ForgotByPhone extends StatefulWidget {
  const ForgotByPhone({super.key});

  @override
  State<ForgotByPhone> createState() => _ForgotByPhoneState();
}

class _ForgotByPhoneState extends State<ForgotByPhone> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final phoneRegex = RegExp(
    r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              const SizedBox(height: 10),
              Text(
                "Enter your registered phone to receive a verification code.",
                textAlign: TextAlign.center,
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

              const SizedBox(height: 40),
              CustomTextField(
                fieldController: phoneController,
                fieldIcon: Icon(Icons.phone),
                fieldLabel: "Phone Number",
                fieldObscure: false,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone!";
                  }

                  if (!phoneRegex.hasMatch(value)) {
                    return "Please enter a valid phone number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 40),

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
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseRecoveryMethod(),
                    ),
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
    ;
  }
}
