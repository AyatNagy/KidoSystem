import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/kid/child_level_welcome_page.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/bloc/child_login/child_login_cubit.dart';
import '../../Widgets/Layout/app_bar.dart';
import '../../Widgets/text_field_item.dart';
import '../../utils/validators.dart';

class KidoLogin extends StatelessWidget {
  const KidoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChildLoginCubit(),
      child: const _KidoLoginView(),
    );
  }
}

class _KidoLoginView extends StatefulWidget {
  const _KidoLoginView();

  @override
  State<_KidoLoginView> createState() => _KidoLoginViewState();
}

class _KidoLoginViewState extends State<_KidoLoginView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ChildLoginCubit>().login(
          usernameController.text.trim(),
          passwordController.text,
        );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
            return BlocConsumer<ChildLoginCubit, ChildLoginState>(
              listener: (context, state) {
                if (state is ChildLoginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChildLevelWelcomePage(
                            childName: state.childName,
                            allowedLevel: state.allowedLevel ?? 1,
                          ),
                    ),
                  );
                }
                if (state is ChildLoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is ChildLoginLoading;

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
                                fieldController: usernameController,
                                fieldIcon: const Icon(Icons.person),
                                fieldLabel: "Username",
                                fieldObscure: false,
                                validator: Validators.validateUsername,
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
                                validator: Validators.validateLoginPassword,
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
                                  onPressed: isLoading ? null : _submit,
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
                                  child:
                                      isLoading
                                          ? SizedBox(
                                            height: config.title + 4,
                                            width: config.title + 4,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
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
            );
          },
        ),
      ),
    );
  }
}
