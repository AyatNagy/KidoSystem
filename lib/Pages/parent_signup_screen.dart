import 'package:flutter/material.dart';
import 'package:kido/Models/user.dart';
import 'package:kido/Pages/VerifyEmailScreen.dart';
import 'package:kido/Pages/student_data_screen.dart';
import 'package:kido/Widgets/PasswordStrengthTurtle%20.dart';
import 'package:kido/api_service/api_services.dart';
import '../Models/dailogModel.dart';
import '../Widgets/appBar.dart';
import '../Widgets/dialog_widget.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import '../Widgets/ResponsiveProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kido/Widgets/password_errors_view.dart';


class ParentSignup extends StatefulWidget {
  const ParentSignup({super.key});

  @override
  State<ParentSignup> createState() => _ParentSignupState();
}

class _ParentSignupState extends State<ParentSignup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? usernameError;
  String? nameError;
  String? phoneError;
  String? emailError;
  //String? passwordError;
  final phoneRegex = RegExp(
    r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
  );

  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String currentPassword = "";
  Future<void> handleSignup() async {
    final username = usernameController.text.trim();
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    setState(() {
      usernameError = Validators.validateUsername(username);
      nameError = Validators.validateName(name);
      phoneError = Validators.validatePhone(phone);
      emailError = Validators.validateEmail(email);
      //passwordError = Validators.validatePassword(password);
    });

    if (usernameError != null 
        ||nameError != null 
        ||phoneError != null 
        ||emailError != null 
        //||passwordError != null
        ) {
      return;
    }

    setState(() => _isLoading = true);

    final user = User(
      username: username,
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    final success = await ApiService.registerUser(user);

    setState(() => _isLoading = false);

    if (success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);

      CustomDialog(
        context,
        dialogModel(
          title: "Success 🎉",
          message: "Registration success!",
          image: "assets/images/signup-success.png",
        ),
        titleColor: Colors.green,
      );

      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(email: user.email),
          ),
        );
      });
    } else {
      CustomDialog(
        context,
        dialogModel(
          title: "Error ❌",
          message: "Registration Failed.",
          image: "assets/images/signup-faied.png",
        ),
        titleColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KidoAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: config.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hi, Parent!",
                style: TextStyle(
                  fontFamily: 'tinyKids',
                  fontSize: config.headline,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffEE3187),
                  shadows: const [
                    Shadow(
                      blurRadius: 2,
                      offset: Offset(0.5, 0.5),
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              SizedBox(height: config.localHeight * 0.02),
              Image.asset(
                'assets/images/parent_sign up.png',
                height: config.imageHeight(0.10),
                width: config.imageWidth(0.4),
                fit: BoxFit.contain,
              ),
              SizedBox(height: config.localHeight * 0.03),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      fieldController: usernameController,
                      fieldIcon: const Icon(Icons.account_circle),
                      fieldLabel: "Username",
                      fieldObscure: false,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Please enter your username!";
                        if (value.length < 3)
                          return "Username must be at least 3 characters long";
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          usernameError = Validators.validateUsername(value);
                        });
                      },
                    ),
                    if (usernameError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          usernameError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: nameController,
                      fieldIcon: const Icon(Icons.person),
                      fieldLabel: "Full Name",
                      fieldObscure: false,
                      validator: Validators.validateName,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          nameError = Validators.validateName(value);
                        });
                      },
                    ),
                    if (nameError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          nameError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: phoneController,
                      fieldIcon: const Icon(Icons.phone),
                      fieldLabel: "Phone Number",
                      fieldObscure: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Please enter your phone!";
                        if (!phoneRegex.hasMatch(value))
                          return "Please enter a valid phone number";
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          phoneError = Validators.validatePhone(value);
                        });
                      },
                    ),
                    if (phoneError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          phoneError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: emailController,
                      fieldIcon: const Icon(Icons.email),
                      fieldLabel: "Email",
                      fieldObscure: false,
                      validator: Validators.validateEmail,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          emailError = Validators.validateEmail(value);
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
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: passwordController,
                      fieldIcon: const Icon(Icons.lock),
                      fieldLabel: "Password",
                      fieldObscure: !isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      validator: Validators.validatePassword,
                      onChanged: (value) {
                        setState(() {
                          currentPassword = value;
                          
                        });
                      },
                      suffixIcon: IconButton(
                        onPressed:
                            () => setState(
                              () => isPasswordVisible = !isPasswordVisible,
                            ),
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xff837F7F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3,),
                    
                      Container(
                        width: double.infinity,
                        child: PasswordErrorsView(password: currentPassword)
                      ),
                       
                      
                    SizedBox(height: config.localHeight * 0.01),
                    PasswordStrengthTurtle(password: currentPassword),
                    SizedBox(height: config.localHeight * 0.04),
                    Container(
                      width: config.localWidth * 0.5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffF8AA3B),
                            Color(0xffFF7A78),
                            Color(0xffEE3187),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            vertical: config.localHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  height: config.localHeight * 0.03,
                                  width: config.localHeight * 0.03,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: config.title,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: config.localHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account?",
                          style: TextStyle(
                            color: const Color(0xff837F7F),
                            fontSize: config.body,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: const Color(0xffEE3187),
                              fontWeight: FontWeight.bold,
                              fontSize: config.body,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: config.localHeight * 0.03),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
