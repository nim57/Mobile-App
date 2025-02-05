import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Utils/constants/colors.dart';
import '../../../../Utils/constants/text_strings.dart';


class form_devider extends StatelessWidget {
  const form_devider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? EColor.darkerGrey : EColor.grey, thickness: 0.5,indent:60,endIndent: 5,)),
        Text(ETexts.orSignInWith.capitalize!,style: Theme.of(context).textTheme.labelMedium,),
        Flexible(child: Divider(color: dark ? EColor.darkerGrey : EColor.grey, thickness: 0.5,indent:5,endIndent: 60,)),
      ],
    );
  }
}

