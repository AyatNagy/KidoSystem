// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/l10n/l10n_extension.dart';
import '../../config/progress.dart';
import '../../services/child_session_service.dart';
import '../../constants.dart';
import '../content/level1/level1_home.dart';
import '../content/level2/level2home.dart';
import '../content/level3/level3_home.dart';

class ChildLevelSelectResult {
  final int level;
  ChildLevelSelectResult(this.level);
}

class ChildLevelSelectPage extends StatefulWidget {
  final String childName;
  final int childId;
  final int? recommendedLevel;
  final bool isRestrictedToLevel1;
  final int? forcedUnlockedLevel;

  const ChildLevelSelectPage({
    super.key,
    required this.childName,
    required this.childId,
    this.recommendedLevel,
    this.isRestrictedToLevel1 = false,
    this.forcedUnlockedLevel,
  });

  @override
  State<ChildLevelSelectPage> createState() => _ChildLevelSelectPageState();
}

class _ChildLevelSelectPageState extends State<ChildLevelSelectPage>
    with TickerProviderStateMixin {
  int? _selectedLevel;
  int _unlockedLevel = 1;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    if (widget.childId > 0) {
      ChildSessionService.ensureLoggedIn(widget.childId);
    }
    _loadProgress();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    if (widget.isRestrictedToLevel1) {
      setState(() {
        _unlockedLevel = 1;
        _selectedLevel = 1;
      });
      return;
    }

    if (widget.forcedUnlockedLevel != null) {
      setState(() {
        _unlockedLevel = widget.forcedUnlockedLevel!;
        _selectedLevel = widget.recommendedLevel ?? 1;
      });
    } else {
      int level = await ProgressManager.getUnlockedLevel();
      setState(() {
        _unlockedLevel = level;
        _selectedLevel = widget.recommendedLevel ?? 1;
      });
    }
  }

  Future<void> _launchLevel(int level) async {
    Widget targetPage;
    switch (level) {
      case 1:
        targetPage = Level1Home(
          childName: widget.childName,
          childId: widget.childId,
        );
        break;
      case 2:
        targetPage = Level2Home(
          childName: widget.childName,
          childId: widget.childId,
        );
        break;
      case 3:
        targetPage = Level3Home(
          childName: widget.childName,
          childId: widget.childId,
        );
        break;
      default:
        return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );

    if (result is int && result == -1) {
      setState(() {
        _selectedLevel = 1;
      });
      _launchLevel(1);
    } else if (result is int && result > 0) {
      _loadProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFFFF9C4)],
          ),
        ),
        child: Stack(
          children: [
            _buildDecor(
              Alignment.topLeft,
              Icons.cloud,
              Colors.white.withOpacity(0.8),
              60,
            ),
            _buildDecor(
              Alignment.topRight,
              Icons.wb_sunny,
              Colors.orangeAccent.withOpacity(0.4),
              80,
            ),
            _buildDecor(
              Alignment.bottomLeft,
              Icons.star,
              Colors.yellow.withOpacity(0.5),
              40,
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            _buildLevelNode(
                              config,
                              level: 1,
                              color: AppColors.kidoBlue,
                              imageWidget: Image.asset(
                                'assets/images/level1.jpeg',
                              ),
                              alignment: Alignment.centerLeft,
                              icon: Icons.directions_car_filled,
                            ),
                            _buildPath(config, isRight: true),
                            _buildLevelNode(
                              config,
                              level: 2,
                              color: AppColors.kidoOrange,
                              imageWidget: Image.asset(
                                'assets/images/level2.jpeg',
                              ),
                              alignment: Alignment.centerRight,
                              icon: Icons.auto_awesome,
                            ),
                            _buildPath(config, isRight: false),
                            _buildLevelNode(
                              config,
                              level: 3,
                              color: AppColors.kidoPink,
                              imageWidget: Image.asset(
                                'assets/images/level3.jpeg',
                              ),
                              alignment: Alignment.centerLeft,
                              icon: Icons.wine_bar_sharp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomBar(config),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelNode(
    dynamic config, {
    required int level,
    required Color color,
    required IconData icon,
    required Widget imageWidget,
    required Alignment alignment,
  }) {
    final bool isLocked = level > _unlockedLevel;
    final bool isSelected = _selectedLevel == level;

    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, isSelected ? _floatingController.value * -10 : 0),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Align(
          alignment: alignment,
          child: GestureDetector(
            onTap:
                isLocked ? null : () => setState(() => _selectedLevel = level),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color:
                            isLocked
                                ? Colors.grey[300]
                                : (isSelected ? color : Colors.white),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                isLocked
                                    ? Colors.transparent
                                    : color.withOpacity(0.4),
                            blurRadius: isSelected ? 20 : 10,
                            spreadRadius: isSelected ? 5 : 0,
                          ),
                        ],
                        border: Border.all(
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isLocked ? Colors.grey[400]! : color),
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child:
                            isLocked
                                ? Icon(
                                  Icons.lock,
                                  size: 45,
                                  color: Colors.grey[600],
                                )
                                : imageWidget,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPath(dynamic config, {required bool isRight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomPaint(
        size: const Size(200, 60),
        painter: PathPainter(isRight: isRight),
      ),
    );
  }

  Widget _buildBottomBar(dynamic config) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              _selectedLevel == null
                  ? null
                  : () => _launchLevel(_selectedLevel!),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F2A44),
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
          ),
          child: Text(
            context.l10n.letsGo,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecor(Alignment align, IconData icon, Color color, double size) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final bool isRight;
  PathPainter({required this.isRight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueGrey.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isRight) {
      path.moveTo(size.width * 0.2, 0);
      path.quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.5,
        size.width * 0.8,
        size.height,
      );
    } else {
      path.moveTo(size.width * 0.8, 0);
      path.quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.2,
        size.height,
      );
    }
    for (var i = 0; i < 10; i++) {
      canvas.drawPath(path, paint);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
