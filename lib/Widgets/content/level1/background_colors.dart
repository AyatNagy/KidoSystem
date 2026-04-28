import 'package:flutter/material.dart';

class BackgroundColors extends StatelessWidget {
  const BackgroundColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF1F8E9)],
          ),
        )
    );
  }
}
