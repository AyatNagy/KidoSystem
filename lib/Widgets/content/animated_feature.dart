import 'package:flutter/material.dart';

class AnimatedFeature extends StatefulWidget {
  final String image;
  final double width;
  final bool isPlaying; // أضفنا ده عشان نتحكم في الحركة مع الصوت

  const AnimatedFeature({
    super.key,
    required this.image,
    required this.width,
    this.isPlaying = false,
  });

  @override
  State<AnimatedFeature> createState() => _AnimatedFeatureState();
}

class _AnimatedFeatureState extends State<AnimatedFeature>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // مدة 1000ms (ثانية) بتخلي الحركة هادية وماشية مع ريتم الكلام
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scale = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            Curves
                .easeInOut, // حركة انسيابية جداً (تبدأ ببطء وتسرع في النص وتنهي ببطء)
      ),
    );

    // لو بدأنا والصوت شغال، خلي الأنيميشن يبدأ
    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedFeature oldWidget) {
    super.didUpdateWidget(oldWidget);
    // دي أهم حتة: لو الصوت بدأ يشتغل، الأنيميشن يتحرك. لو وقف، الأنيميشن يرجع لحجمه الطبيعي
    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    } else {
      _controller.reverse(); // يرجع للحجم الأصلي بنعومة بدل ما يقف فجأة
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Image.asset(
        widget.image,
        width: widget.width,
        fit: BoxFit.contain,
      ),
    );
  }
}
