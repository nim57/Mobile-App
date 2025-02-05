import 'package:echo_project_123/authentication_files/featuers/authentication/screens/login/widgets/login_form.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';
import '../../../../../Utils/constants/sizes.dart';
import '../../../../../Utils/helpers/helper_function.dart';
import '../../../../common/style/spacing_styles.dart';
import '../../../../common/widgets/loginsignup/form_devider.dart';
import '../../../../common/widgets/loginsignup/social_buttons.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = EHelperFunctions.isDarkMode(context);
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding (
          padding: ESpacingStyle.poddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logi ,Title & Sum-Title
              Header_login(dark: dark),
              /// form 
             const LoginForm(),

              /// Devider
              form_devider(dark: dark),
               const SizedBox(height: ESizes.spaceBtwItems,),
              /// Foutter
              const social_buttons(),
            ]),
          )
        ),
    );
  }
}




