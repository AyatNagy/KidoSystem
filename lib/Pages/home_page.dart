import 'package:flutter/material.dart';
import 'package:kido/Pages/parent_login_screen.dart';
import 'Kid_Login.dart';
import '../Widgets/ResponsiveProvider.dart';
import '../config/ResponsiveConfig.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // قائمة الأطفال المضافة
  List<Map<String, dynamic>> children = [];

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
              SizedBox(height: config.localHeight * 0.02),
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
                    onPressed: () async {
                      // فتح شاشة KidoLogin / StudentData
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => KidoLogin()),
                      );

                      if (result != null) {
                        setState(() {
                          // لو الطفل أقل من 3 سنوات يضاف مباشرة بدون سكور
                          if (result['addedDirectly'] == true) {
                            children.add({
                              'name': result['name'],
                              'age': result['age'],
                              'score': null, // مش محتاج سكور
                            });
                          } else {
                            // لو الطفل بيمتحن نضيفه مع سكور
                            children.add({
                              'name': result['name'],
                              'age': result['age'],
                              'score': result['score'],
                            });
                          }
                        });
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: config.localHeight * 0.04),

              // عرض الأطفال المضافين
              if (children.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Children:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...children.map(
                      (child) => Card(
                        child: ListTile(
                          title: Text(child['name']),
                          subtitle: Text("Age: ${child['age']}"),
                          trailing:
                              child['score'] != null
                                  ? Text("Score: ${child['score']}")
                                  : const Text("No exam"),
                        ),
                      ),
                    ),
                  ],
                ),
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
