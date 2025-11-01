import 'package:flutter/material.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import 'parent_signup_screen.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void handle() {
    if (_formKey.currentState!.validate()) {
      print("Login success");
    }
  }

  void handleGoogleLogin() {
    print("Google login pressed");
    // TODO: connect to your own server API
  }

  void handleFacebookLogin() {
    print("Facebook login pressed");
    // TODO: connect to your own server API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/log.png', height: 40),
                  const SizedBox(width: 6),
                  Image.asset('assets/images/kido.png', height: 40),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hi, Parent!",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      offset: Offset(0.5, 0.5),
                      color: Colors.black26,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/parent_sign in.png',
                height: 336,
                width: 339,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      fieldController: emailController,
                      fieldIcon: const Icon(Icons.email),
                      fieldLabel: "Email",
                      fieldObscure: false,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 30),
                    Container(
                      width: 200,
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        print("Forget pressed");
                      },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(color: Color(0xff837F7F)),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 0.8,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          "or sign in with",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 0.8,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: handleGoogleLogin,
                        icon: Image.asset(
                          'assets/images/google.png',
                          height: 50,
                        ),
                        label: const Text(
                          "Sign in with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: handleFacebookLogin,
                        icon: Image.asset(
                          'assets/images/facebook.png',
                          height: 50,
                        ),
                        label: const Text(
                          "Sign in with Facebook",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Color(0xff837F7F)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ParentSignup()),
                            );
                          },
                          child: const Text(
                            "Create one",
                            style: TextStyle(
                              color: Color(0xff2C8FF9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
