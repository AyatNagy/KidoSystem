import 'package:kido/Pages/level3/family_members/family_item.dart';
import 'package:kido/Pages/level3/family_members/family_exam.dart';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';

class FamilyMemberBody extends StatelessWidget {
  const FamilyMemberBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenWidth * 0.32;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: [
          // ── الجد ──
          Positioned(
            top: screenHeight * 0.10,
            left: screenWidth * 0.07,
            child: FamilyItem(
              image:
                  'assets/images/family_members/grandfather-removebg-preview.png',
              text: 'GrandFather',
              sound: 'assets/audio/family/grandfather_1.mp3',
              imageSize: imageSize,
            ),
          ),
          // ── الجدة ──
          Positioned(
            top: screenHeight * 0.10,
            right: screenWidth * 0.05,
            child: FamilyItem(
              image:
                  'assets/images/family_members/grandmother-removebg-preview.png',
              text: 'GrandMother',
              sound: 'assets/audio/family/grandmother_1.mp3',
              imageSize: imageSize,
            ),
          ),
          // ── الأب ──
          Positioned(
            top: screenHeight * 0.37,
            left: screenWidth * 0.02,
            child: FamilyItem(
              image: 'assets/images/family_members/father-removebg-preview.png',
              text: 'Father',
              sound: 'assets/audio/family/father.mp3',
              imageSize: imageSize,
            ),
          ),
          // ── الأم ──
          Positioned(
            top: screenHeight * 0.37,
            right: screenWidth * 0.05,
            child: FamilyItem(
              image: 'assets/images/family_members/mother-removebg-preview.png',
              text: 'Mother',
              sound: 'assets/audio/family/mother.mp3',
              imageSize: imageSize,
            ),
          ),
          // ── الأخ ──
          Positioned(
            top: screenHeight * 0.62,
            left: screenWidth * 0.04,
            child: FamilyItem(
              image:
                  'assets/images/family_members/brother-removebg-preview.png',
              text: 'Brother',
              sound: 'assets/audio/family/brother_1.mp3',
              imageSize: imageSize,
            ),
          ),
          // ── الأخت ──
          Positioned(
            top: screenHeight * 0.62,
            right: screenWidth * 0.08,
            child: FamilyItem(
              image: 'assets/images/family_members/sister-removebg-preview.png',
              text: 'Sister',
              sound: 'assets/audio/family/sister_1.mp3',
              imageSize: imageSize,
            ),
          ),

          Positioned(
            bottom: screenHeight * 0.03,
            right: screenWidth * 0.05,
            child: NextButton(
              color: const Color(0xFF4CAF50),
              shadowColor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FamilyExam()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
