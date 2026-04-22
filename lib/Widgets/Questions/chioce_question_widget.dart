// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Models/chioce_question.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../config/responsive_config.dart';

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
    if (oldWidget.question != widget.question) {
      setState(() {
        selectedIndex = null;
      });
    }
  }

  static final glowBoxShadow = [
    BoxShadow(
      color: const Color(0xfff06292).withOpacity(0.9),
      blurRadius: 18,
      spreadRadius: 6,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: const Color(0xffff8a65).withOpacity(0.6),
      blurRadius: 12,
      spreadRadius: 3,
      offset: const Offset(3, 3),
    ),
  ];

  static const defaultBoxShadow = <BoxShadow>[];

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final isColorQuestion = widget.question.colors != null;

    if (isColorQuestion) {
      return _buildColorQuestionLayout(config);
    } else {
      return _buildImageChoicesLayout(config);
    }
  }

  Widget _buildImageChoicesLayout(ResponsiveConfig config) {
    final choices = widget.question.choices!;

    return Container(
      color: Colors.white,
      child: Center(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: choices.length <= 2 ? choices.length : 2,
            crossAxisSpacing: config.localWidth * 0.03,
            mainAxisSpacing: config.localHeight * 0.03,
            childAspectRatio: 0.7,
          ),
          itemCount: choices.length,
          itemBuilder: (context, index) {
            final choice = choices[index];
            final isSelected = selectedIndex == index;

            return Center(
              child: GestureDetector(
                onTap: () => _handleChoiceSelection(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected ? glowBoxShadow : defaultBoxShadow,
                  ),
                  padding: EdgeInsets.all(config.localWidth * 0.01),
                  child: Center(
                    child: Image.asset(choice, fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildColorQuestionLayout(ResponsiveConfig config) {
    final colors = widget.question.colors!;
    final colorImage = widget.question.colorImage!;
    final selectedColor = selectedIndex != null ? colors[selectedIndex!] : null;

    Widget imageWidget = Image.asset(
      colorImage,
      height: config.localHeight * 0.3,
      fit: BoxFit.contain,
    );

    if (selectedColor != null) {
      imageWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(selectedColor, BlendMode.modulate),
        child: imageWidget,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: config.localHeight * 0.05),
            child: imageWidget,
          ),
          SizedBox(
            height: config.localHeight * 0.1,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder:
                  (context, index) => SizedBox(width: config.localWidth * 0.05),
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => _handleChoiceSelection(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: config.localWidth * 0.15,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: isSelected ? glowBoxShadow : defaultBoxShadow,
                      border:
                          isSelected
                              ? Border.all(color: Colors.white, width: 4)
                              : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleChoiceSelection(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(index);
  }
}
