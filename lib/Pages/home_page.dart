import 'package:flutter/material.dart';
import 'responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context));
    final bool isTablet = deviceType == DeviceType.Tablet;
    final bool isDesktop = deviceType == DeviceType.Desktop;

    double imageWidth = isDesktop
        ? 600
        : isTablet
        ? 500
        : 350;

    double fontSize = isDesktop
        ? 60
        : isTablet
        ? 50
        : 36;

    double buttonWidth = isDesktop
        ? 180
        : isTablet
        ? 140
        : 100;

    double buttonHeight = isDesktop
        ? 120
        : isTablet
        ? 100
        : 80;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 200 : 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      'images/kido.png',
                      width: imageWidth,
                      fit: BoxFit.contain,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -70),
                      child: Image.asset(
                        'images/home.png',
                        width: imageWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'I am a...',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRoleButton(
                    title: 'Teacher',
                    icon: Icons.school_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8869B3), Color(0xFF4C99A8)],
                    ),
                    width: buttonWidth,
                    height: buttonHeight,
                    onPressed: () {
                      // TODO: Navigate to Teacher page
                    },
                  ),
                  _buildRoleButton(
                    title: 'Parent',
                    image: 'images/pa (2).png',
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE68A5C), Color(0xFFF6C16D)],
                    ),
                    width: buttonWidth,
                    height: buttonHeight,
                    onPressed: () {
                      // TODO: Navigate to Parent page
                    },
                  ),
                  _buildRoleButton(
                    title: 'Student',
                    icon: Icons.face,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4C99A8), Color(0xFF8AC6D1)],
                    ),
                    width: buttonWidth,
                    height: buttonHeight,
                    onPressed: () {
                      // TODO: Navigate to Student page
                    },
                  ),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildRoleButton({
    required String title,
    IconData? icon,
    String? image,
    required Gradient gradient,
    required double width,
    required double height,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: 35)
            else if (image != null)
              Image.asset(
                  image,
                  width: 40,
                  height: 35,
                  fit: BoxFit.contain
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

