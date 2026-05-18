import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';

class KidoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KidoAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return AppBar(
      backgroundColor: AppColors.bgColor,
      elevation: 0,

      leadingWidth: config.localWidth * 0.35,
      leading: Row(
        children: [
          SizedBox(width: config.localWidth * 0.02),

          Image.asset(
            'assets/images/log.png',
            height: config.imageHeight(0.06),
            width: config.imageWidth(0.12),
            fit: BoxFit.contain,
          ),

          Image.asset(
            'assets/images/kido.png',
            height: config.imageHeight(0.05),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
