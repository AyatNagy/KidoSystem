import '../../Models/exams/speak_question.dart';

final List<SpeakQuestion> allSpaekQuestions = [
  SpeakQuestion(
    examId: ['exam2'],
    questionAudio: "exams/what_name.mp3",
    image: "assets/images/circle-shape.png",
    acceptedAnswers: ["دايره", "دايرة", "دائرة"],
  ),

  SpeakQuestion(
    examId: ['exam1'],
    questionAudio: "exams/what_name.mp3",
    image: "assets/images/cat2.png",
    acceptedAnswers: ["قطة", "قطه", "قط"],
  ),

  SpeakQuestion(
    examId: ["post_level2"],
    questionAudio: "exams/what_name.mp3",
    image: "assets/images/drawing/triangle.gif",
    acceptedAnswers: ["ثلث", "مثاث", "مثلث"],
  ),
];
