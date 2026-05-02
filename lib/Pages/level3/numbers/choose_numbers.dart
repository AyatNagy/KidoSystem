// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Pages/level3/numbers/numbers_map.dart';
import 'dart:math' as math;
import 'package:kido/constants.dart';



class NumbersLanguageSelectionPage extends StatefulWidget {
  const NumbersLanguageSelectionPage({super.key});

  @override
  State<NumbersLanguageSelectionPage> createState() => _NumbersLanguageSelectionPageState();
}

class _NumbersLanguageSelectionPageState extends State<NumbersLanguageSelectionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _mainController;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Colors.white],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Choose a World",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'tinyKids',
                    color: AppColors.kidoPink,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLanguageCard(
                      title: "العربية",
                      imagePath: 'assets/images/arabicNumbers/choose_language.jpeg',
                      cardColor: AppColors.kidoYellow,
                      photoWidthFactor: 1,
                      delay: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NumbersMapPage(isEnglish:false ,),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildLanguageCard(
                      title: "English",
                      imagePath: 'assets/images/englishNumbers.jpeg',
                      cardColor: AppColors.kidoYellow,
                      photoWidthFactor: 1,
                      delay: math.pi,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NumbersMapPage(isEnglish: true,),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required String imagePath,
    required Color cardColor,
    required double photoWidthFactor,
    required double delay,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        final floatValue = math.sin(
          _mainController.value * 2 * math.pi + delay,
        );

        return Transform.translate(
          offset: Offset(0, 10 * floatValue),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            Container(
              height: 200,
              width: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: cardColor, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: photoWidthFactor,
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
