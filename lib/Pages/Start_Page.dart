import 'package:flutter/material.dart';
import 'package:kido/Pages/onboard_page.dart';
import 'package:kido/Widgets/GradientButton.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Image.asset('assets/images/log.png', height: 50, width: 60),
                  Image.asset('assets/images/Kido.png', height: 50, width: 60),
                ],
              ),
            ),
            Row(
              children: [
                Image.asset('assets/images/start1.png', height: 260),
                Image.asset('assets/images/start2.jpeg', height: 260),
                Image.asset('assets/images/start3.jpeg', height: 260),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Every Child’s\nJourney to Their Star!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    shadows: [
                      Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 3,
                        color: Colors.grey,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 28),
                GradientButton(
                  title: "Start Exploring!",
                  onPressed: () {
                  Navigator.pushReplacement( context, 
                  MaterialPageRoute(builder: (context) => OnboardScreen()),
                   );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
