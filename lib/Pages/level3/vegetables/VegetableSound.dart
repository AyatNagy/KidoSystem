import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'Vegetablemodel.dart';

class VegetableSound extends StatefulWidget {
  int index;
  VegetableSound(this.index, {super.key});

  @override
  State<VegetableSound> createState() => _VegetableSoundState();
}

List<Numbermodel> vegetablelist = vegetable1();

class _VegetableSoundState extends State<VegetableSound>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;
  late AnimationController _pulseController;

  final List<List<Color>> _gradients = [
    [const Color(0xFF43A047), const Color(0xFF66BB6A)], // broccoli
    [const Color(0xFFEF5350), const Color(0xFFE57373)], // carrot
    [const Color(0xFFE91E63), const Color(0xFFF06292)], // chili
    [const Color(0xFF5C6BC0), const Color(0xFF7986CB)], // onion
    [const Color(0xFF1E88E5), const Color(0xFF42A5F5)], // tomato
  ];

  List<Color> get _currentGradient =>
      _gradients[widget.index % _gradients.length];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _speak();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future _speak() async {
    setState(() => _isSpeaking = true);
    _pulseController.repeat(reverse: true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(vegetablelist[widget.index].Text);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSpeaking = false);
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  void _next() {
    if (widget.index < vegetablelist.length - 1) {
      setState(() => widget.index++);
      _speak();
    }
  }

  void _prev() {
    if (widget.index > 0) {
      setState(() => widget.index--);
      _speak();
    }
  }

  @override
  Widget build(BuildContext context) {
    final veggie = vegetablelist[widget.index];
    final isFirst = widget.index == 0;
    final isLast = widget.index == vegetablelist.length - 1;
    final grad = _currentGradient;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [grad[0].withOpacity(0.1), Colors.white, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header (Back & Title) ──────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRoundBtn(
                      Icons.arrow_back_ios_new,
                      () => Navigator.pop(context),
                      grad[0],
                    ),
                    Column(
                      children: [
                        Text(
                          'Vegetable Lesson',
                          style: TextStyle(
                            color: grad[0],
                            fontFamily: "arlrdbd",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.index + 1} of ${vegetablelist.length}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 45), // للتوازن
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Container(
                    width: 220,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(110),
                      boxShadow: [
                        BoxShadow(
                          color: grad[0].withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                      border: Border.all(
                        color: grad[0].withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                            veggie.image,
                            height: 180,
                            fit: BoxFit.contain,
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(
                            begin: 0,
                            end: -15,
                            duration: 1500.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ),
                ),
              ),

              // ── النصوص (إنجليزي وعربي) ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      veggie.Text, // English
                      style: TextStyle(
                        fontSize: 42,
                        fontFamily: "arlrdbd",
                        color: grad[0],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      veggie.textAr, // Arabic
                      style: const TextStyle(
                        fontSize: 26,
                        fontFamily: "arlrdbd",
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale =
                      1.0 + (_isSpeaking ? _pulseController.value * 0.15 : 0);
                  return Transform.scale(scale: scale, child: child);
                },
                child: GestureDetector(
                  onTap: _speak,
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: grad),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: grad[0].withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavBtn(
                      Icons.arrow_back_ios_rounded,
                      isFirst ? null : _prev,
                      grad,
                      isFirst,
                    ),
                    _buildNavBtn(
                      Icons.arrow_forward_ios_rounded,
                      isLast ? null : _next,
                      grad,
                      isLast,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundBtn(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildNavBtn(
    IconData icon,
    VoidCallback? onTap,
    List<Color> grad,
    bool disabled,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade200 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            if (!disabled)
              BoxShadow(
                color: grad[0].withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
          border: Border.all(
            color: disabled ? Colors.transparent : grad[0].withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: disabled ? Colors.grey.shade400 : grad[0],
          size: 26,
        ),
      ),
    );
  }
}
