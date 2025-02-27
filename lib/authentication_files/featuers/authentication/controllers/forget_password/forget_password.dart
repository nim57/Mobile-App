import 'package:echo_project_123/Utils/constants/sizes.dart';
import 'package:echo_project_123/Utils/constants/text_strings.dart';
import 'package:echo_project_123/Utils/validators/validation.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/forget_password/forget_password_conteoller.dart';
import 'package:echo_project_123/common/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: const EAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            Text(ETexts.forgotPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: ESizes.spaceBtwItems),
            Text(ETexts.forgotPasswordSubtitle,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: ESizes.spaceBtwSections * 2),

            /// TExt field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: EValidator.validateEmail,
                decoration: const InputDecoration(
                  labelText: ETexts.email,
                  prefixIcon: Icon(Iconsax.direct_right),
                ),
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwSections),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.sendPasswordResetEmail(),
                child: const Text(ETexts.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
