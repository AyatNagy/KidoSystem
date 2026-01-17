import 'package:flutter/material.dart';
import 'package:kido/utils/password_rules.dart';

class PasswordErrorsView extends StatelessWidget{
  final String password;
  const PasswordErrorsView({super.key,required this.password});

  @override
  Widget build(BuildContext context) {
    if(password.isEmpty){
      return const SizedBox.shrink();
    }

    final unmet = PasswordPolicy.unmetRules(password);
    if(unmet.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: unmet.map((rule){
        return Row(
          children: [
            const Icon(Icons.cancel, color: Colors.red, size: 16),
            const SizedBox(width: 6,),
            Text(
              rule.message,
              style: const TextStyle(color: Colors.red,fontSize: 13)
              
            ),
          ],
        );
      }).toList(),

    );
  }
}