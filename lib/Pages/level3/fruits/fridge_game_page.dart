import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kido/Models/level3/fruits/discovery_fruits.dart';
import 'package:kido/data/level3/fruits/fruits_discovery.dart';
import 'package:kido/services/audio_service.dart';

class FridgeGamePage extends StatefulWidget {
  const FridgeGamePage({super.key});

  @override
  State<FridgeGamePage> createState() => _FridgeGamePageState();
}

class _FridgeGamePageState extends State<FridgeGamePage> {
  late FruitsModel currentFruit;
  final Random random = Random();

  Map<String, Offset> itemsPosition = {};

  @override
  void initState() {
    super.initState();
    _generateFruit();
    _initPositions();
  }

  void _generateFruit() {
    currentFruit = fruitsDiscovery[random.nextInt(fruitsDiscovery.length)];
    AudioService.play(fileName: currentFruit.audioName);
  }

  void _initPositions() {
    itemsPosition = {
      "apple": const Offset(0.25, 0.35),
      "banana": const Offset(0.55, 0.35),
      "strawberry": const Offset(0.40, 0.55),
    };
  }

  void _onDrop(String id, bool isCorrect) {
    if (isCorrect) {
      AudioService.play(fileName: "yaay.mp3");

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _generateFruit();
        });
      });
    } else {
      //AudioService.play(fileName: "wrong.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            children: [
              /// 🖼️ الخلفية
              Positioned.fill(
                child: Image.asset(
                  "assets/images/fruits/fridge_open.png",
                  fit: BoxFit.cover,
                ),
              ),

              /// 🧠 فقاعة التفكير (الفاكهة المطلوبة)
              Positioned(
                left: size.width * 0.05,
                top: size.height * 0.25,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(currentFruit.fruitPath),
                  ),
                ),
              ),

              /// 🧺 السلة (Target)
              Positioned(
                left: size.width * 0.35,
                top: size.height * 0.80,
                width: size.width * 0.3,
                height: size.height * 0.15,
                child: DragTarget<String>(
                  onWillAccept: (_) => true,
                  onAccept: (data) {
                    final isCorrect =
                        data == currentFruit.fruitPath.split('/').last;

                    _onDrop(data, isCorrect);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return const SizedBox();
                  },
                ),
              ),

              /// 🍎 الفواكه
              ...fruitsDiscovery.map((fruit) {
                final id = fruit.fruitPath.split('/').last;

                final pos = itemsPosition[id] ?? const Offset(0.3, 0.4);

                return Positioned(
                  left: size.width * pos.dx,
                  top: size.height * pos.dy,
                  child: Draggable<String>(
                    data: id,
                    feedback: Image.asset(fruit.fruitPath, width: 80),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: Image.asset(fruit.fruitPath, width: 70),
                    ),
                    child: Image.asset(fruit.fruitPath, width: 70),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
