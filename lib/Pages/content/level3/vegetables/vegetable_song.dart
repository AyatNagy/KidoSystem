// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/level3/vegetables/vegetable_model.dart';

class VegetableSong extends StatefulWidget {
  const VegetableSong({super.key});

  @override
  State<VegetableSong> createState() => _VegetableSongState();
}

class _VegetableSongState extends State<VegetableSong>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  final PageController _pageCtrl = PageController();

  int _page = 0;
  bool isPressed = false;
  bool showSuccess = false;
  bool isLocked = false;
  List<String> wrongSelections = [];
  Timer? _hintTimer;

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  final List<Numbermodel> _list = vegetable1();

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _glowAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _startPage(0);
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _glowCtrl.dispose();
    flutterTts.stop();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.1);
    await flutterTts.speak(text);
  }

  void _startPage(int page) {
    _hintTimer?.cancel();
    showSuccess = false;
    isPressed = false;
    isLocked = false;
    wrongSelections = [];

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _speak(_list[page].text);
    });

    _hintTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!isPressed && mounted) _speak(_list[page].text);
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !showSuccess) {
        _glowCtrl.repeat(reverse: true);
      }
    });
  }

  void _handleTap(String key, bool isCorrect) async {
    if (isLocked || wrongSelections.contains(key)) return;

    setState(() {
      isLocked = true;
      isPressed = true;
    });

    if (isCorrect) {
      _hintTimer?.cancel();
      _glowCtrl.stop();
      _glowCtrl.reset();
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => showSuccess = true);
      await _speak(_list[_page].text);
    } else {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        setState(() {
          isLocked = false;
          isPressed = false;
          wrongSelections.add(key);
        });
        if (!_glowCtrl.isAnimating) _glowCtrl.repeat(reverse: true);
      }
    }
  }

  void _nextPage() {
    if (_page + 1 < vegitablesongs2.length) {
      setState(() {
        _page++;
        _startPage(_page);
      });
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_page > 0) {
      setState(() {
        _page--;
        _startPage(_page);
      });
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _pageCtrl,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vegitablesongs2.length,
        itemBuilder: (ctx, pageIndex) {
          final q = vegitablesongs2[pageIndex];
          final veg = _list[pageIndex];

          return showSuccess ? _buildSuccess(veg) : _buildQuestion(ctx, q, veg);
        },
      ),
    );
  }

  Widget _buildQuestion(BuildContext ctx, QuestionModel q, Numbermodel veg) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleBtn(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(ctx),
                  bg: Colors.grey.shade100,
                  iconColor: Colors.black54,
                ),
                Column(
                  children: [
                    Text(
                      veg.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE65100),
                        fontFamily: 'arlrdbd',
                      ),
                    ),
                    Text(
                      veg.textAr,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black45,
                        fontFamily: 'arlrdbd',
                      ),
                    ),
                  ],
                ),
                _CircleBtn(
                  icon: Icons.volume_up_rounded,
                  onTap: () => _speak(veg.text),
                  bg: const Color(0xFFE65100),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  q.answer.entries.map((e) {
                    final key = e.key;
                    final isCorrect = e.value;
                    return _buildOption(key, isCorrect);
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 32,
              left: 40,
              right: 40,
              top: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleBtn(
                  icon: Icons.arrow_back_ios_rounded,
                  onTap: _page == 0 ? null : _prevPage,
                  bg: _page == 0 ? Colors.grey.shade200 : Colors.white,
                  iconColor: _page == 0 ? Colors.grey : const Color(0xFFE65100),
                  shadow: _page != 0,
                ),
                _CircleBtn(
                  icon: Icons.arrow_forward_ios_rounded,
                  onTap: isPressed ? _nextPage : null,
                  bg:
                      isPressed
                          ? const Color(0xFFE65100)
                          : Colors.grey.shade200,
                  iconColor: isPressed ? Colors.white : Colors.grey,
                  shadow: isPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildOption(String imgPath, bool isCorrect) {
    final faded = wrongSelections.contains(imgPath);

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(imgPath, isCorrect),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: faded ? 0.25 : 1.0,
          child: AnimatedBuilder(
            animation: _glowAnim,
            builder: (_, child) {
              final glowing = isCorrect && !showSuccess;
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (glowing && _glowCtrl.isAnimating)
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(
                              0.5 * _glowAnim.value,
                            ),
                            blurRadius: 40 * _glowAnim.value,
                            spreadRadius: 12 * _glowAnim.value,
                          ),
                        ],
                      ),
                    ),
                  child!,
                ],
              );
            },
            child: Image.asset(
              imgPath,
              height: isCorrect ? 280 : 160,
              fit: BoxFit.contain,
              errorBuilder:
                  (_, __, ___) =>
                      const Icon(Icons.eco, size: 100, color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }
Widget _buildSuccess(Numbermodel veg) {
    return Stack(
      children: [
        Positioned.fill(
          child: Lottie.asset('assets/lottie/CONFETTI.json', fit: BoxFit.cover),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder:
                    (_, v, child) => Transform.scale(scale: v, child: child),
                child: Image.asset(veg.image, height: 260, fit: BoxFit.contain),
              ),
              const SizedBox(height: 30),
              Text(
                veg.text,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                  fontFamily: 'arlrdbd',
                ),
              ),
              Text(
                veg.textAr,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black45,
                  fontFamily: 'arlrdbd',
                ),
              ),
              const SizedBox(height: 40),
              if (_page + 1 < vegitablesongs2.length)
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE65100).withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'التالي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'arlrdbd',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color iconColor;
  final bool shadow;

  const _CircleBtn({
    required this.icon,
    this.onTap,
    required this.bg,
    required this.iconColor,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow:
              shadow
                  ? [
                    BoxShadow(
                      color: iconColor.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
