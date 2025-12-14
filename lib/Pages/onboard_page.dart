import 'package:flutter/material.dart';
import 'package:kido/Pages/home_page.dart';
import 'package:kido/controllers/unboarding_data.dart';
import '../Widgets/CustomCanditor.dart';
import '../Widgets/GradientButton.dart';
import '../Widgets/onBoard.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../config/ResponsiveConfig.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _goToNext(ResponsiveConfig config) {
    if (_index < onboardData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardData.length,
                  onPageChanged: (value) {
                    setState(() => _index = value);
                  },
                  itemBuilder: (context, i) => OnboardPage(
                    data: onboardData[i],
                  ),
                ),
              ), Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardData.length,
                          (i) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: config.localWidth * 0.01,
                        ),
                        child: CustomIndicator(
                          active: _index == i,
                          color: onboardData[i].color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.02),
                  GradientButton(
                    gradientColors: onboardData[_index].gradientColors,
                    title: "Continue",
                    height: config.buttonHeight,
                    fontSize: config.buttonFont,
                    onPressed: () => _goToNext(config),
                  ),
                  SizedBox(height: config.localHeight * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _skip,
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: config.body,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.02),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
