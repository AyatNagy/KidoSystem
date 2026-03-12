import 'package:flutter/material.dart';
import 'package:kido/Pages/content/MatchTheSame/game_screen.dart';

const _imgs = [
  'assets/images/image_1.png',
  'assets/images/image_2.png',
  'assets/images/image_3.png',
  'assets/images/image_4.png',
  'assets/images/image_5.png',
  'assets/images/image_6.png',
];

const _cover = 'assets/images/image_cover.jpg';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': '👀 تذكر الصور!',
      'desc': 'في البداية هتشوف كل الصور لمدة 3 ثواني.. ركّز كويس!',
      'type': 'show_all',
    },
    {
      'title': '🃏 اقلب الكارت',
      'desc': 'بعد ما الصور تتقلب، اضغط على أي كارت عشان تشوف الصورة جوّاه',
      'type': 'flip_one',
    },
    {
      'title': '🔍 لاقي التوأم',
      'desc':
          'لو الصورتين زي بعض.. مبروك اتطابقوا! ✅\nلو مختلفين هيترجعوا يتقلبوا تاني',
      'type': 'match',
    },
    {
      'title': '🏆 اكمل اللعبة!',
      'desc': 'طابق كل الكروت في أقل وقت ممكن وسجّل أحسن نتيجة!',
      'type': 'win',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final isLast = _currentStep == _steps.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('كيف تلعب؟'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // ── Step Indicators ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentStep ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color:
                          i == _currentStep
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Animation Area ──
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildStepWidget(
                    step['type'],
                    key: ValueKey(_currentStep),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Title ──
              Text(
                step['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // ── Description ──
              Text(
                step['desc'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // ── Buttons ──
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('السابق'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isLast) {
                          setState(() => _currentStep++);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyFlipCardGame(),
                            ),
                          );
                        }
                      },
                      child: Text(isLast ? '🎮 ابدأ اللعب!' : 'التالي →'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepWidget(String type, {Key? key}) {
    switch (type) {
      case 'show_all':
        return _ShowAllCards(key: key);
      case 'flip_one':
        return _FlipOneCard(key: key);
      case 'match':
        return _MatchCards(key: key);
      case 'win':
        return _WinCards(key: key);
      default:
        return const SizedBox(key: Key('empty'));
    }
  }
}

// Step 1
class _ShowAllCards extends StatefulWidget {
  const _ShowAllCards({super.key});
  @override
  State<_ShowAllCards> createState() => _ShowAllCardsState();
}

class _ShowAllCardsState extends State<_ShowAllCards> {
  bool _revealed = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _revealed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = [_imgs[0], _imgs[1], _imgs[0], _imgs[1]];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      children: List.generate(cards.length, (i) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder:
              (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
          child:
              _revealed
                  ? _GameCardFront(
                    imagePath: cards[i],
                    key: ValueKey('front_$i'),
                  )
                  : _GameCardBack(key: ValueKey('back_$i')),
        );
      }),
    );
  }
}

// Step 2
class _FlipOneCard extends StatefulWidget {
  const _FlipOneCard({super.key});
  @override
  State<_FlipOneCard> createState() => _FlipOneCardState();
}

class _FlipOneCardState extends State<_FlipOneCard> {
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  void _animate() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _flipped = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _flipped = false);
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 140,
        height: 140,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            final rotate = Tween(begin: 1.0, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder:
                  (context, child) => Transform(
                    transform: Matrix4.rotationY(rotate.value * 3.14),
                    alignment: Alignment.center,
                    child: child,
                  ),
            );
          },
          child:
              _flipped
                  ? _GameCardFront(
                    imagePath: _imgs[2],
                    key: const ValueKey('flipped'),
                  )
                  : _GameCardBack(key: const ValueKey('hidden')),
        ),
      ),
    );
  }
}

// Step 3
class _MatchCards extends StatefulWidget {
  const _MatchCards({super.key});
  @override
  State<_MatchCards> createState() => _MatchCardsState();
}

class _MatchCardsState extends State<_MatchCards> {
  int _phase = 0;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  void _animate() async {
    while (mounted) {
      if (mounted) setState(() => _phase = 0);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _phase = 1);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _phase = 2);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FullAnimatedCard(
            imagePath: _imgs[3],
            isFlipped: _phase >= 1,
            isMatched: _phase == 2,
          ),
          const SizedBox(width: 20),
          _FullAnimatedCard(
            imagePath: _imgs[3],
            isFlipped: _phase >= 2,
            isMatched: _phase == 2,
          ),
        ],
      ),
    );
  }
}

// Step 4:
class _WinCards extends StatefulWidget {
  const _WinCards({super.key});
  @override
  State<_WinCards> createState() => _WinCardsState();
}

class _WinCardsState extends State<_WinCards> {
  bool _matched = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _matched = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = [_imgs[0], _imgs[1], _imgs[2], _imgs[0], _imgs[1], _imgs[2]];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: List.generate(cards.length, (i) {
        return AnimatedScale(
          scale: _matched ? 1.0 : 0.5,
          duration: Duration(milliseconds: 300 + i * 80),
          curve: Curves.elasticOut,
          child: _FullAnimatedCard(
            imagePath: cards[i],
            isFlipped: true,
            isMatched: _matched,
          ),
        );
      }),
    );
  }
}

class _GameCardFront extends StatelessWidget {
  final String imagePath;
  const _GameCardFront({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
    );
  }
}

class _GameCardBack extends StatelessWidget {
  const _GameCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(
          image: AssetImage(_cover),
          fit: BoxFit.cover,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
    );
  }
}

class _FullAnimatedCard extends StatelessWidget {
  final String imagePath;
  final bool isFlipped;
  final bool isMatched;

  const _FullAnimatedCard({
    required this.imagePath,
    required this.isFlipped,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow:
            isMatched
                ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.6),
                    blurRadius: 18,
                    spreadRadius: 3,
                  ),
                ]
                : [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child:
            isFlipped
                ? _GameCardFront(
                  imagePath: imagePath,
                  key: ValueKey('front_$imagePath'),
                )
                : _GameCardBack(key: const ValueKey('back')),
      ),
    );
  }
}
