import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Pages/exam_screen.dart';
import '../Widgets/appBar.dart';
import '../Widgets/text_field_item.dart';
import '../Widgets/ResponsiveProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/validators.dart';

class StudentData extends StatefulWidget {
  const StudentData({super.key});

  @override
  State<StudentData> createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? nameError;
  String? usernameError;
  String? ageError;
  String? passwordError;
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> handleAdd() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        nameError = Validators.validateName(nameController.text);
        usernameError = Validators.validateUsername(usernameController.text);
        ageError = Validators.validateAge(ageController.text);
        passwordError = Validators.validatePassword(passwordController.text);
      });
      if (nameError != null ||
          usernameError != null ||
          ageError != null ||
          passwordError != null) {
        return;
      }
      String childName = nameController.text.trim();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('child_name', childName);
      await prefs.setString('child_username', usernameController.text.trim());
      await prefs.setString('child_age', ageController.text.trim());

      final double? scoreResult = await Navigator.push<double>(
        context,
        MaterialPageRoute(
          builder:
              (_) => ExamSkeletonScreen(examId: 'exam2', childName: childName),
        ),
      );

      if (mounted && scoreResult != null) {
        Navigator.pop(context, {'name': childName, 'score': scoreResult});
      }
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
            children: [
              Text(
                "Bring kid onboard",
                style: TextStyle(
                  fontSize: config.headline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: config.localHeight * 0.02),
              Image.asset(
                'assets/images/student_data.png',
                height: config.imageHeight(0.25),
                width: config.imageWidth(0.8),
                fit: BoxFit.contain,
              ),
              SizedBox(height: config.localHeight * 0.03),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      fieldController: nameController,
                      fieldIcon: const Icon(Icons.face),
                      fieldLabel: "Child's name",
                      fieldObscure: false,
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
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: usernameController,
                      fieldIcon: const Icon(Icons.people),
                      fieldLabel: "Child's Username",
                      fieldObscure: false,
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
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: ageController,
                      fieldIcon: const Icon(Icons.date_range),
                      fieldLabel: "Child's Age",
                      fieldObscure: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          ageError = Validators.validateAge(value);
                        });
                      },
                    ),
                    if (ageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          ageError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: config.localHeight * 0.02),
                    CustomTextField(
                      fieldController: passwordController,
                      fieldIcon: const Icon(Icons.lock),
                      fieldLabel: "Child's Password",
                      fieldObscure: !isPasswordVisible,
                      onChanged: (value) {
                        setState(() {
                          passwordError = Validators.validatePassword(value);
                        });
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                                () => isPasswordVisible = !isPasswordVisible,
                          );
                        },
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xff837F7F),
                        ),
                      ),
                    ),
                    if (passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          passwordError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: config.localHeight * 0.04),
                    Container(
                      width: config.localWidth * 0.6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffffB74D),
                            Color(0xffff8A65),
                            Color(0xfff06292),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: handleAdd,
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
                        child: Text(
                          "Add My Little Star",
                          style: TextStyle(
                            fontSize: config.title,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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