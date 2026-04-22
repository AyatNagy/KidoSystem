import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';

import '../Widgets/appBar.dart';
import 'onboard_page.dart';
import 'package:kido/Pages/parent_home_page.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import '../config/app_launch.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KidoAppBar(),
      body: Padding(
        padding: config.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/Start.png',
                  height: config.imageHeight(1),
                  width: config.imageWidth(1),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Column(
              children: [
                Text(
                  "Every Child’s\nJourney to Their Star!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: config.headline,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                    shadows: const [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: config.localHeight * 0.05),
                SizedBox(
                  width: double.infinity,
                  height: config.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final seen = await AppLaunch.isOnboardingSeen();
                      final loggedIn = await AppLaunch.isParentLoggedIn();
                      if (!context.mounted) return;

                      if (!seen) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardScreen(),
                          ),
                        );
                        return;
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  loggedIn
                                      ? const ParentHomePage()
                                      : const ParentLogin(),
                        ),
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
                        child: Text(
                          "Start Exploring!",
                          style: TextStyle(
                            fontSize: config.buttonFont,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: config.localHeight * 0.05),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
