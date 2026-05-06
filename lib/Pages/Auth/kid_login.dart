import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../Widgets/Layout/app_bar.dart';
import '../../Widgets/text_field_item.dart';
import '../../utils/validators.dart';

class KidoLogin extends StatefulWidget {
  const KidoLogin({super.key});

  @override
  State<KidoLogin> createState() => _KidoLoginState();
}

class _KidoLoginState extends State<KidoLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void handle() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KidoAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics:
                  constraints.maxHeight < 700
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              padding: config.pagePadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hi, Kido!",
                      style: TextStyle(
                        fontSize: config.headline,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            offset: const Offset(0.5, 0.5),
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: config.localHeight * 0.02),

                    Image.asset(
                      'assets/images/learn.jpeg',
                      height: config.imageHeight(0.35),
                      width: config.imageWidth(0.8),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: config.localHeight * 0.03),

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

                          SizedBox(height: config.localHeight * 0.02),

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

                          Container(
                            width: config.localWidth * 0.45,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff3DF0C4),
                                  Color(0xff3BDBE7),
                                  Color(0xff2C8FF9),
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
                                  vertical: config.localHeight * 0.025,
                                ),
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

                    SizedBox(height: config.localHeight * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
