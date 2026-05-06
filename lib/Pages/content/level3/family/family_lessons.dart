import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'Family_model.dart';

class FamilySoundScreen extends StatefulWidget {
  final int index;
  const FamilySoundScreen(this.index, {super.key});

  @override
  State<FamilySoundScreen> createState() => _FamilySoundScreenState();
}

class _FamilySoundScreenState extends State<FamilySoundScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late int _index;
  bool _isSpeaking = false;
  late AnimationController _pulseCtrl;

  // تم تعديل الثيمات هنا لتطابق الترتيب الجديد (بدءاً من الجد)
  static const _themes = [
    _MemberTheme(
      gradient: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
      bgTop: Color(0xFFEDE7F6),
      bgBottom: Color(0xFFF3E5F5),
      bgEmoji: ['⭐', '🌙', '💙'],
      label: 'Grandfather',
    ),
    _MemberTheme(
      gradient: [Color(0xFFE91E63), Color(0xFFF06292)],
      bgTop: Color(0xFFFCE4EC),
      bgBottom: Color(0xFFFFF0F5),
      bgEmoji: ['🌸', '💕', '🌺'],
      label: 'Grandmother',
    ),
    _MemberTheme(
      gradient: [Color(0xFF1565C0), Color(0xFF1E88E5)],
      bgTop: Color(0xFFE3F2FD),
      bgBottom: Color(0xFFEEF6FF),
      bgEmoji: ['⚡', '🌊', '💎'],
      label: 'Father',
    ),
    _MemberTheme(
      gradient: [Color(0xFFAD1457), Color(0xFFE91E63)],
      bgTop: Color(0xFFFCE4EC),
      bgBottom: Color(0xFFFFF3E0),
      bgEmoji: ['🌹', '💝', '🌷'],
      label: 'Mother',
    ),
    _MemberTheme(
      gradient: [Color(0xFF2E7D32), Color(0xFF43A047)],
      bgTop: Color(0xFFE8F5E9),
      bgBottom: Color(0xFFF1F8E9),
      bgEmoji: ['⚽', '🌿', '🎮'],
      label: 'Brother',
    ),
    _MemberTheme(
      gradient: [Color(0xFFFF8F00), Color(0xFFFFB300)],
      bgTop: Color(0xFFFFF8E1),
      bgBottom: Color(0xFFFFF3E0),
      bgEmoji: ['🦄', '🌟', '🎀'],
      label: 'Sister',
    ),
  ];

  _MemberTheme get _theme => _themes[_index % _themes.length];

  final List<FamilyModel> _list = familyList();

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _speak();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    if (_isSpeaking) return;
    if (_index >= _list.length) return;

    setState(() => _isSpeaking = true);
    HapticFeedback.mediumImpact();
    _pulseCtrl.repeat(reverse: true);

    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.2);
    await _tts.speak(_list[_index].ttsText);

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSpeaking = false);
      _pulseCtrl.stop();
      _pulseCtrl.reset();
    }
  }

  void _next() {
    if (_index < _list.length - 1) {
      setState(() => _index++);
      _speak();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() => _index--);
      _speak();
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = _index < _list.length ? _list[_index] : _list.last;
    final theme = _theme;
    final grad = theme.gradient;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: 600.ms,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.bgTop, theme.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBgBlobs(grad, size),
              ..._buildFloatingEmojis(theme.bgEmoji, size),
              Column(
                children: [
                  _buildAppBar(grad),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 8,
                      ),
                      child: AnimatedSwitcher(
                        duration: 500.ms,
                        transitionBuilder:
                            (child, anim) => FadeTransition(
                              opacity: anim,
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                        child: _buildImageCard(
                          member,
                          grad,
                          key: ValueKey(_index),
                        ),
                      ),
                    ),
                  ),
                  _buildNameBadge(member, grad),
                  const SizedBox(height: 20),
                  _buildSpeakButton(grad),
                  const SizedBox(height: 20),
                  _buildNavRow(grad),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBgBlobs(List<Color> grad, Size size) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: grad[0].withOpacity(0.10),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: -60,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: grad[1].withOpacity(0.10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(List<Color> grad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            grad: null,
            isSmall: true,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: ShapeDecoration(
              gradient: LinearGradient(colors: grad),
              shape: const StadiumBorder(),
              shadows: [
                BoxShadow(
                  color: grad[0].withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              _theme.label,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'arlrdbd',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: grad[0].withOpacity(0.15), blurRadius: 8),
              ],
            ),
            child: Text(
              '${_index + 1}/${_list.length}',
              style: TextStyle(
                color: grad[0],
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(FamilyModel member, List<Color> grad, {Key? key}) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.85),
            Colors.white.withOpacity(0.60),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: grad[0].withOpacity(0.18),
            blurRadius: 35,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: grad[0].withOpacity(0.15), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
                  member.image,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => Icon(
                        Icons.face_retouching_natural,
                        size: 120,
                        color: grad[0],
                      ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: -12,
                  duration: 2.seconds,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameBadge(FamilyModel member, List<Color> grad) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: grad[0].withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            member.nameEn,
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'arlrdbd',
              color: grad[0],
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              width: 2.5,
              height: 28,
              color: grad[0].withOpacity(0.2),
            ),
          ),
          Text(
            member.nameAr,
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'arlrdbd',
              color: grad[1],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.15, end: 0, duration: 400.ms).fadeIn();
  }

  Widget _buildSpeakButton(List<Color> grad) {
    return ScaleTransition(
      scale: Tween(
        begin: 1.0,
        end: 1.18,
      ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.elasticOut)),
      child: GestureDetector(
        onTap: _speak,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: grad),
            boxShadow: [
              BoxShadow(
                color: grad[0].withOpacity(0.45),
                blurRadius: 22,
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
    );
  }

  Widget _buildNavRow(List<Color> grad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavBtn(
            icon: Icons.arrow_back_ios_rounded,
            onTap: _index == 0 ? null : _prev,
            grad: grad,
          ),
          Row(
            children: List.generate(_list.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: 300.ms,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 26 : 9,
                height: 9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: active ? grad[0] : grad[0].withOpacity(0.22),
                ),
              );
            }),
          ),
          _NavBtn(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: _index == _list.length - 1 ? null : _next,
            grad: grad,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingEmojis(List<String> emojis, Size size) {
    final positions = [
      const Offset(0.08, 0.22),
      const Offset(0.85, 0.16),
      const Offset(0.90, 0.62),
    ];
    return List.generate(emojis.length, (i) {
      return Positioned(
        left: positions[i % positions.length].dx * size.width,
        top: positions[i % positions.length].dy * size.height,
        child: Text(emojis[i], style: const TextStyle(fontSize: 26))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -14, duration: (1200 + i * 400).ms)
            .fadeIn(delay: (150 * i).ms),
      );
    });
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final List<Color>? grad;
  final bool isSmall;

  const _NavBtn({
    required this.icon,
    this.onTap,
    this.grad,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.lightImpact();
          onTap!();
        }
      },
      child: AnimatedOpacity(
        duration: 250.ms,
        opacity: onTap == null ? 0.28 : 1.0,
        child: Container(
          padding: EdgeInsets.all(isSmall ? 10 : 14),
          decoration: BoxDecoration(
            color:
                onTap == null
                    ? Colors.grey.shade200
                    : (grad == null ? Colors.white : null),
            gradient:
                onTap != null && grad != null
                    ? LinearGradient(colors: grad!)
                    : null,
            shape: BoxShape.circle,
            boxShadow:
                onTap != null
                    ? [
                      BoxShadow(
                        color: (grad?.first ?? Colors.black).withOpacity(0.22),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                    : [],
          ),
          child: Icon(
            icon,
            color:
                onTap == null
                    ? Colors.grey
                    : (grad == null ? Colors.black87 : Colors.white),
            size: isSmall ? 20 : 24,
          ),
        ),
      ),
    );
  }
}

class _MemberTheme {
  final List<Color> gradient;
  final Color bgTop;
  final Color bgBottom;
  final List<String> bgEmoji;
  final String label;

  const _MemberTheme({
    required this.gradient,
    required this.bgTop,
    required this.bgBottom,
    required this.bgEmoji,
    required this.label,
  });
}
