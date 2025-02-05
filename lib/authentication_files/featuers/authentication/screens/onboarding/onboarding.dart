import 'package:echo_project_123/authentication_files/featuers/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/constants/image_Strings.dart';
import '../../../../../Utils/constants/text_strings.dart';
import '../../controllers.onbparding/onboarding_controller.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controler = Get.put(OnBoardingController());
    return Scaffold(
      body:  Stack (
        children: [
          /// Horizontal Scrollable Page 
          PageView(
            controller: controler.pageController,
            onPageChanged: controler.updatePageIndicator,
            children:const [
              OnBoardingPage(image: EImages.onboardingImage1,titel: ETexts.onBoardingTitle1,subTitle:  ETexts.onBoardingSubTitle1),
              OnBoardingPage(image: EImages.onboardingImage2,titel: ETexts.onBoardingTitle2,subTitle: ETexts.onBoardingSubTitle2,),
              OnBoardingPage(image: EImages.onboardingImage3,titel: ETexts.onBoardingTitle3,subTitle: ETexts.onBoardingSubTitle3 ,),

            ],
          ),
          /// Skip Button
         const OnBoardinSkip(),

          /// Dot Navigation SmoothPageIndicator
        const  OnBoardingNavigation(),
          
          /// Circular Button 
          const OnBoardingNextButton(),

        ],
      ),
    );
  }
}





