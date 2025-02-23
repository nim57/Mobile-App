import 'package:echo_project_123/Utils/constants/image_Strings.dart';
import 'package:echo_project_123/Utils/constants/sizes.dart';
import 'package:echo_project_123/Utils/constants/text_strings.dart';
import 'package:echo_project_123/Utils/helpers/helper_function.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/forget_password/forget_password_conteoller.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                image: const AssetImage(EImages.user1),
                width: EHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Email, Title & Subtitle
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              Text(
                ETexts.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              Text(
                ETexts.changeYourPasswordSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: const Text(ETexts.done),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => ForgetPasswordController.instonce
                        .resendPasswordResetEmail(email),
                    child: const Text(ETexts.resendEmail),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
