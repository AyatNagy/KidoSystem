import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/Auth/forgot_by_email_pagel.dart';
import 'package:kido/Pages/parent_content/parent_home_page.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../Models/dailog_model.dart';
import '../../Widgets/app_bar.dart';
import '../../Widgets/dialog_widget.dart';
import '../../Widgets/text_field_item.dart';
import '../../utils/validators.dart';
import 'parent_signup_screen.dart';
import '../parent_content/student_data_screen.dart';
import '../../bloc/login/login_cubit.dart';
import '../../bloc/google_auth/google_auth_cubit.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});
  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String? passwordError;
    String? emailError;
    final formKey = GlobalKey<FormState>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => GoogleAuthCubit()),
      ],
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            customDialog(
              context,
              DailogModel(
                title: "Success 🎉",
                message: "Login successful!",
                image: "assets/images/signin-success.png",
              ),
              titleColor: Colors.green,
            );
            Future.delayed(const Duration(seconds: 4), () {
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ParentHomePage()),
              );
            });
          } else if (state is LoginFailure) {
            customDialog(
              context,
              DailogModel(
                title: "Error ❌",
                message: state.errorMessage,
                image: "assets/images/signin-failed.png",
              ),
              titleColor: Colors.red,
            );
          }
        },
        child: BlocListener<GoogleAuthCubit, GoogleAuthState>(
          listener: (context, state) {
            if (state is GoogleAuthSuccess) {
              customDialog(
                context,
                DailogModel(
                  title: "Success 🎉",
                  message: "Google Login successful!",
                  image: "assets/images/google-success.png",
                ),
                titleColor: Colors.green,
              );
              Future.delayed(const Duration(seconds: 4), () {
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentData()),
                );
              });
            } else if (state is GoogleAuthFailure) {
              customDialog(
                context,
                DailogModel(
                  title: "Error ❌",
                  message: state.errorMessage,
                  image: "assets/images/google-failed.png",
                ),
                titleColor: Colors.red,
              );
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, loginState) {
              final loginCubit = context.read<LoginCubit>();
              final googleCubit = context.read<GoogleAuthCubit>();
              final isLoading =
                  loginState is LoginLoading ||
                  context.watch<GoogleAuthCubit>().state is GoogleAuthLoading;
              bool isPasswordVisible = false;

              Future<void> handleLogin() async {
                setState(() {
                  emailError = Validators.validateEmail(
                    emailController.text.trim(),
                  );
                  passwordError = Validators.validateLoginPassword(
                    passwordController.text.trim(),
                  );
                });

                if (emailError != null || passwordError != null) return;

                loginCubit.loginUser(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              }

              Future<void> handleGoogle() async {
                googleCubit.signInWithGoogle();
              }

              // ignore: avoid_print
              void handleFacebook() => print("Facebook Login");

              return StatefulBuilder(
                builder: (context, setState) {
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
                                fontFamily: 'tinyKids',
                                fontSize: config.headline,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3BDBE7),
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
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextField(
                                      fieldController: emailController,
                                      fieldIcon: const Icon(Icons.email),
                                      fieldLabel: "Email",
                                      fieldObscure: false,
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) {
                                        setState(() {
                                          emailError = Validators.validateEmail(
                                            value,
                                          );
                                        });
                                      },
                                    ),
                                    if (emailError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          emailError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: config.localHeight * 0.001,
                                    ),
                                    CustomTextField(
                                      fieldController: passwordController,
                                      fieldIcon: const Icon(Icons.lock),
                                      fieldLabel: "Password",
                                      fieldObscure: !isPasswordVisible,
                                      textInputAction: TextInputAction.done,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xff837F7F),
                                        ),
                                        onPressed:
                                            () => setState(
                                              () =>
                                                  isPasswordVisible =
                                                      !isPasswordVisible,
                                            ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          passwordError =
                                              Validators.validateLoginPassword(
                                                value,
                                              );
                                        });
                                      },
                                    ),
                                    if (passwordError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          passwordError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: config.localHeight * 0.01),
                                    Container(
                                      width: config.localWidth * 0.55,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff3DF0C4),
                                            Color(0xff3BDBE7),
                                            Color(0xff2C8FF9),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                            isLoading ? null : handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                config.localHeight * 0.012,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                        ),
                                        child:
                                            isLoading
                                                ? SizedBox(
                                                  height:
                                                      config.localHeight * 0.03,
                                                  width:
                                                      config.localHeight * 0.03,
                                                  child:
                                                      const CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                      ),
                                                )
                                                : Text(
                                                  "Sign In",
                                                  style: TextStyle(
                                                    fontSize: config.title,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => ForgotByEmail(
                                                    email:
                                                        emailController.text
                                                            .trim(),
                                                  ),
                                            ),
                                          ),
                                      child: Text(
                                        "Forget Password?",
                                        style: TextStyle(
                                          fontFamily: 'nunito',
                                          color: const Color(0xff837F7F),
                                          fontSize: config.body,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Expanded(child: Divider()),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            "or sign in with",
                                            style: TextStyle(
                                              fontFamily: 'nunito',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Divider()),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed:
                                              isLoading ? null : handleGoogle,
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(
                                              config.localHeight * 0.015,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/google.png',
                                            height: config.localHeight * 0.05,
                                          ),
                                        ),
                                        SizedBox(
                                          width: config.localWidth * 0.05,
                                        ),
                                        OutlinedButton(
                                          onPressed: handleFacebook,
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(
                                              config.localHeight * 0.015,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/facebook.png',
                                            height: config.localHeight * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: TextStyle(
                                            fontFamily: 'nunito',
                                            color: const Color(0xff837F7F),
                                            fontSize: config.body,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          const ParentSignup(),
                                                ),
                                              ),
                                          child: Text(
                                            "Create one",
                                            style: TextStyle(
                                              color: const Color(0xff2C8FF9),
                                              fontFamily: 'nunito',
                                              fontSize: config.body,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
