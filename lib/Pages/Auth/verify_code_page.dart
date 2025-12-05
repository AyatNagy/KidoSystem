import 'package:flutter/material.dart';
import 'package:kido/Pages/Auth/reset_password_page.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/Widgets/otp_field.dart';
import 'package:kido/api_service/api_services.dart';

class VerifyCode extends StatefulWidget {
  final String email;
  const VerifyCode({super.key, required this.email});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _hasError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> handleVerify() async {
    final otp = getOtp();
    if (otp.length == 4) {
      setState(() {
        _hasError = false;
        _isLoading = true;
      });

      final response = await ApiService.verifyOtp(widget.email, otp);
      setState(() => _isLoading = false);

      if (response != null && response['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResetPassword(email: widget.email, otpCode: otp),
          ),
        );
      } else {
        setState(() => _hasError = true);
        for (var c in _controllers) c.clear();
        FocusScope.of(context).requestFocus(_focusNodes[0]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?['message'] ?? 'Invalid OTP')),
        );
      }
    } else {
      setState(() => _hasError = true);
      for (var c in _controllers) c.clear();
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  Future<void> handleResend() async {
    setState(() => _isLoading = true);
    final response = await ApiService.forgetPassword(widget.email);
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response != null && response['success'] == true
              ? 'OTP resent successfully'
              : 'Failed to resend OTP',
        ),
      ),
    );
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
            Image.asset('assets/images/log.png', height: 40, width: 40),
            SizedBox(width: 6),
            Image.asset('assets/images/Kido.png', height: 40, width: 40),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/verifycode.png',
              height: 200,
              width: 339,
            ),
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

            // OTP Fields Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: OtpField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    isError: _hasError,
                    onChanged: (value) {
                      if (_hasError) setState(() => _hasError = false);
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
              "We have sent the verification code to you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _isLoading ? null : handleResend,
              child: Text("Resend", style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : CustomGradientButton(
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
