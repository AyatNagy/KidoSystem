// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Models/level3/pixel.dart';

class PixelColoringWidget extends StatefulWidget {
  final PixelItem item;
  final VoidCallback onComplete;

  const PixelColoringWidget({
    super.key,
    required this.item,
    required this.onComplete,
  });

  @override
  State<PixelColoringWidget> createState() => _PixelColoringWidgetState();
}

class _PixelColoringWidgetState extends State<PixelColoringWidget> {
  Set<int> coloredIndices = {};

  @override
  void didUpdateWidget(covariant PixelColoringWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      coloredIndices.clear();
    }
  }

  void _handleTap(int index) {
    if (widget.item.shapeIndices.contains(index)) {
      if (!coloredIndices.contains(index)) {
        HapticFeedback.lightImpact();
        setState(() {
          coloredIndices.add(index);
        });

        if (coloredIndices.length == widget.item.shapeIndices.length) {
          widget.onComplete();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: widget.item.primaryColor.withOpacity(0.3),
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.item.grid,
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.5,
              ),
              itemCount: widget.item.grid * widget.item.grid,
              itemBuilder: (context, index) {
                bool isShapePart = widget.item.shapeIndices.contains(index);
                bool isColored = coloredIndices.contains(index);

                return GestureDetector(
                  onTapDown: (_) => _handleTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color:
                          isColored
                              ? widget.item.primaryColor
                              : (isShapePart
                                  ? Colors.grey
                                  : Colors.transparent),
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color:
                            isShapePart ? Colors.black12 : Colors.transparent,
                        width: 0.2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
