import 'package:echo_project_123/Utils/constants/colors.dart';
import 'package:echo_project_123/Utils/constants/sizes.dart';
import 'package:echo_project_123/Utils/constants/text_strings.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/signup_controller.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/signup/Privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter/gestures.dart';

class ETermsAndConditionCheckbox extends StatelessWidget {
  const ETermsAndConditionCheckbox({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instonce;
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value))),
        const SizedBox(
          width: ESizes.spaceBtwItems,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: ETexts.agreeTo,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: ETexts.privacyPolicy,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? EColor.white : EColor.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                      ),
                    );
                  },
              ),
              TextSpan(
                text: ETexts.and,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: ETexts.termsOfUse,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? EColor.white : EColor.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          dark ? EColor.white : EColor.primaryColor,
                    ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
