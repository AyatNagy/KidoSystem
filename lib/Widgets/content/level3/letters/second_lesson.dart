import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Models/draganddrop_question.dart';
import '../../../../Widgets/draganddrop.dart';
import '../../../curclePainter.dart';

class DragDropLessonPage extends StatelessWidget {
  final DragDropQuestion questionData;
  final VoidCallback onNext;

  const DragDropLessonPage({
    super.key,
    required this.questionData,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              ),
            ),
          ),

          Positioned(top: 100, left: -40, child: _buildBlob(150, Colors.white.withOpacity(0.4))),
          Positioned(top: 250, right: -20, child: _buildBlob(100, Colors.white.withOpacity(0.3))),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              child: CustomPaint(painter: CurvePainter()),
            ),
          ),

          SafeArea(
            child: DragDropWidget(
              question: questionData,
              onAnswered: (answers) {
                if (answers.length == questionData.targets.length) {
                  HapticFeedback.heavyImpact();
                  onNext();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}