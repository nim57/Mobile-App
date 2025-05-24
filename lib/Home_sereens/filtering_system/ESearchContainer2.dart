// ESearchContainer2.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/device/device_utility.dart';
import '../../Utils/helpers/helper_function.dart';

class ESearchContainer2 extends StatefulWidget {
  const ESearchContainer2({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: ESizes.defaultSpace),
  });

  final TextEditingController? controller;
  final String hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final bool showBackground;
  final bool showBorder;
  final EdgeInsetsGeometry padding;

  @override
  State<ESearchContainer2> createState() => _ESearchContainer2State();
}

class _ESearchContainer2State extends State<ESearchContainer2> {
  late final TextEditingController _internalController;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _controller = widget.controller ?? _internalController;
  }

  @override
  void dispose() {
    // Only dispose internal controller if we created it
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Padding(
      padding: widget.padding,
      child: Container(
        width: EDeviceUtils.getScreenWidth(context),
        decoration: BoxDecoration(
          color: widget.showBackground
              ? dark
                  ? EColor.dark
                  : EColor.light
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ESizes.cardRadiusNd),
          border: widget.showBorder
              ? Border.all(color: EColor.grey.withOpacity(0.5))
              : null,
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: EColor.darkerGrey),
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(ESizes.md),
          ),
        ),
      ),
    );
  }
}