import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kido/Models/level3/animals/animal_model.dart';
import 'package:kido/Widgets/content/choise_item_widget.dart';
import 'package:kido/Widgets/content/content_app_bar.dart';
import 'package:kido/Widgets/content/success_overlay_widget.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/data/level3/animals/animals_data.dart';
import 'package:kido/services/audio_service.dart';

class AnimalsPracticePage extends StatefulWidget {
  const AnimalsPracticePage({super.key});

  @override
  State<AnimalsPracticePage> createState() => _AnimalsPracticePageState();
}

class _AnimalsPracticePageState extends State<AnimalsPracticePage>
    with SingleTickerProviderStateMixin {
  int _currentAnimalIndex = 0;
  bool showSuccess = false;
  bool isLocked = false;
  bool canAnimate = false;
  List<int> wrongIndices = [];

  late AnimalsModel correctAnimal;
  late List<AnimalsModel> currentOptions;

  Timer? hintTimer;

  Timer? startDelayTimer;
  late AnimationController stretchController;
  late Animation<double> stretchAnimation;

  @override
  void initState() {
    super.initState();
    stretchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    stretchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: stretchController, curve: Curves.easeInOut),
    );

    _loadLevel(_currentAnimalIndex);
  }

  void _loadLevel(int index) {
    setState(() {
      isLocked = false;
      showSuccess = false;
      canAnimate = false;
      wrongIndices.clear();

      correctAnimal = animalsDiscovery[index];

      List<AnimalsModel> others =
          animalsDiscovery.where((a) => a != correctAnimal).toList();
      AnimalsModel wrongAnimal = others[Random().nextInt(others.length)];

      currentOptions = [correctAnimal, wrongAnimal];
      currentOptions.shuffle();
    });

    _resetAndStartTimers();
  }

  void _resetAndStartTimers() {
    hintTimer?.cancel();
    startDelayTimer?.cancel();
    stretchController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !showSuccess) {
        AudioService.playSequence(
          "animals/where_is.mp3",
          correctAnimal.audioName,
        );
      }
    });

    startDelayTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !showSuccess) {
        setState(() => canAnimate = true);
      }
    });

    hintTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!showSuccess && mounted) {
        AudioService.playSequence(
          "animals/where_is.mp3",
          correctAnimal.audioName,
        );
      } else {
        timer.cancel();
      }
    });
  }

  void handleTap(int index) async {
    if (isLocked) return;

    if (currentOptions[index] == correctAnimal) {
      setState(() => isLocked = true);
      hintTimer?.cancel();
      startDelayTimer?.cancel();
      AudioService.stop();

      if (mounted) {
        setState(() => showSuccess = true);
        AudioService.playSequence("yaay.mp3", correctAnimal.audioName);
      }

      await Future.delayed(const Duration(seconds: 5));
      if (_currentAnimalIndex < animalsDiscovery.length - 1) {
        _currentAnimalIndex++;
        _loadLevel(_currentAnimalIndex);
      } else {
        if (mounted) Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        setState(() {
          if (!wrongIndices.contains(index)) wrongIndices.add(index);
        });
        AudioService.play(fileName: "wrong.mp3");
      }
    }
  }

  Matrix4 getHintTransform(double val) {
    return Matrix4.identity()
      ..translate(0.0, -15 * val)
      ..scale(1.0 + (0.05 * val));
  }

  Matrix4 _getIdleTransform(double val) {
    // Gentle up and down (8 pixels)
    return Matrix4.identity()..translate(0.0, -8 * val);
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    startDelayTimer?.cancel();
    stretchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          showSuccess
              ? null
              : PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: ContentAppBar(
                  title:
                      "أين الـ ${correctAnimal.audioName.split('/').last.split('_').first}?",
                ),
              ),
      body: SafeArea(
        child: Center(
          child:
              showSuccess
                  ? SuccessOverlay(
                    image: correctAnimal.animalPath,
                    title: '',
                    transform: Matrix4.identity(),
                  )
                  : Padding(
                    padding: config.pagePadding,
                    child: Center(
                      child: SizedBox(
                        height: config.imageHeight(0.7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(currentOptions.length, (
                            index,
                          ) {
                            bool isAnswer =
                                currentOptions[index] == correctAnimal;
                            return AnimatedBuilder(
                              animation: stretchAnimation,
                              builder: (context, child) {
                                Matrix4 finalTransform = Matrix4.identity();
                                bool isWrong = wrongIndices.contains(index);
                                if (isAnswer && canAnimate) {
                                  finalTransform = getHintTransform(
                                    stretchAnimation.value,
                                  );
                                } else if (!isWrong) {
                                  finalTransform = _getIdleTransform(
                                    stretchAnimation.value,
                                  );
                                }
                                return ChoiceItem(
                                  image: currentOptions[index].image!,
                                  isWrong: wrongIndices.contains(index),
                                  canAnimate: isAnswer && canAnimate,
                                  animation: stretchAnimation,
                                  onTap: () => handleTap(index),
                                  transform: finalTransform,
                                  height: config.imageHeight(0.9),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
