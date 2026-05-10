import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import '../../../Widgets/responsive_provider.dart';
import '../../../constants.dart';

class FiveSensesLogo extends StatefulWidget {
  final double sizeMultiplier;
  const FiveSensesLogo({super.key, this.sizeMultiplier = 0.4});

  @override
  State<FiveSensesLogo> createState() => _FiveSensesLogoState();
}

class _FiveSensesLogoState extends State<FiveSensesLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _senseAnimations;
  List<ui.Image?> _loadedImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllImages();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _senseAnimations = List.generate(4, (index) {
      double start = index * 0.2;
      double end = start + 0.3;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, math.min(end, 1.0), curve: Curves.bounceInOut),
        ),
      );
    });
  }

  Future<void> _loadAllImages() async {
    final List<String> assetPaths = [
      'assets/images/senses/eye_c.png',
      'assets/images/senses/nose.png',
      'assets/images/senses/mouth_map.png',
      'assets/images/senses/ear_c.png',
    ];

    List<ui.Image?> images = [];
    for (String path in assetPaths) {
      try {
        final data = await rootBundle.load(path);
        final bytes = data.buffer.asUint8List();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        images.add(frame.image);
      } catch (e) {
        debugPrint("خطأ في تحميل الصورة $path: $e");
        images.add(null);
      }
    }

    if (mounted) {
      setState(() {
        _loadedImages = images;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }
    final responsive = ResponsiveProvider.of(context);
    final double logoSize = responsive.imageWidth(widget.sizeMultiplier);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: logoSize,
          height: logoSize,
          child: CustomPaint(
            painter: SensesPainter(
              animations: _senseAnimations.map((a) => a.value).toList(),
              images: _loadedImages,
              colors: [
                AppColors.kidoRed,
                AppColors.kidoOrange,
                AppColors.kidoGreen,
                AppColors.kidoBlue,
              ],
            ),
          ),
        );
      },
    );
  }
}

class SensesPainter extends CustomPainter {
  final List<double> animations;
  final List<ui.Image?> images;
  final List<Color> colors;

  SensesPainter({
    required this.animations,
    required this.images,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double orbitRadius = size.width * 0.35;
    final double bubbleRadius = size.width * 0.15;

    for (int i = 0; i < images.length; i++) {
      if (images[i] == null) continue;
      double angle = (i * 90 - 90) * (math.pi / 180);
      double x = centerX + orbitRadius * math.cos(angle);
      double y = centerY + orbitRadius * math.sin(angle);

      _drawSenseItem(
        canvas,
        Offset(x, y),
        bubbleRadius,
        colors[i],
        animations[i],
        images[i]!,
      );
    }
  }

  void _drawSenseItem(
    Canvas canvas,
    Offset pos,
    double radius,
    Color color,
    double anim,
    ui.Image img,
  ) {
    if (anim <= 0.05) return;

    double currentRadius = radius * anim;

    final bubblePaint =
        Paint()
          ..color = color.withOpacity(0.85)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(pos, currentRadius, bubblePaint);
    final shinePaint = Paint()..color = Colors.white.withOpacity(0.2 * anim);
    canvas.drawCircle(
      Offset(pos.dx - currentRadius * 0.3, pos.dy - currentRadius * 0.3),
      currentRadius * 0.2,
      shinePaint,
    );

    if (anim > 0.4) {
      double imgSize = currentRadius * 1.3;

      final paint = Paint()..color = Colors.white.withOpacity(anim);
      final Size imageSize = Size(img.width.toDouble(), img.height.toDouble());
      final Rect destRect = Rect.fromCenter(
        center: pos,
        width: imgSize,
        height: imgSize,
      );

      final FittedSizes sizes = applyBoxFit(
        BoxFit.contain,
        imageSize,
        destRect.size,
      );
      final Rect inputSubrect = Alignment.center.inscribe(
        sizes.source,
        Offset.zero & imageSize,
      );
      final Rect outputSubrect = Alignment.center.inscribe(
        sizes.destination,
        destRect,
      );

      canvas.drawImageRect(img, inputSubrect, outputSubrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SensesPainter oldDelegate) => true;
}
