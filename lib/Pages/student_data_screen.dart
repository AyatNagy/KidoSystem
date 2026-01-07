import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/Questions/tall_short_question_page.dart';
import 'package:kido/Pages/exam_screen.dart';
import 'package:kido/Models/child.dart';
import 'package:kido/bloc/child_register/child_register_cubit.dart';
import '../Widgets/appBar.dart';
import '../Widgets/text_field_item.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../Widgets/dialog_widget.dart';
import '../Models/dailogModel.dart';

import 'exams_page.dart';

class StudentData extends StatefulWidget {
  const StudentData({super.key});

  @override
  State<StudentData> createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)), // Default to 5 years ago
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      helpText: "Select Child's Date of Birth",
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return BlocProvider(
      create: (context) => ChildRegisterCubit(),
      child: BlocListener<ChildRegisterCubit, ChildRegisterState>(
        listener: (context, state) {
          if (state is ChildRegisterSuccess) {
            CustomDialog(
              context,
              dialogModel(
                title: "Success 🎉",
                message: "Child registered successfully!",
                image: "assets/images/signup-success.png",
              ),
              titleColor: Colors.green,
            );
            Future.delayed(const Duration(seconds: 4), () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExamSkeletonScreen(examId: 'exam1'),
                ),
              );
            });
          } else if (state is ChildRegisterFailure) {
            CustomDialog(
              context,
              dialogModel(
                title: "Error ❌",
                message: state.errorMessage,
                image: "assets/images/signup-faied.png",
              ),
              titleColor: Colors.red,
            );
          }
        },
        child: BlocBuilder<ChildRegisterCubit, ChildRegisterState>(
          builder: (context, state) {
            final cubit = context.read<ChildRegisterCubit>();
            final isLoading = state is ChildRegisterLoading;

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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter child's name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: config.localHeight * 0.02),
                            CustomTextField(
                              fieldController: usernameController,
                              fieldIcon: const Icon(Icons.people),
                              fieldLabel: "Child's Username",
                              fieldObscure: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter username";
                                }
                                if (value.length < 3) {
                                  return "Username must be at least 3 characters";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: config.localHeight * 0.02),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  fieldController: dateOfBirthController,
                                  fieldIcon: const Icon(Icons.date_range),
                                  fieldLabel: "Date of Birth (Optional)",
                                  fieldObscure: false,
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                            SizedBox(height: config.localHeight * 0.02),
                            CustomTextField(
                              fieldController: passwordController,
                              fieldIcon: const Icon(Icons.lock),
                              fieldLabel: "Child's Password",
                              fieldObscure: !isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
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
                            SizedBox(height: config.localHeight * 0.04),
                            Container(
                              width: config.localWidth * 0.5,
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
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          final child = Child(
                                            username: usernameController.text
                                                .trim(),
                                            name: nameController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                            dateOfBirth: selectedDate,
                                          );
                                          cubit.registerChild(child);
                                        }
                                      },
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
                                child: isLoading
                                    ? SizedBox(
                                        height: config.localHeight * 0.03,
                                        width: config.localHeight * 0.03,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
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
          },
        ),
      ),
    );
  }
}
