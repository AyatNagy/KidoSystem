import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/Pages/kid/child_level_select_page.dart';
import 'package:kido/Pages/kid/child_profile_setup_page.dart';
import 'package:kido/Pages/kid/exam_screen.dart';
import '../../Widgets/Layout/app_bar.dart';
import '../../Widgets/responsive_provider.dart';
import '../../Widgets/text_field_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../utils/validators.dart';
import '../../Widgets/Dialogs/dialog_widget.dart';
import '../../Models/dailog_model.dart';
import '../../api_service/api_services.dart';
import 'package:kido/bloc/set_initial_level/set_initial_level_cubit.dart';
import '../../Models/child.dart';
import '../../config/cache_helper.dart';
import 'package:kido/Widgets/Auth/password_errors_view.dart';

class StudentData extends StatefulWidget {
  const StudentData({super.key});

  @override
  State<StudentData> createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {
  late final SetInitialLevelCubit _setInitialLevelCubit;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? nameError;
  String? usernameError;
  String? ageError;
  bool isPasswordVisible = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setInitialLevelCubit = SetInitialLevelCubit();
  }

  @override
  void dispose() {
    _setInitialLevelCubit.close();
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    ageController.dispose();
    super.dispose();
  }

  String _setInitialLevelErrorText() {
    final s = _setInitialLevelCubit.state;
    if (s is SetInitialLevelFailure) {
      return s.errorMessage;
    }
    return 'تعذّر حفظ المستوى على السيرفر.';
  }

  Future<void> handleAdd() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        nameError = Validators.validateName(nameController.text);
        usernameError = Validators.validateUsername(usernameController.text);
        ageError = Validators.validateAge(ageController.text);
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
              titleColor: AppColors.kidoGreen,
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
                              childId:
                                  (registerResponse['child']?['id'] as num?)
                                      ?.toInt() ??
                                  0, // ← بدل setup.childId
                              recommendedLevel: 1,
                              isRestrictedToLevel1: true,
                            ),
                      ),
                    );
                if (!mounted || pickedLevel == null) return;

                final cid = registerResponse['child']?['id'];
                if (cid != null) {
                  final ok = await _setInitialLevelCubit.setInitialLevel(
                    childId: (cid as num).toInt(),
                    levelId: pickedLevel.level,
                  );
                  if (!mounted) return;
                  if (!ok) {
                    final msg = _setInitialLevelErrorText();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        backgroundColor: AppColors.kidoRed,
                      ),
                    );
                  }
                }

                if (!mounted) return;
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
                (childAge >= 3 && childAge <= 5) ? 'exam1' : 'exam2';
            if (!mounted) return;
            customDialog(
              context,
              DailogModel(
                title: "Level Assessment",
                message:
                    "To provide the best experience for $childName, we need to perform a quick exam to determine their current level.",
                image: 'assets/images/exam.png',
              ),
              titleColor: AppColors.kidoPink,
              onNextPressed: () async {
                final dynamic examResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ExamSkeletonScreen(
                          examId: examId,
                          childName: childName,
                          onboardingPlacement: true,
                          childId: registerResponse['child']?['id'],
                        ),
                  ),
                );

                if (mounted && examResult != null) {
                  int assignedLevel = (examResult is int) ? examResult : 1;
                  if (assignedLevel < 1) assignedLevel = 1;
                  if (assignedLevel > 3) assignedLevel = 3;

                  final cid = registerResponse['child']?['id'];
                  if (cid != null) {
                    final ok = await _setInitialLevelCubit.setInitialLevel(
                      childId: (cid as num).toInt(),
                      levelId: assignedLevel,
                    );
                    if (!mounted) return;
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_setInitialLevelErrorText()),
                          backgroundColor: AppColors.kidoRed,
                        ),
                      );
                    }
                  }

                  final setup = await Navigator.push<ChildProfileSetupResult>(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChildProfileSetupPage(childName: childName),
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
                                childId:
                                    (registerResponse['child']?['id'] as num?)
                                        ?.toInt() ??
                                    0,
                                recommendedLevel: assignedLevel,
                                forcedUnlockedLevel: assignedLevel,
                                isRestrictedToLevel1: false,
                              ),
                        ),
                      );

                  if (!mounted || pickedLevel == null) return;

                  final cid2 = registerResponse['child']?['id'];
                  if (cid2 != null) {
                    final ok2 = await _setInitialLevelCubit.setInitialLevel(
                      childId: (cid2 as num).toInt(),
                      levelId: pickedLevel.level,
                    );
                    if (!mounted) return;
                    if (!ok2) {
                      final msg = _setInitialLevelErrorText();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                          backgroundColor: AppColors.kidoRed,
                        ),
                      );
                    }
                  }

                  if (!mounted) return;
                  Navigator.pop(context, {
                    'name': setup.childName,
                    'score': 1.0,
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
                backgroundColor: AppColors.kidoRed,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ: $e'),
              backgroundColor: AppColors.kidoRed,
            ),
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
      backgroundColor: AppColors.bgColor,
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
                            color: AppColors.kidoRed,
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
                            color: AppColors.kidoRed,
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
