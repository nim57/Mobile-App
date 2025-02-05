import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Home_sereens/widgets/Navigation_menu/navigation_menu.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/constants/text_strings.dart';
import '../../onboarding/widgets/LOGIN PAGE.dart';
import '../../signup/signup.dart';


class LoginForm extends StatelessWidget {
  const      LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(child: Padding(
      padding: const EdgeInsets.symmetric(vertical: ESizes.spaceBtwSections),
      child: Column(
        children: [
          /// Email
          TextFormField(
            decoration:  const InputDecoration(prefixIcon: Icon(Iconsax.direct_right),labelText: ETexts.email),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields,),

          /// password

          TextFormField(decoration: const InputDecoration(prefixIcon: Icon(Iconsax.password_check),labelText:ETexts.password, suffixIcon: Icon(Iconsax.eye_slash) ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields/2,),
          /// Remember me & fought password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Rember me
              Row(
                children: [
                  Checkbox(value: true, onChanged:(value){}),
                  const Text(ETexts.rememberMe),
                ],
              ),
              /// Forget password
              TextButton(onPressed: () => Get.to(() => const Login()),
                  child: const Text(ETexts.forgotPassword)),
            ],
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Sing in button
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => const NavigationMenu()),child: const Text(ETexts.signin),),),
          const SizedBox(height: ESizes.spaceBtwInputFields),
          /// Create New Account
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()),child: const Text(ETexts.createAccount),),),
        ],
      ),
    ),
    );
  }
}