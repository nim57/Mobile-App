import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Home_sereens/widgets/Navigation_menu/navigation_menu.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/constants/text_strings.dart';
import '../../../../../../Utils/validators/validation.dart';
import '../../../controllers/login/login_contorller.dart';
import '../../onboarding/widgets/LOGIN PAGE.dart';
import '../../signup/signup.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginContorller());

    return Form(
      key: controller.loginFormkey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ESizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value) => EValidator.validateEmail(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: ETexts.email),
            ),
            const SizedBox(
              height: ESizes.spaceBtwInputFields,
            ),

            /// password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (Value) =>
                    EValidator.validateEmptyText('Password', Value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: ETexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye)),
                ),
              ),
            ),

            const SizedBox(
              height: ESizes.spaceBtwInputFields / 2,
            ),

            /// Remember me & fought password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Rember me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              value = !controller.rememberMe.value),
                    ),
                    const Text(ETexts.rememberMe),
                  ],
                ),

                /// Forget password
                TextButton(
                    onPressed: () => Get.to(() => const Login()),
                    child: const Text(ETexts.forgotPassword)),
              ],
            ),
            const SizedBox(height: ESizes.spaceBtwInputFields),

            /// Sing in button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(ETexts.signin),
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwInputFields),

            /// Create New Account
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(ETexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
