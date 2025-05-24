import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/device/device_utility.dart';
import '../../Utils/helpers/helper_function.dart';

class ESearchContainer extends StatelessWidget {
  const ESearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: ESizes.defaultSpace),
  });
  final String text;
  final IconData? icon;
   final VoidCallback? onTap;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: EDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(ESizes.md),
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                      ? EColor.dark
                      : EColor.light
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(ESizes.cardRadiusNd),
              border: showBorder
                  ? Border.all(color: const Color.fromARGB(255, 202, 31, 31))
                  : null),
          child: Row(
            children: [
              Icon(
                icon,
                color: EColor.darkerGrey,
              ),
              const SizedBox(
                width: ESizes.spaceBtwItems,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
