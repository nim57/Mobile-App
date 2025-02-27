import 'package:echo_project_123/Utils/constants/sizes.dart';
import 'package:echo_project_123/Utils/constants/text_strings.dart';
import 'package:echo_project_123/Utils/validators/validation.dart';
import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instonce;
    return Scaffold(
      appBar: AppBar(title: const Text("RE Authinticate USer")),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// EMail
                TextFormField(
                  controller: controller.VerifyEmail,
                  validator: EValidator.validateEmail,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: ETexts.email),
                ),
                const SizedBox(
                  height: ESizes.spaceBtwInputFields,
                ),

                /// password
                /// password
                Obx(
                  () => TextFormField(
                    controller: controller.VerifyPassword,
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
                  height: ESizes.spaceBtwItems,
                ),

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () =>
                          controller.reAuthenticateEmailAndPasswordUser(),
                      child: const Text("Verify")),
                )
              ],
            )),
      )),
    );
  }
}
