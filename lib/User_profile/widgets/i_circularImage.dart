import 'package:flutter/cupertino.dart';

import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/helpers/helper_function.dart';


class ECircularImage extends StatelessWidget {
  const ECircularImage({
    super.key,
    this.fit,
    required this.image,
    this.isNetworkingImage =false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = ESizes.sm,
  });


  final BoxFit ? fit;
  final String image;
  final bool isNetworkingImage;
  final Color ? overlayColor;
  final Color ? backgroundColor;
  final double width,height, padding;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??(EHelperFunctions.isDarkMode(context) ? EColor.black : EColor.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Image(
            fit: fit,
            image: isNetworkingImage? NetworkImage(image) :AssetImage(image) as ImageProvider,
            color:overlayColor
        ),
      ),
    );
  }
}
