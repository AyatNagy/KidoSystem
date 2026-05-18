import 'package:flutter/material.dart';
import 'package:kido/config/app_launch.dart';

import '../../constants.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _SplashScreen();
}

class _SplashScreen extends State<Logo> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final destination = await AppLaunch.getStartupDestination();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AppLaunch.widgetForDestination(destination),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.bgColor,
        child: Center(
          child: Image.asset(
            'assets/images/logo.jpeg',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
