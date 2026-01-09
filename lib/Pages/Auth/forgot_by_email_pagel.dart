import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/Auth/verify_code_page.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'package:kido/Widgets/custom_app_button.dart';
import 'package:kido/Widgets/text_field_item.dart';
import 'package:kido/utils/validators.dart';
import '../../bloc/forget_password/forget_password_cubit.dart';

class ForgotByEmail extends StatelessWidget {
  final String? email;

  const ForgotByEmail({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(
      text: email ?? '',
    );
    final _formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyCode(email: state.email),
              ),
            );
          } else if (state is ForgetPasswordFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgetPasswordCubit>();
          final isLoading = state is ForgetPasswordLoading;
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
                        fontFamily: 'nunito',
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
                      "Don't worry! Enter your email below to receive a code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'nunito',
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
                        if (!isLoading && _formKey.currentState!.validate()) {
                          final email = emailController.text;
                          cubit.forgetPassword(email);
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
                          MaterialPageRoute(
                            builder: (context) => ParentLogin(),
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
        },
      ),
    );
  }
}
