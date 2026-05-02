import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'Family_model.dart';

class FamilySongScreen extends StatefulWidget {
  const FamilySongScreen({super.key});

  @override
  State<FamilySongScreen> createState() => _FamilySongScreenState();
}

class _FamilySongScreenState extends State<FamilySongScreen> {
  final FlutterTts _tts = FlutterTts();
  final PageController _ctrl = PageController();

  bool _isPressed = false;
  int _score = 0;

  final List<FamilyModel> _list = familyList().skip(1).toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speak(_list[0].ttsText);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.1);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD7A96B)),
        centerTitle: true,
        title: const Text(
          'Listen & Guess  🎵',
          style: TextStyle(
            color: Color(0xFFD7A96B),
            fontFamily: 'arlrdbd',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _ctrl,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (_) => setState(() => _isPressed = false),
        itemCount: familySongQuestions.length,
        itemBuilder: (ctx, index) {
          final q = familySongQuestions[index];
          final member = _list[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD7A96B).withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFD7A96B).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // زر الصوت
                      GestureDetector(
                        onTap: () => _speak(member.ttsText),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFD7A96B), Color(0xFFE8C07A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.nameEn,
                            style: const TextStyle(
                              fontSize: 28,
                              fontFamily: 'arlrdbd',
                              color: Color(0xFFD7A96B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            member.nameAr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'arlrdbd',
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Grid الصور ──────────────────────────────
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                    itemCount: q.answer.length,
                    itemBuilder: (_, i) {
                      final imgPath = q.answer.keys.elementAt(i);
                      final isCorrect = q.answer.values.elementAt(i);
                      return _buildOption(imgPath, isCorrect, ctx);
                    },
                  ),
                ),

                // ── أزرار التنقل ────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavBtn(
                        icon: Icons.arrow_back_rounded,
                        enabled: index > 0,
                        onTap:
                            () => _ctrl.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                      ),
                      // score
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFD7A96B),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_score',
                              style: const TextStyle(
                                fontFamily: 'arlrdbd',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFD7A96B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildNavBtn(
                        icon: Icons.arrow_forward_rounded,
                        enabled:
                            _isPressed &&
                            index < familySongQuestions.length - 1,
                        onTap: () {
                          _ctrl.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          _speak(_list[index + 1].ttsText);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption(String imgPath, bool isCorrect, BuildContext ctx) {
    Color borderColor = Colors.grey.withOpacity(0.2);
    Color bgColor = Colors.white;

    if (_isPressed) {
      borderColor = isCorrect ? Colors.green : Colors.red;
      bgColor =
          isCorrect
              ? Colors.green.withOpacity(0.08)
              : Colors.red.withOpacity(0.05);
    }

    return GestureDetector(
      onTap:
          _isPressed
              ? null
              : () {
                setState(() {
                  _isPressed = true;
                  if (isCorrect) _score++;
                });
                if (isCorrect) {
                  MotionToast.success(
                    description: const Text(
                      'ممتاز يا بطل! 🎉',
                      style: TextStyle(fontFamily: 'arlrdbd'),
                    ),
                  ).show(ctx);
                } else {
                  MotionToast.error(
                    description: const Text(
                      'حاول مرة أخرى! 💪',
                      style: TextStyle(fontFamily: 'arlrdbd'),
                    ),
                  ).show(ctx);
                }
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color:
                  (_isPressed && isCorrect)
                      ? Colors.green.withOpacity(0.2)
                      : Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                imgPath,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
            ),
            if (_isPressed)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 26,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBtn({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.35,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFD7A96B) : Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow:
                enabled
                    ? [
                      BoxShadow(
                        color: const Color(0xFFD7A96B).withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.grey,
            size: 26,
          ),
        ),
      ),
    );
  }
}
