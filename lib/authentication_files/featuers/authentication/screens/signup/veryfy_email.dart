import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/constants/image_Strings.dart';
import '../../../../../Utils/constants/sizes.dart';
import '../../../../../Utils/constants/text_strings.dart';
import '../../../../../Utils/helpers/helper_function.dart';
import '../../../../common/widgets/success_screen/sussess_screen.dart';
import '../login/login.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed:() => Get.back(), icon:const  Icon(CupertinoIcons.clear)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
             /// Image
               Image(image: const AssetImage(EImages.onboardingImage2),
               width: EHelperFunctions.screenWidth()),
              /// Title & SubTitle
            Text(ETexts.confirmEmailTitle,style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ESizes.spaceBtwItems,),
              Text('Nimeshsandaruwan268@gmail.com',style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center,),
              const SizedBox(height: ESizes.spaceBtwItems,),
              Text(ETexts.confirmEmailSubtitle,style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ESizes.spaceBtwItems,),
              /// Button
            SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => Get.to(() =>  SuccessScreen(
              image: EImages.succes,
              title: ETexts.accountCreatedTitle,
              subTitle: ETexts.yourAccountCreatedSubTitle,
              onPressed: () => Get.to(() => const LoginScreen()),
            ),),
              child: const Text(ETexts.Bcontinue),),),
              const SizedBox(height: ESizes.spaceBtwItems,),
              SizedBox(width: double.infinity,child: TextButton(onPressed: (){},child: const Text(ETexts.resendEmail),),),
            ],
          ),
        ),
      ),
    );
  }
}




