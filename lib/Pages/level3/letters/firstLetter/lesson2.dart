import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kido/data/level3/letters/firstLetter.dart';
import '../../../../Widgets/draganddrop.dart';

class Firstletter2 extends StatelessWidget {
  const Firstletter2({super.key});

  @override
  Widget build(BuildContext context) {
    final questionData = firstLetter[0];

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

          Positioned(
              top: 100,
              left: -40,
              child: _buildBlob(
                  150,
                  Colors.white.withOpacity(0.4)
              )
          ),

          Positioned(
              top: 250,
              right: -20,
              child: _buildBlob(
                  100,
                  Colors.white.withOpacity(0.3)
              )
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(),
              ),
            ),
          ),

          SafeArea(
            child: DragDropWidget(
              question: questionData,
              onAnswered: (answers) {
                if (answers.length == questionData.targets.length) {
                  HapticFeedback.lightImpact();
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
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = const Color(0xFFF1F8E9).withOpacity(0.5);
    var path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 30);
    path.quadraticBezierTo(size.width * 0.75, 60, size.width, 10);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}