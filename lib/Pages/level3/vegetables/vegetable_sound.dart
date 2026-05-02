// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'Vegetablemodel.dart';

List<Numbermodel> vegetablelist = vegetable1();

class VegetableSound extends StatefulWidget {
  final int index;
  const VegetableSound(this.index, {super.key});

  @override
  State<VegetableSound> createState() => _VegetableSoundState();
}

class _VegetableSoundState extends State<VegetableSound>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late int currentIndex;
  bool _isSpeaking = false;

  late AnimationController _pulseController;
  late AnimationController _bgController;

  static const _themes = [
    _VegTheme(
      colors: [Color(0xFF2E7D32), Color(0xFF66BB6A), Color(0xFFA5D6A7)],
      emoji: ['🥦', '🌿', '✨'],
    ),
    _VegTheme(
      colors: [Color(0xFFE65100), Color(0xFFFF8F00), Color(0xFFFFCC80)],
      emoji: ['🥕', '🌟', '🍊'],
    ),
    _VegTheme(
      colors: [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFEF9A9A)],
      emoji: ['🌶️', '🔥', '✨'],
    ),
    _VegTheme(
      colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFCE93D8)],
      emoji: ['🧅', '💜', '🌙'],
    ),
    _VegTheme(
      colors: [Color(0xFFC62828), Color(0xFFEF5350), Color(0xFFFFCDD2)],
      emoji: ['🍅', '❤️', '🌿'],
    ),
  ];

  _VegTheme get _theme => _themes[currentIndex % _themes.length];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _speak();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bgController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future _speak() async {
    await flutterTts.stop();
    setState(() => _isSpeaking = true);
    HapticFeedback.mediumImpact();
    _pulseController.repeat(reverse: true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(vegetablelist[currentIndex].Text);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = false);
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  void _next() {
    if (currentIndex < vegetablelist.length - 1) {
      setState(() => currentIndex++);
      _speak();
    }
  }

  void _prev() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _speak();
    }
  }

  @override
  Widget build(BuildContext context) {
    final veggie = vegetablelist[currentIndex];
    final grad = _theme.colors;
    final emojis = _theme.emoji;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(
                    -0.3 + _bgController.value * 0.6,
                    -0.4 + _bgController.value * 0.4,
                  ),
                  radius: 1.4,
                  colors: [
                    grad[0].withOpacity(0.85),
                    grad[1].withOpacity(0.70),
                    grad[2].withOpacity(0.45),
                    Colors.white.withOpacity(0.88),
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          Positioned(top: -80, left: -80, child: Blob(color: grad[0], size: 260)),
          Positioned(bottom: -60, right: -60, child: Blob(color: grad[1], size: 220)),
          Positioned(top: size.height * 0.4, left: -40, child: Blob(color: grad[2], size: 120)),

          for (int i = 0; i < emojis.length; i++)
            Positioned(
              left: [0.07, 0.82, 0.88][i] * size.width,
              top: [0.28, 0.14, 0.58][i] * size.height,
              child: Text(emojis[i], style: const TextStyle(fontSize: 28))
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: 0, end: -16, duration: (1400 + i * 350).ms)
                  .fadeIn(delay: (200 * i).ms),
            ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: grad[0].withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: grad[0], size: 20),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: 500.ms,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                      child: Image.asset(
                        veggie.image,
                        key: ValueKey(currentIndex),
                        width: size.width * 0.88,
                        height: size.height * 0.68,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.eco,
                          size: 200,
                          color: Colors.white,
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                        begin: const Offset(0.90, 0.90),
                        end: const Offset(1.0, 1.0),
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      )
                          .moveY(
                        begin: 6,
                        end: -6,
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 30, left: 36, right: 36, top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavBtn(
                        icon: Icons.arrow_back_ios_rounded,
                        onTap: currentIndex == 0 ? null : _prev,
                        grad: grad,
                      ),
                      ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.18).animate(
                          CurvedAnimation(
                            parent: _pulseController,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: _speak,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [grad[0], grad[1]],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: grad[0].withOpacity(0.45),
                                  blurRadius: 22,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 38),
                          ),
                        ),
                      ),
                      _NavBtn(
                        icon: Icons.arrow_forward_ios_rounded,
                        onTap: currentIndex == vegetablelist.length - 1 ? null : _next,
                        grad: grad,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Blob extends StatelessWidget {
  final Color color;
  final double size;
  const Blob({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(0.18),
    ),
  );
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final List<Color> grad;
  const _NavBtn({required this.icon, this.onTap, required this.grad});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: () {
        if (enabled) {
          HapticFeedback.lightImpact();
          onTap!();
        }
      },
      child: AnimatedOpacity(
        duration: 250.ms,
        opacity: enabled ? 1.0 : 0.28,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: enabled
                ? [
              BoxShadow(
                color: grad[0].withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ]
                : [],
          ),
          child: Icon(icon, color: enabled ? grad[0] : Colors.grey, size: 24),
        ),
      ),
    );
  }
}

class _VegTheme {
  final List<Color> colors;
  final List<String> emoji;
  const _VegTheme({required this.colors, required this.emoji});
}