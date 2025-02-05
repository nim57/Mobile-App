
import 'package:flutter/material.dart';

class ESectionHeading extends StatelessWidget {
  const ESectionHeading({
    super.key, this.textColor, this.showActionButton =false, required this.title,  this.buttonTitle = 'View All', this.onPress,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title,buttonTitle;
  final void Function()? onPress ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,),
        if(showActionButton) TextButton(onPressed: onPress, child:  Text(buttonTitle)),
      ],
    );
  }
}
