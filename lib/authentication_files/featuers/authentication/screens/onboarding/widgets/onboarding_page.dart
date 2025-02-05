import 'package:flutter/material.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/helpers/helper_function.dart';


/// Image ,text desider
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key, required this.image, required this.titel, required this.subTitle,
  });

  final String image, titel, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ESizes.defaultSpace),
      child: Column(
        children: [
          const SizedBox(height: ESizes.spaceBtwItems*2),
          Image(
            width: EHelperFunctions.screenWidth() * 0.9,
            height: EHelperFunctions.screenHeight() * 0.6,
            image: AssetImage(image),),
          const SizedBox(height: ESizes.spaceBtwItems,),
          Text(titel,
            style: Theme
                .of(context)
                .textTheme
                .headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ESizes.spaceBtwItems,),

          Text(subTitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}