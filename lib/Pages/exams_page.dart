import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kido/Pages/Questions/tall_short_question_page.dart';
import 'package:kido/Widgets/appBar.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../Models/question_model.dart';
import '../controllers/question_data.dart';
import '../enum/question_type.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int currentIndex = 0;
  String? selectedOption;
  Map<String, List<String>> userSortingAnswers = {};

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
  }

  Future<void> speakQuestion(String text) async {
    await flutterTts.stop();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
    flutterTts.awaitSpeakCompletion(false);
    await Future.delayed(Duration(milliseconds: 100));
    flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final Question currentQuestion = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KidoAppBar(),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      currentQuestion.title,
                      style: TextStyle(
                        fontSize: config.headline,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.deepPurpleAccent),
                    onPressed: () => speakQuestion(currentQuestion.title),
                  ),
                ],
              ),
              SizedBox(height: config.localHeight * 0.03),
              Expanded(
                child: currentQuestion.type == QuestionType.choosing
                    ? buildChoosingUI(currentQuestion, config)
                    : buildSortingUI(currentQuestion, config),
              ),
              SizedBox(height: config.localHeight * 0.02),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => handleNext(currentQuestion),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: config.localHeight * 0.015,
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

  Widget buildChoosingUI(Question question, config) {
    final List options = question.data['options'];
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
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
              gradient: isSelected
                  ? const LinearGradient(
                colors: [Color(0xfff06292), Color(0xffff8a65)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : const LinearGradient(
                colors: [Color(0xffe0e0e0), Color(0xfff5f5f5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(2, 4),
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
    );
  }

  Widget buildSortingUI(Question question, config) {
    final List<String> targets = List<String>.from(question.data['targets']);
    final Map<String, String> items = Map<String, String>.from(question.data['items']);
    List<String> remainingItems = items.keys
        .where((item) => !(userSortingAnswers.values.any((list) => list.contains(item))))
        .toList();

    return Column(
      children: [
        Row(
          children: targets.map((targetImg) {
            return Expanded(
              child: DragTarget<String>(
                onAccept: (receivedItem) {
                  setState(() {
                    userSortingAnswers[targetImg] ??= [];
                    userSortingAnswers[targetImg]!.add(receivedItem);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  List<String> assignedItems = userSortingAnswers[targetImg] ?? [];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: config.imageWidth(0.45),
                        height: config.imageHeight(0.3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(targetImg),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: assignedItems.map((item) {
                              return Container(
                                width: config.imageWidth(0.2),
                                height: config.imageHeight(0.1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage(item),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: remainingItems.map((itemImg) {
            return Draggable<String>(
              data: itemImg,
              feedback: buildDragItem(itemImg, config),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: buildDragItem(itemImg, config),
              ),
              child: buildDragItem(itemImg, config),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildDragItem(String itemImg, config) {
    return Container(
      width: config.imageWidth(0.25),
      height: config.imageHeight(0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(itemImg),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void handleNext(Question currentQ) {
    if (currentQ.type == QuestionType.choosing && selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please choose an answer.")),
      );
      return;
    }

    if (currentQ.type == QuestionType.sorting) {
      int totalItems = currentQ.data['items'].length;
      int placedItems = userSortingAnswers.values.fold(0, (sum, list) => sum + list.length);
      if (placedItems != totalItems) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please sort all items first.")),
        );
        return;
      }
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        userSortingAnswers = {};
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TallShortQuestionPage()),
      );
    }
  }
}
