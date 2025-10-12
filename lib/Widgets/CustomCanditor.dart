import 'package:flutter/material.dart';

class  CustomIndicator extends StatelessWidget {
  const  CustomIndicator({super.key, required this.active});
 final bool active;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: Duration(microseconds: 250),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: active? Color(0xFF8869B3):Colors.grey
    ),
    width: active?30:10,
    height: 10,
    );
  }
}