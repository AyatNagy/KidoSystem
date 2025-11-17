import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/forgot_by_email_page.dart';
import 'package:kido/Pages/Auth/forgot_by_phone_page.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'package:kido/Widgets/GradientButton.dart';
import 'package:kido/Widgets/custom_app_button.dart';

class ChooseRecoveryMethod extends StatelessWidget {
  const ChooseRecoveryMethod({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              "Forgot Password?",
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
            Text(
              "Select how you want to reset your password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 40),

            //Email option
            CustomGradientButton(
              title: "Email me the code",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotByEmail()),
                );
              },
              colors: const [
                Color(0xFFB388EB),
                Color(0xFFE493D0),
                Color(0xFFF6B1C3),
              ],
              width: double.infinity,
              borderRadius: 30,
            ),
            const SizedBox(height: 40),

            // phone option
            CustomGradientButton(
              title: "Text me the code",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotByPhone()),
                );
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
                  MaterialPageRoute(builder: (context) => ParentLogin()),
                );
              },
              child: Text("cancel", style: TextStyle(color: Color(0xff837F7F))),
            ),
          ],
        ),
      ),
    );
  }
}
