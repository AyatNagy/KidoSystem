// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ContentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // حذفنا bool showBackButton لأننا مش هنحتاجه خلاص
  final List<Color> colors;

  const ContentAppBar({
    super.key,
    required this.title,
    this.colors = const [
      Color(0xFFF5E6CA), // البيج اللي اخترناه
      Color(0xFFEADBC8),
      Color(0xFF7D6E83),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      // 1. دي بتمنع ظهور زرار الرجوع الافتراضي
      automaticallyImplyLeading: false,

      // 2. هنا خلينا الـ leading بـ null عشان ميبقاش فيه أي زرار على الشمال
      leading: null,

      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors[0].withOpacity(0.1), colors[1].withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colors[2],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
