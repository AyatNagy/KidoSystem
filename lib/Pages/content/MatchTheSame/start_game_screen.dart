import 'package:flutter/material.dart';
import 'package:kido/Pages/content/MatchTheSame/game_screen.dart';

import 'package:kido/Pages/content/MatchTheSame/how_to_play_screen.dart';
import 'package:lottie/lottie.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("تعلم تماثل تماثل الاشياء"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          LottieBuilder.asset("assets/lottie/brain_animation.json"),
          const SizedBox(height: 25),
          OutlinedButton.icon(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
                ),
            icon: const Icon(Icons.help_outline),
            label: const Text('كيف تلعب؟'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyFlipCardGame()),
              );
            },
            child: const Text("Start Game"),
          ),
        ],
      ),
    );
  }
}
