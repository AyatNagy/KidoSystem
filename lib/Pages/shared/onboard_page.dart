import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/l10n/l10n_extension.dart';
import 'package:kido/Pages/parent_content/parent_home_page.dart';
import 'package:kido/Pages/Auth/parent_login_screen.dart';
import '../../Widgets/custom_canditor.dart';
import '../../Widgets/Buttons/gradient_button.dart';
import '../../Widgets/on_board.dart';
import '../../config/responsive_config.dart';
import '../../config/app_launch.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _goToNext(ResponsiveConfig config) {
    final count = context.l10n.onboardPages.length;
    if (_index < count - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    await AppLaunch.setOnboardingSeen();
    if (!mounted) return;
    final loggedIn = await AppLaunch.isParentLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const ParentHomePage() : const ParentLogin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final pages = context.l10n.onboardPages;

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
                  itemCount: pages.length,
                  onPageChanged: (value) {
                    setState(() => _index = value);
                  },
                  itemBuilder:
                      (context, i) => OnboardPage(data: pages[i]),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: config.localWidth * 0.01,
                        ),
                        child: CustomIndicator(
                          active: _index == i,
                          color: pages[i].color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.02),
                  GradientButton(
                    gradientColors: pages[_index].gradientColors,
                    title: context.l10n.continueButton,
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
                        context.l10n.skip,
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
