import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/Auth/forgot_by_email_pagel.dart';
import 'package:kido/Pages/parent_content/parent_home_page.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../Models/dailog_model.dart';
import '../../Widgets/Layout/app_bar.dart';
import '../../Widgets/Dialogs/dialog_widget.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? passwordError;
  String? emailError;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin(LoginCubit loginCubit) async {
    setState(() {
      emailError = Validators.validateEmail(emailController.text.trim());
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

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

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
                title: "Success",
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
                title: "Error",
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
                  title: "Success",
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
                  title: "Error",
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
              final isLoading =
                  loginState is LoginLoading ||
                  context.watch<GoogleAuthCubit>().state is GoogleAuthLoading;

              return Scaffold(
                backgroundColor: Colors.white,
                appBar: const KidoAppBar(),
                body: SafeArea(
                  child: Padding(
                    padding: config.pagePadding,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Hi, Parent!",
                            style: TextStyle(
                              fontFamily: 'tinyKids',
                              fontSize: config.headline,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3BDBE7),
                            ),
                          ),
                          SizedBox(
                            height: config.localHeight * 0.25,
                            width: config.localWidth * 0.8,
                            child: Center(
                              child: Image.asset(
                                'assets/images/parent_sign in.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
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
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        emailError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 15),
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
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        passwordError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: config.localHeight * 0.03),
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
                                        isLoading
                                            ? null
                                            : () => handleLogin(loginCubit),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: config.localHeight * 0.012,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child:
                                        isLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
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
                                                    emailController.text.trim(),
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
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                  (_) => const ParentSignup(),
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
