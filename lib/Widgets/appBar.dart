import 'package:flutter/material.dart';

class KidoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KidoAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,

      leading: Row(
        children: [
          const SizedBox(width: 9),
          Image.asset('assets/images/log.png', height: 35,width: 50,),
          const SizedBox(width: 5),
          Image.asset('assets/images/kido.png', height: 30),
        ],
      ),
    );
  }
}

