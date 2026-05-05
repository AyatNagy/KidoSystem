import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Pages/child_level_select_page.dart';
import 'package:kido/Pages/child_profile_setup_page.dart';
import 'package:kido/Pages/exam_screen.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/responsive_provider.dart';
import '../Widgets/text_field_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/validators.dart';
import '../Widgets/dialog_widget.dart';
import '../Models/dailog_model.dart';
import '../api_service/api_services.dart';
import '../Models/child.dart';
import '../config/cache_helper.dart';
import 'package:kido/Widgets/password_errors_view.dart';

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
  //String? passwordError;
  bool isPasswordVisible = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  int _recommendLevelFromScore(double scoreRatio) {
    if (scoreRatio >= 0.80) return 3;
    if (scoreRatio >= 0.50) return 2;
    return 1;
  }

  Future<void> handleAdd() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        nameError = Validators.validateName(nameController.text);
        usernameError = Validators.validateUsername(usernameController.text);
        ageError = Validators.validateAge(ageController.text);
        //passwordError = Validators.validatePassword(passwordController.text);
      });

      if (nameError != null || usernameError != null || ageError != null) {
        return;
      }

      setState(() => isLoading = true);

      try {
        String childName = nameController.text.trim();
        String childUsername = usernameController.text.trim();
        String childPassword = passwordController.text.trim();
        int childAge = int.tryParse(ageController.text.trim()) ?? 0;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('child_name', childName);
        await prefs.setString('child_username', childUsername);
        await prefs.setString('child_age', ageController.text.trim());

        final child = Child(
          name: childName,
          username: childUsername,
          password: childPassword,
          dateOfBirth: DateTime.now().subtract(Duration(days: childAge * 365)),
        );

        final registerResponse = await ApiService.registerChild(child);

        if (registerResponse != null && mounted) {
          if (registerResponse['child'] != null &&
              registerResponse['child']['id'] != null) {
            await LocalStorage.setChildId(registerResponse['child']['id']);
          }

          if (childAge < 3) {
            if (!mounted) return;
            customDialog(
              context,
              DailogModel(
                title: "Level Assigned",
                message:
                    "Since $childName is under 3 years old, they will start at Level 1 to enjoy age-appropriate activities.",
                image: 'assets/images/exam.png',
                buttonText: "Start Journey",
              ),
              titleColor: const Color(0xff4CAF50),
              onNextPressed: () async {
                final setup = await Navigator.push<ChildProfileSetupResult>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChildProfileSetupPage(childName: childName),
                  ),
                );
                if (!mounted || setup == null) return;

                final pickedLevel =
                    await Navigator.push<ChildLevelSelectResult>(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ChildLevelSelectPage(
                              childName: setup.childName,
                              recommendedLevel: 1,
                            ),
                      ),
                    );
                if (!mounted || pickedLevel == null) return;

                Navigator.pop(context, {
                  'name': setup.childName,
                  'score': 1.0,
                  'childId': registerResponse['child']['id'],
                  'level': pickedLevel.level,
                  'avatar': setup.avatarAsset,
                });
              },
            );
          } else {
            String examId =
                (childAge >= 3 && childAge <= 5) ? 'exam2' : 'exam1';
            if (!mounted) return;
            customDialog(
              context,
              DailogModel(
                title: "Level Assessment",
                message:
                    "To provide the best experience for $childName, we need to perform a quick exam to determine their current level.",
                image: 'assets/images/exam.png',
              ),
              titleColor: const Color(0xfff06292),
              onNextPressed: () async {
                final double? scoreResult = await Navigator.push<double>(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ExamSkeletonScreen(
                          examId: examId,
                          childName: childName,
                        ),
                  ),
                );

                if (mounted && scoreResult != null) {
                  // Child-facing profile setup
                  final setup = await Navigator.push<ChildProfileSetupResult>(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChildProfileSetupPage(childName: childName),
                    ),
                  );

                  if (!mounted || setup == null) return;

                  final recommendedLevel = _recommendLevelFromScore(
                    scoreResult,
                  );
                  final pickedLevel =
                      await Navigator.push<ChildLevelSelectResult>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChildLevelSelectPage(
                                childName: setup.childName,
                                recommendedLevel: recommendedLevel,
                              ),
                        ),
                      );

                  if (!mounted || pickedLevel == null) return;

                  Navigator.pop(context, {
                    'name': setup.childName,
                    'score': scoreResult,
                    'childId': registerResponse['child']['id'],
                    'level': pickedLevel.level,
                    'avatar': setup.avatarAsset,
                  });
                }
              },
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('فشل في تسجيل الطفل. الرجاء المحاولة مجدداً.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
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
                      fieldLabel: "Child's Password",
                      fieldObscure: !isPasswordVisible,
                      onChanged: (value) {
                        setState(() {
                          //passwordError = Validators.validatePassword(value);
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

                    const SizedBox(height: 3),

                    SizedBox(
                      width: double.infinity,
                      child: PasswordErrorsView(
                        password: passwordController.text,
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
                        onPressed: isLoading ? null : handleAdd,
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
                            isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
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
