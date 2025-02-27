import 'package:echo_project_123/Utils/validators/validation.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/signup_controller.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/signup/widgets/terms_condition_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/constants/text_strings.dart';

class form_signup extends StatelessWidget {
  const form_signup({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormkey,
      child: Column(
        children: [
          const SizedBox(
            height: ESizes.spaceBtwItems,
          ),
          Row(
            children: [
              /// first name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (Value) =>
                      EValidator.validateEmptyText('First name', Value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: ETexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(
                width: ESizes.spaceBtwInputFields,
              ),

              /// last name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (Value) =>
                      EValidator.validateEmptyText('Last name', Value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: ETexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: ESizes.spaceBtwInputFields,
          ),

          /// username
          TextFormField(
            validator: (Value) =>
                EValidator.validateEmptyText('Username', Value),
            controller: controller.username,
            expands: false,
            decoration: const InputDecoration(
                labelText: ETexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(
            height: ESizes.spaceBtwInputFields,
          ),

          /// email
          TextFormField(
            validator: (Value) => EValidator.validateEmail(Value),
            controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
                labelText: ETexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(
            height: ESizes.spaceBtwInputFields,
          ),

          /// phone number
          TextFormField(
            validator: (Value) => EValidator.validatePhoneNumber(Value),
            controller: controller.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
                labelText: ETexts.phoneNumber, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(
            height: ESizes.spaceBtwInputFields,
          ),

          /// password

          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (Value) => EValidator.validatePassword(Value),
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
            height: ESizes.spaceBtwInputFields,
          ),

          /// Terms&Condition Checkbox
          ETermsAndConditionCheckbox(dark: dark),
          const SizedBox(
            height: ESizes.spaceBtwSections,
          ),

          /// Sing Up   Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => controller.signup(),
                child: const Text(ETexts.createAccount)),
          ),
        ],
      ),
    );
  }
}
