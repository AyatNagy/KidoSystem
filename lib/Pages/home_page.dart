import 'package:flutter/material.dart';
import '../Widgets/responsive_provider.dart';
import '../config/responsive_config.dart';
import 'Auth/kid_login.dart';
import 'Auth/parent_login_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: config.localHeight * 0.03),

              Image.asset(
                'assets/images/kido.png',
                width: config.imageWidth(0.5),
                fit: BoxFit.contain,
              ),

              Transform.translate(
                offset: Offset(0, -config.localHeight * 0.03),
                child: Expanded(
                  child: Image.asset(
                    'assets/images/home.png',
                    width: config.localWidth * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Expanded(child: SizedBox()),

              Text(
                'I am a...',
                style: TextStyle(
                  fontSize: config.headline,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),

              SizedBox(height: config.localHeight * 0.04),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // _buildRoleButton(
                  //   config: config,
                  //   title: 'Teacher',
                  //   icon: Icons.school_outlined,
                  //   gradient: const LinearGradient(
                  //     colors: [Color(0xFF8869B3), Color(0xFF4C99A8)],
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => TeacherLogin()),
                  //     );
                  //   },
                  // ),
                  _buildRoleButton(
                    config: config,
                    title: 'Parent',
                    image: 'assets/images/pa (2).png',
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE68A5C), Color(0xFFF6C16D)],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ParentLogin()),
                      );
                    },
                  ),
                  _buildRoleButton(
                    config: config,
                    title: 'Student',
                    icon: Icons.face,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4C99A8), Color(0xFF8AC6D1)],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => KidoLogin()),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: config.localHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required ResponsiveConfig config,
    required String title,
    IconData? icon,
    String? image,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: config.localWidth * 0.25,
      height: config.buttonHeight * 1.4,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
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
              Icon(icon, color: Colors.white, size: config.buttonFont)
            else if (image != null)
              Image.asset(
                image,
                width: config.buttonFont,
                height: config.buttonFont,
                fit: BoxFit.contain,
              ),
            SizedBox(height: config.localHeight * 0.01),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: config.body,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
