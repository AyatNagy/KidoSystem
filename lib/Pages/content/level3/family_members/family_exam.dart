// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class FamilyMember {
  final String name;
  final String nameAr;
  final String image;
  final String sound;

  FamilyMember({
    required this.name,
    required this.nameAr,
    required this.image,
    required this.sound,
  });
}

class FamilyQuestion {
  final Map<String, bool> answers;

  FamilyQuestion({required this.answers});
}

final List<FamilyMember> familyMembers = [
  FamilyMember(
    name: 'Father',
    nameAr: 'الأب',
    image: 'assets/images/family_members/father-removebg-preview.png',
    sound: 'assets/audio/family/father.mp3',
  ),
  FamilyMember(
    name: 'Mother',
    nameAr: 'الأم',
    image: 'assets/images/family_members/mother-removebg-preview.png',
    sound: 'assets/audio/family/mother.mp3',
  ),
  FamilyMember(
    name: 'Brother',
    nameAr: 'الأخ',
    image: 'assets/images/family_members/brother-removebg-preview.png',
    sound: 'assets/audio/family/brother_1.mp3',
  ),
  FamilyMember(
    name: 'Sister',
    nameAr: 'الأخت',
    image: 'assets/images/family_members/sister-removebg-preview.png',
    sound: 'assets/audio/family/sister_1.mp3',
  ),
  FamilyMember(
    name: 'GrandFather',
    nameAr: 'الجد',
    image: 'assets/images/family_members/grandfather-removebg-preview.png',
    sound: 'assets/audio/family/grandfather_1.mp3',
  ),
  FamilyMember(
    name: 'GrandMother',
    nameAr: 'الجدة',
    image: 'assets/images/family_members/grandmother-removebg-preview.png',
    sound: 'assets/audio/family/grandmother_1.mp3',
  ),
];
final List<FamilyQuestion> familyQuestions = [
  FamilyQuestion(
    answers: {
      'assets/images/family_members/father-removebg-preview.png': true,
      'assets/images/family_members/mother-removebg-preview.png': false,
    },
  ),
  FamilyQuestion(
    answers: {
      'assets/images/family_members/mother-removebg-preview.png': true,
      'assets/images/family_members/father-removebg-preview.png': false,
    },
  ),
  FamilyQuestion(
    answers: {
      'assets/images/family_members/brother-removebg-preview.png': true,
      'assets/images/family_members/sister-removebg-preview.png': false,
    },
  ),

  FamilyQuestion(
    answers: {
      'assets/images/family_members/sister-removebg-preview.png': true,
      'assets/images/family_members/brother-removebg-preview.png': false,
    },
  ),
];

class FamilyExam extends StatefulWidget {
  const FamilyExam({super.key});

  @override
  State<FamilyExam> createState() => _FamilyExamState();
}

class _FamilyExamState extends State<FamilyExam>
    with SingleTickerProviderStateMixin {
  //final FlutterTts flutterTts = FlutterTts();
  final PageController _pageCtrl = PageController();

  int _page = 0;
  bool isPressed = false;
  bool showSuccess = false;
  bool isLocked = false;
  List<String> wrongSelections = [];
  Timer? _hintTimer;

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _glowAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _startPage(0);
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _glowCtrl.dispose();
    //flutterTts.stop();
    _pageCtrl.dispose();
    super.dispose();
  }

  /*Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.1);
    await flutterTts.speak(text);
  }*/

  void _startPage(int page) {
    _hintTimer?.cancel();
    showSuccess = false;
    isPressed = false;
    isLocked = false;
    wrongSelections = [];

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) //_speak(familyMembers[page].name);
        return;
    });

    _hintTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!isPressed && mounted) //_speak(familyMembers[page].name);
        return;
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
      //await _speak(familyMembers[_page].name);
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
    if (_page + 1 < familyQuestions.length) {
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
        itemCount: familyQuestions.length,
        itemBuilder: (ctx, pageIndex) {
          final q = familyQuestions[pageIndex];
          final member = familyMembers[pageIndex];

          return showSuccess
              ? _buildSuccess(member)
              : _buildQuestion(ctx, q, member);
        },
      ),
    );
  }

  Widget _buildQuestion(
    BuildContext ctx,
    FamilyQuestion q,
    FamilyMember member,
  ) {
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
                      member.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                        fontFamily: 'arlrdbd',
                      ),
                    ),
                    Text(
                      member.nameAr,
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
                  //onTap: () => _speak(member.name),
                  bg: const Color(0xFF4CAF50),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  q.answers.entries.map((e) {
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
                  iconColor: _page == 0 ? Colors.grey : const Color(0xFF4CAF50),
                  shadow: _page != 0,
                ),
                _CircleBtn(
                  icon: Icons.arrow_forward_ios_rounded,
                  onTap: isPressed ? _nextPage : null,
                  bg:
                      isPressed
                          ? const Color(0xFF4CAF50)
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
                            color: Colors.green.withOpacity(
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
                      const Icon(Icons.person, size: 100, color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(FamilyMember member) {
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
                child: Image.asset(
                  member.image,
                  height: 260,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                member.name,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                  fontFamily: 'arlrdbd',
                ),
              ),
              Text(
                member.nameAr,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black45,
                  fontFamily: 'arlrdbd',
                ),
              ),
              const SizedBox(height: 40),
              if (_page + 1 < familyQuestions.length)
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.35),
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
                )
              else
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'انتهيت!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'arlrdbd',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.check_circle_rounded,
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
