// ignore_for_file: deprecated_member_use
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kido/Pages/kid/child_level_select_page.dart';
import 'package:kido/Widgets/Buttons/custom_app_button.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/progress.dart';
import 'package:kido/constants.dart';

class ChildLevelWelcomePage extends StatefulWidget {
  final String childName;
  final int allowedLevel;

  const ChildLevelWelcomePage({
    super.key,
    required this.childName,
    required this.allowedLevel,
  });

  @override
  State<ChildLevelWelcomePage> createState() => _ChildLevelWelcomePageState();
}

class _ChildLevelWelcomePageState extends State<ChildLevelWelcomePage>
    with SingleTickerProviderStateMixin {
  late final int _level;
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _level = widget.allowedLevel.clamp(1, 3);
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ProgressManager.unlockUpTo(_level);
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  List<Color> get _bgColors {
    switch (_level) {
      case 2:
        return [
          const Color(0xFFFFF8F0),
          const Color(0xFFFFE8D6),
          const Color(0xFFFFF3E0),
        ];
      case 3:
        return [
          const Color(0xFFFDF5FA),
          const Color(0xFFFCE4EC),
          const Color(0xFFFFF9E6),
        ];
      default:
        return [
          const Color(0xFFE8F8FB),
          const Color(0xFFD6F5F0),
          const Color(0xFFFFF9D6),
        ];
    }
  }

  List<Color> get _ctaGradient {
    switch (_level) {
      case 2:
        return [
          const Color(0xFFFFB74D),
          AppColors.kidoOrange,
          const Color(0xFFFF8A65),
        ];
      case 3:
        return [
          AppColors.kidoPink,
          const Color(0xFFEC407A),
          const Color(0xFFAB47BC),
        ];
      default:
        return [
          const Color(0xFF26C6DA),
          AppColors.kidoBlue,
          const Color(0xFF42A5F5),
        ];
    }
  }

  String get _levelTitleAr {
    switch (_level) {
      case 2:
        return 'المرحلة المتوسطة — Growth Grove';
      case 3:
        return 'المرحلة المتقدمة — Hero Heights';
      default:
        return 'البداية الممتعة — Beginner Bay';
    }
  }

  Color get _accent {
    switch (_level) {
      case 2:
        return AppColors.kidoOrange;
      case 3:
        return AppColors.kidoPink;
      default:
        return AppColors.kidoBlue;
    }
  }

  IconData get _levelIcon {
    switch (_level) {
      case 2:
        return Icons.auto_awesome_rounded;
      case 3:
        return Icons.emoji_events_rounded;
      default:
        return Icons.rocket_launch_rounded;
    }
  }

  List<String> get _contentLinesAr {
    switch (_level) {
      case 2:
        return [
          'ألوان وأشكال وأحجام أكثر تنوعًا',
          'قصص وبسيط من الألغاز والرسم',
          'تعزيز التركيز والملاحظة',
        ];
      case 3:
        return [
          'حروف وأرقام ومفردات جديدة',
          'عائلة، حيوانات، وفواكه وخضروات',
          'أنشطة أصعب قليلًا لتجهيزك للقراءة والعد',
        ];
      default:
        return [
          'تعرّف على الأصوات والحواس والألوان',
          'أشكال بسيطة ولعب وتنظيف وترتيب',
          'خطوات أولى ممتعة قبل الدخول للمستوى الثاني',
        ];
    }
  }

  void _goToLevelMap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChildLevelSelectPage(
              childName: widget.childName,
              recommendedLevel: _level,
              forcedUnlockedLevel: _level,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _bgColors,
              ),
            ),
          ),
          _Blob(
            top: -config.localHeight * 0.06,
            right: -config.localWidth * 0.12,
            size: config.localWidth * 0.55,
            color: _accent.withOpacity(0.14),
          ),
          _Blob(
            bottom: config.localHeight * 0.25,
            left: -config.localWidth * 0.18,
            size: config.localWidth * 0.45,
            color: AppColors.kidoGreen.withOpacity(0.1),
          ),
          _Blob(
            bottom: -config.localHeight * 0.02,
            right: config.localWidth * 0.05,
            size: config.localWidth * 0.35,
            color: Colors.white.withOpacity(0.45),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    config.pagePadding.horizontal / 2,
                    config.localHeight * 0.012,
                    config.pagePadding.horizontal / 2,
                    config.localHeight * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: _accent, size: 18),
                          SizedBox(width: config.localWidth * 0.02),
                          Text(
                            'مغامرتك تبدأ هنا',
                            style: TextStyle(
                              fontSize: config.body * 0.92,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGray,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: config.localWidth * 0.02),
                          Icon(Icons.auto_awesome, color: _accent, size: 18),
                        ],
                      ),
                      SizedBox(height: config.localHeight * 0.022),
                      Center(child: _HeroOrb(config: config, accent: _accent, icon: _levelIcon)),
                      SizedBox(height: config.localHeight * 0.022),
                      Text(
                        'أهلًا، ${widget.childName}!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: config.headline * 0.92,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F2A44),
                          height: 1.15,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.9),
                              blurRadius: 12,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: config.localHeight * 0.018),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: config.localWidth * 0.06,
                                vertical: config.localHeight * 0.016,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white.withOpacity(0.85)),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.72),
                                    Colors.white.withOpacity(0.52),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: config.localWidth * 0.04,
                                      vertical: config.localHeight * 0.006,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _accent,
                                          _accent.withOpacity(0.75),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _accent.withOpacity(0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'المستوى $_level',
                                      style: TextStyle(
                                        fontSize: config.body * 0.95,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: config.localHeight * 0.012),
                                  Text(
                                    _levelTitleAr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: config.body * 0.96,
                                      color: const Color(0xFF3D4F5F),
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: config.localHeight * 0.028),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: config.title * 1.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [_accent, _accent.withOpacity(0.45)],
                              ),
                            ),
                          ),
                          SizedBox(width: config.localWidth * 0.03),
                          Expanded(
                            child: Text(
                              'ماذا ستتعلّم؟',
                              style: TextStyle(
                                fontSize: config.title,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1F2A44),
                              ),
                            ),
                          ),
                          Icon(Icons.menu_book_rounded, color: _accent, size: config.headline * 0.55),
                        ],
                      ),
                      SizedBox(height: config.localHeight * 0.014),
                      ...List.generate(_contentLinesAr.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: config.localHeight * 0.012),
                          child: _LearningTile(
                            index: i + 1,
                            text: _contentLinesAr[i],
                            accent: _accent,
                            config: config,
                          ),
                        );
                      }),
                      SizedBox(height: config.localHeight * 0.016),
                      CustomGradientButton(
                        title: 'يلّا نبدأ التعلّم!',
                        onPressed: _goToLevelMap,
                        width: double.infinity,
                        borderRadius: 28,
                        fontSize: config.title * 0.95,
                        colors: _ctaGradient,
                      ),
                      SizedBox(height: config.localHeight * 0.012),
                      Text(
                        'ستنتقل إلى خريطة المراحل لتختار نشاطك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: config.body * 0.82,
                          color: AppColors.textGray,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;

  const _Blob({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  final dynamic config;
  final Color accent;
  final IconData icon;

  const _HeroOrb({
    required this.config,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double outer = config.localWidth * 0.42;
    return Container(
      width: outer,
      height: outer,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: Alignment.center,
          startAngle: 0,
          endAngle: 6.28,
          colors: [
            accent,
            accent.withOpacity(0.55),
            Colors.white.withOpacity(0.85),
            accent.withOpacity(0.65),
            accent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.45),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Icon(icon, size: outer * 0.42, color: accent),
      ),
    );
  }
}

class _LearningTile extends StatelessWidget {
  final int index;
  final String text;
  final Color accent;
  final dynamic config;

  const _LearningTile({
    required this.index,
    required this.text,
    required this.accent,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: config.localWidth * 0.04,
          vertical: config.localHeight * 0.016,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.88),
          border: Border.all(color: Colors.white.withOpacity(0.95)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.95), accent.withOpacity(0.65)],
                ),
              ),
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(width: config.localWidth * 0.035),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: config.body,
                  height: 1.48,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3142),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
