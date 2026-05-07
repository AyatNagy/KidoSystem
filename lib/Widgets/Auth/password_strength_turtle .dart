import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/validators.dart';

class PasswordStrengthTurtle extends StatefulWidget {
  final String password;

  const PasswordStrengthTurtle({super.key, required this.password});

  @override
  State<PasswordStrengthTurtle> createState() => _PasswordStrengthTurtleState();
}

class _PasswordStrengthTurtleState extends State<PasswordStrengthTurtle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    final strength = Validators.getPasswordStrength(widget.password);
    _controller.value = strength / 4.0;
  }

  @override
  void didUpdateWidget(covariant PasswordStrengthTurtle oldWidget) {
    super.didUpdateWidget(oldWidget);

    final strength = Validators.getPasswordStrength(widget.password);
    double target;
    target = strength / 4.0;
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Color getStrengthColor(double strengthValue) {
    if (strengthValue <= 0.25) return Colors.red;
    if (strengthValue <= 0.5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final int currentStrength = Validators.getPasswordStrength(widget.password);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double maxMovementWidth = MediaQuery.of(context).size.width - 80;
        final double turtleOffset = _controller.value * maxMovementWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Transform.translate(
                offset: Offset(turtleOffset, 0),
                child: Lottie.asset(
                  'assets/lottie/turtle.json',
                  controller: _controller,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: _controller.value,
              color: getStrengthColor(currentStrength / 4.0),
              backgroundColor: Colors.grey.shade300,
              minHeight: 5,
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
