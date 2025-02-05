import 'package:flutter/material.dart';

import '../../Utils/constants/colors.dart';

class ESettingsMenuTile extends StatelessWidget {
  const ESettingsMenuTile({super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
     this.trailing,
    this.onTap   });

  final IconData icon;
  final String title,subtitle;
  final Widget ? trailing ;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,size: 28, color: EColor.primaryColor),
      title: Text(title,style: Theme.of(context).textTheme.labelMedium,),
      subtitle: Text(subtitle,style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
