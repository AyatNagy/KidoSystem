import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Models/level3/numbers/number_lesson_model.dart';

class NumberLessonWidget extends StatefulWidget {
  final NumberLessonData data;
  final VoidCallback onNext;

  const NumberLessonWidget({
    super.key,
    required this.data,
    required this.onNext,
  });

  @override
  State<NumberLessonWidget> createState() => _NumberLessonWidgetState();
}

class _NumberLessonWidgetState extends State<NumberLessonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _controller.reverse();
    });
  }

  Future<void> _playLesson() async {
    setState(() => _hasInteracted = true);
    _controller.forward();
    await _audioPlayer.setSource(AssetSource(widget.data.audioPath));
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6A4BB1), Color(0xFF4B2E83)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 15.0,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: _playLesson,
                    ),
                  ),
                ],
              ),
            ),

            // Number Image - Wrapped in Expanded to prevent overflow
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: _playLesson,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Image.asset(
                    widget.data.numberImagePath,
                    fit: BoxFit.contain, // Ensures it fits available space
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Characters in multiple rows for numbers 4-10
            // Characters section with more space
            if (widget.data.characterImagePath != null &&
                widget.data.characterImagePath!.isEmpty)
              Expanded(
                flex: 3, // Increased from 2 to 3 to give more vertical room
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 8, // Horizontal space between characters
                    runSpacing: 12, // Vertical space between the two rows
                    // At the top of your builder, add this logic:
                    children: List.generate(widget.data.number, (index) {
                      return FutureBuilder(
                        // Delay increases for each character: 0ms, 200ms, 400ms...
                        future: Future.delayed(
                          Duration(milliseconds: index * 300),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.elasticOut,
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                widget.data.characterImagePath!,
                                height: widget.data.number <= 3 ? 140 : 75,
                              ),
                            );
                          }
                          // Return an empty box while waiting for its turn to "pop"
                          return const SizedBox(width: 80, height: 80);
                        },
                      );
                    }),
                  ),
                ),
              ),
            // Next Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _hasInteracted ? 1.0 : 0.0,
                child: SizedBox(
                  height: 80, // Fixed height container to prevent layout shifts
                  child:
                      _hasInteracted
                          ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: widget.onNext,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                          : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
