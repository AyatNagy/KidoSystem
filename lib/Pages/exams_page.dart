import 'package:flutter/material.dart';
import 'package:kido/Pages/Questions/tall_short_question_page.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../Models/question_model.dart';
import '../controllers/question_data.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int currentIndex = 0;
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final Question currentQuestion = questions[currentIndex];
    final List options = currentQuestion.data['options'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            children: [
              SizedBox(height: config.localHeight * 0.02),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Question ${currentIndex + 1}/${questions.length}",
                  style: TextStyle(
                    fontSize: config.body,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              SizedBox(height: config.localHeight * 0.01),

              Text(
                currentQuestion.title,
                style: TextStyle(
                  fontSize: config.headline,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: config.localHeight * 0.03),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: config.localWidth * 0.03,
                    mainAxisSpacing: config.localHeight * 0.03,
                    childAspectRatio: 1,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = selectedOption == option['id'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOption = option['id'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient:
                              isSelected
                                  ? const LinearGradient(
                                    colors: [
                                      Color(0xfff06292),
                                      Color(0xffff8a65),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : const LinearGradient(
                                    colors: [
                                      Color(0xffe0e0e0),
                                      Color(0xfff5f5f5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(config.localWidth * 0.03),
                        child: Center(
                          child: Image.asset(
                            option['imageUrl'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: config.localHeight * 0.02),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedOption != null ? nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: config.localHeight * 0.025,
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    currentIndex == questions.length - 1 ? "Finish" : "Next",
                    style: TextStyle(
                      fontSize: config.title,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: config.localHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TallShortQuestionPage()),
      );
    }
  }
}
