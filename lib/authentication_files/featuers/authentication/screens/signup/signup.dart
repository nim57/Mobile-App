import 'package:echo_project_123/authentication_files/featuers/authentication/screens/signup/widgets/form_signup.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/signup/widgets/header.dart';
import 'package:flutter/material.dart';
import '../../../../../Utils/constants/sizes.dart';
import '../../../../../Utils/helpers/helper_function.dart';
import '../../../../common/widgets/loginsignup/form_devider.dart';
import '../../../../common/widgets/loginsignup/social_buttons.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// Title
            const header_Signup(),
              const SizedBox(height: ESizes.spaceBtwItems,),
              /// Form
              form_signup(dark: dark),

              const SizedBox(height: ESizes.spaceBtwItems,),
              /// Devider

              form_devider(dark: dark),
              const SizedBox(height: ESizes.spaceBtwItems,),
              /// Foutter
              const social_buttons(),
            ],
          ),
        ),
      ),
    );
  }
}




