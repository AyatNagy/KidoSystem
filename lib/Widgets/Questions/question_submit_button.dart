import 'package:flutter/material.dart';
import '../../Widgets/ResponsiveProvider.dart';

/// Widget لزر Submit
class QuestionSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;
  final String text;

  const QuestionSubmitButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.text = "Submit Answer",
  });

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return SizedBox(
      width: config.localWidth * 0.6,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: config.localHeight * 0.02,
          ),
          backgroundColor: Colors.orange[600],
          disabledBackgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: config.buttonFont,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

