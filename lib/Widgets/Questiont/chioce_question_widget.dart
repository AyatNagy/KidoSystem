import 'package:flutter/material.dart';
import 'package:kido/Models/chioce_question.dart';
import 'package:kido/Widgets/ResponsiveProvider.dart';

typedef OnChoiceSelected = void Function(int selectedIndex);

class ChoiceQuestionWidget extends StatefulWidget {
  final ChoiceQuestion question;
  final OnChoiceSelected onSelected;

  const ChoiceQuestionWidget({
    super.key,
    required this.question,
    required this.onSelected,
  });

  @override
  State<ChoiceQuestionWidget> createState() => _ChoiceQuestionWidgetState();
}

class _ChoiceQuestionWidgetState extends State<ChoiceQuestionWidget> {
  int? selectedIndex;

  @override
  void didUpdateWidget(covariant ChoiceQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // لو السؤال اتغير نعمل reset
    if (oldWidget.question != widget.question) {
      setState(() {
        selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final choices = widget.question.choices;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: choices.length <= 2 ? choices.length : 2,
        crossAxisSpacing: config.localWidth * 0.03,
        mainAxisSpacing: config.localHeight * 0.03,
        childAspectRatio: 1,
      ),
      itemCount: choices.length,
      itemBuilder: (context, index) {
        final choice = choices[index];
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onSelected(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient:
                  isSelected
                      ? const LinearGradient(
                        colors: [Color(0xfff06292), Color(0xffff8a65)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : const LinearGradient(
                        colors: [Color(0xffe0e0e0), Color(0xfff5f5f5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(config.localWidth * 0.03),
            child: Center(child: Image.asset(choice, fit: BoxFit.contain)),
          ),
        );
      },
    );
  }
}
