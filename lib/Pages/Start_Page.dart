import 'package:flutter/material.dart';
import 'package:kido/home_page.dart';
import 'package:kido/unboarding_page.dart';

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
                    Image.asset(
                      'images/log.png',
                      height: 50,
                      width: 60,
                    ),
                    Image.asset(
                      'images/kido.png',
                      height: 60,
                      width: 60,
                    ),
                  ],
                )
            ),
            Center(
              child:Expanded(
                  child:Image.asset(
                    'images/Start.png',
                    height: 400,
                    width: 400,
                    fit: BoxFit.contain,
                  )
              )
            ),
              Column(
                children: [
                  const SizedBox(height: 1),
                  const Text(
                    "Every Child’s\nJourney to Their Star!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:30,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.grey,
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OnboardingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.zero,
                        elevation: 3,
                        backgroundColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFE68A5C),
                              Color(0xFF8869B3),
                              Color(0xFF4C99A8),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Start Exploring!",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
