import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/reset_password_page.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/Widgets/otp_field.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

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
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String GetOtp() {
    return _controllers.map((c) => c.text).join();
  }

  void handleVerify() {
    final otp = GetOtp();
    if (otp.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPassword()),
      );
    } else {
      for (var c in _controllers) {
        c.clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 4 digits!')),
      );
    }
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/Kido.png'),
            const SizedBox(height: 10),
            Text(
              "Enter code",
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
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: OtpField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
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
              "We have sent the verification code to you",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                print("resend done");
              },
              child: Text("Resend", style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 40),

            CustomGradientButton(
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
  }
}
