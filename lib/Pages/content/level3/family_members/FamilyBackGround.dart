import 'package:flutter/material.dart';

import 'familymember_body.dart';

class FamilyBackGround extends StatelessWidget {
  const FamilyBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/family_members/b.g.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: FamilyMemberBody()),
        ),
      ),
    );
  }
}
