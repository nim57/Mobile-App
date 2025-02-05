import 'package:flutter/material.dart';
import '../../../../../../Utils/constants/text_strings.dart';

class header_Signup extends StatelessWidget {
  const header_Signup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 70),
      child: Text(ETexts.signupTitle,style: Theme.of(context).textTheme.headlineMedium,),
    );
  }
}