import 'package:flutter/material.dart';
import '../../../../Utils/constants/sizes.dart';
import '../../../../Utils/constants/text_strings.dart';
import '../../../../Utils/helpers/helper_function.dart';
import '../../style/spacing_styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed});

  final String image ,title, subTitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ESpacingStyle.poddingWithAppBarHeight*2,
          child: Column(
            children: [
              /// Image
              Image(image: AssetImage(image), width: EHelperFunctions.screenWidth()),
              const SizedBox(height: ESizes.spaceBtwItems,),

              /// Title & SubTitle
              Text(title,style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ESizes.spaceBtwItems,),
              Text(subTitle,style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ESizes.spaceBtwItems,),
              /// Button
              SizedBox(width: double.infinity,child: ElevatedButton(onPressed:onPressed,child: const Text(ETexts.Bcontinue),),),
              const SizedBox(height: ESizes.spaceBtwItems,),
            ],
          ),
        ),
      ),
    );
  }
}
