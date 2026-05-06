import 'dart:math' as math;
import 'package:flutter/material.dart';

class FamilyMember {
  final String id;
  final String name;
  final String imagePath;
  final String label;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.label,
  });
}

const List<FamilyMember> _members = [
  FamilyMember(
    id: 'grandpa',
    name: 'Grandpa',
    imagePath: 'assets/images/familyIcons/grandpa.png',
    label: 'جد',
  ),
  FamilyMember(
    id: 'grandma',
    name: 'Grandma',
    imagePath: 'assets/images/familyIcons/grandma.png',
    label: 'جدة',
  ),
  FamilyMember(
    id: 'dad',
    name: 'Dad',
    imagePath: 'assets/images/familyIcons/dad.png',
    label: 'أب',
  ),
  FamilyMember(
    id: 'mom',
    name: 'Mom',
    imagePath: 'assets/images/familyIcons/mom.png',
    label: 'أم',
  ),
  FamilyMember(
    id: 'son',
    name: 'Son',
    imagePath: 'assets/images/familyIcons/son.png',
    label: 'ابن',
  ),
  FamilyMember(
    id: 'daughter',
    name: 'Daughter',
    imagePath: 'assets/images/familyIcons/daughter.png',
    label: 'ابنة',
  ),
];
const _slotRx = {
  'grandpa': 0.35,
  'grandma': 0.65,
  'dad': 0.20,
  'mom': 0.80,
  'son': 0.28,
  'daughter': 0.72,
};

const _slotRy = {
  'grandpa': 0.18,
  'grandma': 0.18,
  'dad': 0.38,
  'mom': 0.38,
  'son': 0.60,
  'daughter': 0.60,
};

class _HandOverlay extends StatefulWidget {
  final Offset from;
  final Offset to;
  const _HandOverlay({super.key, required this.from, required this.to});

  @override
  State<_HandOverlay> createState() => _HandOverlayState();
}

class _HandOverlayState extends State<_HandOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final t = _anim.value;
        final pos = Offset.lerp(widget.from, widget.to, t)!;
        final angle = math.atan2(
          widget.to.dy - widget.from.dy,
          widget.to.dx - widget.from.dx,
        );
        final pulse = math.sin(t * math.pi * 2) * 0.5 + 0.5;

        return Stack(
          children: [
            // حلقة نابضة عند نقطة البداية
            Positioned(
              left: widget.from.dx - 24,
              top: widget.from.dy - 24,
              child: Opacity(
                opacity: (1 - t).clamp(0.0, 1.0),
                child: Container(
                  width: 48 + pulse * 16,
                  height: 48 + pulse * 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.6),
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            ),
            // اليد
            Positioned(
              left: pos.dx - 20,
              top: pos.dy - 20,
              child: Transform.rotate(
                angle: angle - math.pi / 4,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('👆', style: TextStyle(fontSize: 26)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FamilyTreeScreen extends StatefulWidget {
  const FamilyTreeScreen({super.key});

  @override
  State<FamilyTreeScreen> createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  final Map<String, bool> _dropped = {for (final m in _members) m.id: false};

  bool get _allDone => _dropped.values.every((v) => v);
  int get _tutorialIdx => _members.indexWhere((m) => _dropped[m.id] != true);
  List<FamilyMember> get _remaining =>
      _members.where((m) => _dropped[m.id] != true).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sw = constraints.maxWidth;
          final sh = constraints.maxHeight;
          const trayH = 155.0;
          const trayBottom = 16.0;
          const headerH = 90.0;
          final treeTop = headerH;
          final treeH = sh - headerH - trayH - trayBottom - 12;
          final slotSize = sw * 0.16;

          return Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _RoomBgPainter())),
              Positioned(
                left: 0,
                right: 0,
                top: treeTop,
                height: treeH,
                child: CustomPaint(
                  painter: _TreePainter(),
                  child: const SizedBox.expand(),
                ),
              ),

              ..._members.map((member) {
                final rx = _slotRx[member.id]!;
                final ry = _slotRy[member.id]!;
                final cx = rx * sw;
                final cy = treeTop + ry * treeH;
                final placed = _dropped[member.id] == true;

                return Positioned(
                  left: cx - slotSize / 2,
                  top: cy - slotSize / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DragTarget<String>(
                        onWillAccept: (data) => data == member.id,
                        onAccept:
                            (_) => setState(() => _dropped[member.id] = true),
                        builder: (ctx, candidates, _) {
                          final hovered = candidates.isNotEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: slotSize,
                            height: slotSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  placed
                                      ? Colors.white.withOpacity(0.95)
                                      : hovered
                                      ? Colors.amber.withOpacity(0.35)
                                      : Colors.white.withOpacity(0.55),
                              border: Border.all(
                                color:
                                    placed
                                        ? const Color(0xFF66BB6A)
                                        : hovered
                                        ? Colors.amber
                                        : const Color(0xFFBCAAA4),
                                width: placed || hovered ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child:
                                placed
                                    ? ClipOval(
                                      child: Image.asset(
                                        member.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Center(
                                              child: Text(
                                                _emoji(member.id),
                                                style: TextStyle(
                                                  fontSize: slotSize * 0.5,
                                                ),
                                              ),
                                            ),
                                      ),
                                    )
                                    : hovered
                                    ? const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.amber,
                                      size: 28,
                                    )
                                    : null,
                          );
                        },
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7A96B),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          member.label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: "arlrdbd",
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              Positioned(
                bottom: trayBottom,
                left: 10,
                right: 10,
                child: Container(
                  height: trayH,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7A96B).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFD7A96B),
                      width: 2,
                    ),
                  ),
                  child:
                      _allDone
                          ? const Center(
                            child: Text(
                              '🎉 أحسنت! رتّبت العائلة كلها!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "arlrdbd",
                              ),
                            ),
                          )
                          : LayoutBuilder(
                            builder: (ctx, box) {
                              final availW = box.maxWidth - 16;
                              final chipSize = (availW / _members.length) - 6;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:
                                    _members.map((member) {
                                      if (_dropped[member.id] == true) {
                                        return SizedBox(width: chipSize);
                                      }
                                      return Draggable<String>(
                                        data: member.id,
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: _MemberChip(
                                            member: member,
                                            size: chipSize * 1.15,
                                            elevated: true,
                                          ),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.2,
                                          child: _MemberChip(
                                            member: member,
                                            size: chipSize,
                                          ),
                                        ),
                                        child: _MemberChip(
                                          member: member,
                                          size: chipSize,
                                        ),
                                      );
                                    }).toList(),
                              );
                            },
                          ),
                ),
              ),

              if (!_allDone && _tutorialIdx >= 0)
                Builder(
                  builder: (context) {
                    final member = _members[_tutorialIdx];

                    final to = Offset(
                      _slotRx[member.id]! * sw,
                      treeTop + _slotRy[member.id]! * treeH,
                    );

                    final totalSlots = _members.length;
                    final memberIdx = _members.indexWhere(
                      (m) => m.id == member.id,
                    );
                    final chipSize = sw * 0.15;
                    final trayW = sw - 20.0;
                    final totalChipsW = chipSize * totalSlots;
                    final gap = (trayW - totalChipsW) / (totalSlots + 1);
                    final chipCx =
                        10 + gap + memberIdx * (chipSize + gap) + chipSize / 2;
                    final chipCy = sh - trayBottom - trayH / 2;

                    return _HandOverlay(
                      key: ValueKey('hand_${member.id}'),
                      from: Offset(chipCx, chipCy),
                      to: to,
                    );
                  },
                ),

              // ── Header ───────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF5D4037),
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'ضع صور العائلة في الشجرة!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4E342E),
                            fontFamily: "arlrdbd",
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                blurRadius: 8,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Color(0xFF8D6E63),
                        ),
                        onPressed:
                            () => setState(() {
                              for (final k in _dropped.keys)
                                _dropped[k] = false;
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _emoji(String id) =>
      const {
        'grandpa': '👴',
        'grandma': '👵',
        'dad': '👨',
        'mom': '👩',
        'son': '👦',
        'son2': '👦',
        'daughter': '👧',
      }[id] ??
      '👤';
}

class _MemberChip extends StatelessWidget {
  final FamilyMember member;
  final double size;
  final bool elevated;
  const _MemberChip({
    required this.member,
    required this.size,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD7A96B), width: 2.5),
            boxShadow:
                elevated
                    ? [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                    : [],
          ),
          child: ClipOval(
            child: Image.asset(
              member.imagePath,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Center(
                    child: Text(
                      _emoji(member.id),
                      style: TextStyle(fontSize: size * 0.5),
                    ),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          member.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5D4037),
            fontFamily: "arlrdbd",
          ),
        ),
      ],
    );
  }

  String _emoji(String id) =>
      const {
        'grandpa': '👴',
        'grandma': '👵',
        'dad': '👨',
        'mom': '👩',
        'son': '👦',
        'son2': '👦',
        'daughter': '👧',
      }[id] ??
      '👤';
}

class _TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final trunkPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [const Color(0xFF8D6E63), const Color(0xFF5D4037)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(Rect.fromLTWH(w * 0.38, h * 0.45, w * 0.24, h * 0.55));

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.37, h)
        ..quadraticBezierTo(w * 0.35, h * 0.72, w * 0.41, h * 0.52)
        ..lineTo(w * 0.59, h * 0.52)
        ..quadraticBezierTo(w * 0.65, h * 0.72, w * 0.63, h)
        ..close(),
      trunkPaint,
    );

    final bp =
        Paint()
          ..color = const Color(0xFF795548)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(w * .43, h * .54), Offset(w * .22, h * .42), bp);
    canvas.drawLine(Offset(w * .43, h * .54), Offset(w * .14, h * .64), bp);
    canvas.drawLine(Offset(w * .57, h * .54), Offset(w * .78, h * .42), bp);
    canvas.drawLine(Offset(w * .57, h * .54), Offset(w * .86, h * .64), bp);
    canvas.drawLine(Offset(w * .50, h * .52), Offset(w * .36, h * .20), bp);
    canvas.drawLine(Offset(w * .50, h * .52), Offset(w * .64, h * .20), bp);

    void blob(double cx, double cy, double r, Color c) =>
        canvas.drawCircle(Offset(cx * w, cy * h), r * w, Paint()..color = c);

    blob(0.50, 0.10, 0.15, const Color(0xFF43A047)); // قمة
    blob(0.35, 0.18, 0.13, const Color(0xFF388E3C)); // جد
    blob(0.65, 0.18, 0.13, const Color(0xFF388E3C)); // جدة
    blob(0.50, 0.27, 0.17, const Color(0xFF66BB6A)); // وسط
    blob(0.20, 0.38, 0.13, const Color(0xFF2E7D32)); // أب
    blob(0.80, 0.38, 0.13, const Color(0xFF2E7D32)); // أم
    blob(0.28, 0.60, 0.11, const Color(0xFF81C784)); // ابن
    blob(0.72, 0.60, 0.11, const Color(0xFF81C784)); // ابنة

    // ── وجه ──────────────────────────────────────────
    final ep = Paint()..color = const Color(0xFF4E342E);
    canvas.drawCircle(Offset(w * .455, h * .615), w * .019, ep);
    canvas.drawCircle(Offset(w * .545, h * .615), w * .019, ep);
    canvas.drawCircle(Offset(w * .500, h * .642), w * .010, ep);
    canvas.drawCircle(
      Offset(w * .42, h * .643),
      w * .021,
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.75),
    );
    canvas.drawCircle(
      Offset(w * .58, h * .643),
      w * .021,
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.75),
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * .44, h * .663)
        ..quadraticBezierTo(w * .50, h * .690, w * .56, h * .663),
      Paint()
        ..color = const Color(0xFF4E342E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoomBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
    final wallPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [const Color(0xFFFFF3DC), const Color(0xFFFFE8B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), wallPaint);
    final floorPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [const Color(0xFFD4A96A), const Color(0xFFC19558)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, h * 0.82, w, h * 0.18));
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, h * 0.82, w, h * 0.18),
        topLeft: const Radius.circular(0),
        topRight: const Radius.circular(0),
      ),
      floorPaint,
    );
    canvas.drawLine(
      Offset(0, h * 0.82),
      Offset(w, h * 0.82),
      Paint()
        ..color = const Color(0xFFB8864E)
        ..strokeWidth = 2,
    );

    _drawWindow(canvas, w * 0.70, h * 0.12, w * 0.25, h * 0.20);
    _drawBookshelf(canvas, w * 0.01, h * 0.22, w * 0.15, h * 0.42);

    _drawBlocks(canvas, w * 0.03, h * 0.76);
    _drawStars(canvas, w, h);

    final rugPaint = Paint()..color = const Color(0xFFE8C97A).withOpacity(0.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.88),
        width: w * 0.55,
        height: h * 0.06,
      ),
      rugPaint,
    );
  }

  void _drawWindow(Canvas c, double x, double y, double ww, double wh) {
    final framePaint =
        Paint()
          ..color = const Color(0xFFD4A96A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    final bgPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [const Color(0xFFB8E0F7), const Color(0xFF90CAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(x, y, ww, wh));

    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, ww, wh),
        const Radius.circular(8),
      ),
      bgPaint,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, ww, wh),
        const Radius.circular(8),
      ),
      framePaint,
    );
    c.drawLine(Offset(x + ww / 2, y), Offset(x + ww / 2, y + wh), framePaint);
    c.drawLine(Offset(x, y + wh / 2), Offset(x + ww, y + wh / 2), framePaint);
    final treePaint = Paint()..color = const Color(0xFF66BB6A);
    c.drawCircle(Offset(x + ww * 0.35, y + wh * 0.4), ww * 0.12, treePaint);
    c.drawCircle(Offset(x + ww * 0.65, y + wh * 0.45), ww * 0.10, treePaint);
    final trunkP =
        Paint()
          ..color = const Color(0xFF8D6E63)
          ..strokeWidth = 3;
    c.drawLine(
      Offset(x + ww * 0.35, y + wh * 0.52),
      Offset(x + ww * 0.35, y + wh * 0.75),
      trunkP,
    );

    final curtainPaint =
        Paint()..color = const Color(0xFFF8BBD0).withOpacity(0.7);
    final lCurtain =
        Path()
          ..moveTo(x - 4, y - 4)
          ..lineTo(x + ww * 0.25, y - 4)
          ..lineTo(x + ww * 0.15, y + wh + 4)
          ..lineTo(x - 4, y + wh + 4)
          ..close();
    final rCurtain =
        Path()
          ..moveTo(x + ww + 4, y - 4)
          ..lineTo(x + ww * 0.75, y - 4)
          ..lineTo(x + ww * 0.85, y + wh + 4)
          ..lineTo(x + ww + 4, y + wh + 4)
          ..close();
    c.drawPath(lCurtain, curtainPaint);
    c.drawPath(rCurtain, curtainPaint);
  }

  void _drawBookshelf(Canvas c, double x, double y, double sw, double sh) {
    final shelfPaint = Paint()..color = const Color(0xFFD4A96A);
    for (int i = 0; i <= 3; i++) {
      c.drawRect(Rect.fromLTWH(x, y + sh * i / 3, sw, 4), shelfPaint);
    }
    c.drawRect(Rect.fromLTWH(x, y, 4, sh), shelfPaint);
    c.drawRect(Rect.fromLTWH(x + sw - 4, y, 4, sh), shelfPaint);
    final bookColors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFCA28),
      const Color(0xFFAB47BC),
      const Color(0xFFFF7043),
    ];
    final bookW = sw * 0.22;
    final bookH = sh * 0.28;

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 3; col++) {
        final bx = x + 6 + col * (bookW + 2);
        final by = y + 5 + row * (sh / 3);
        c.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(bx, by, bookW, bookH),
            const Radius.circular(2),
          ),
          Paint()..color = bookColors[row * 3 + col],
        );
      }
    }
  }

  void _drawBlocks(Canvas c, double x, double y) {
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFCA28),
    ];
    final size = 18.0;
    for (int i = 0; i < 4; i++) {
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + i * (size + 4), y, size, size),
          const Radius.circular(3),
        ),
        Paint()..color = colors[i],
      );
      final tp = TextPainter(
        text: TextSpan(
          text: ['A', 'B', 'C', '!'][i],
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.55,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        c,
        Offset(
          x + i * (size + 4) + size / 2 - tp.width / 2,
          y + size / 2 - tp.height / 2,
        ),
      );
    }
  }

  void _drawStars(Canvas c, double w, double h) {
    final starPaint =
        Paint()
          ..color = const Color(0xFFFFD54F).withOpacity(0.5)
          ..style = PaintingStyle.fill;

    final positions = [
      [0.88, 0.10],
      [0.05, 0.15],
      [0.92, 0.40],
      [0.08, 0.55],
      [0.85, 0.65],
      [0.12, 0.70],
    ];

    for (final pos in positions) {
      _drawStar(c, Offset(pos[0] * w, pos[1] * h), 6, starPaint);
    }
  }

  void _drawStar(Canvas c, Offset center, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = -math.pi / 2 + i * 2 * math.pi / 5;
      final innerAngle = outerAngle + math.pi / 5;
      final outer = Offset(
        center.dx + r * math.cos(outerAngle),
        center.dy + r * math.sin(outerAngle),
      );
      final inner = Offset(
        center.dx + r * 0.4 * math.cos(innerAngle),
        center.dy + r * 0.4 * math.sin(innerAngle),
      );
      if (i == 0)
        path.moveTo(outer.dx, outer.dy);
      else
        path.lineTo(outer.dx, outer.dy);
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_) => false;
}
