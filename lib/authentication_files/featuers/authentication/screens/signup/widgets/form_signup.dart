import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Utils/constants/colors.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/constants/text_strings.dart';
import '../veryfy_email.dart';

class form_signup extends StatelessWidget {
  const form_signup({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Form(child: Column(
      children: [
        const SizedBox(height: ESizes.spaceBtwItems,),
        Row(
          children: [
            /// first name
            Expanded(child: TextFormField(
              expands: false,
              decoration: const InputDecoration(labelText: ETexts.firstName,prefixIcon: Icon(Iconsax.user)),
            ),),
            const SizedBox(width: ESizes.spaceBtwInputFields,),
            /// last name
            Expanded(child: TextFormField(
              expands: false,
              decoration: const InputDecoration(labelText: ETexts.lastName,prefixIcon: Icon(Iconsax.user)),
            ),),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwInputFields,),
        /// username
        TextFormField(
          expands: false,
          decoration: const InputDecoration(labelText: ETexts.username,prefixIcon: Icon(Iconsax.user_edit)),
        ),
        const SizedBox(height: ESizes.spaceBtwInputFields,),
        /// email
        TextFormField(
          expands: false,
          decoration: const InputDecoration(labelText: ETexts.email,prefixIcon: Icon(Iconsax.direct)),
        ),
        const SizedBox(height: ESizes.spaceBtwInputFields,),
        /// phone number
        TextFormField(
          expands: false,
          decoration: const InputDecoration(labelText:ETexts.phoneNumber,prefixIcon: Icon(Iconsax.call)),
        ),
        const SizedBox(height: ESizes.spaceBtwInputFields,),

        /// password

        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(labelText: ETexts.password,prefixIcon: Icon(Iconsax.password_check),
            suffixIcon: Icon(Iconsax.eye_slash),
          ),
        ),

        const SizedBox(height: ESizes.spaceBtwInputFields,),
        /// Terms&Condition Checkbox
        Row(
          children: [
            SizedBox(
                width:24,height:24,child: Checkbox(value: true, onChanged: (value){})),
            const SizedBox(width:ESizes.spaceBtwItems ,),
            Text.rich(
              TextSpan(
                  children: [
                    TextSpan(text: ETexts.agreeTo, style: Theme.of(context).textTheme.bodySmall,),
                    TextSpan(text: ETexts.privacyPolicy, style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ?EColor.white : EColor.primaryColor,
                      decoration: TextDecoration.underline,
                    ),),
                    TextSpan(text: ETexts.and, style: Theme.of(context).textTheme.bodySmall,),
                    TextSpan(text: ETexts.termsOfUse, style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ?EColor.white : EColor.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? EColor.white : EColor.primaryColor,
                    ),),
                  ]
              ),),
          ],
        ),
        const SizedBox(height:ESizes.spaceBtwSections ,),
        /// Sing Up   Button
        SizedBox(width: double.infinity,child: ElevatedButton(
            onPressed: () => Get.to(() => const VerifyEmailScreen()),
            child:const  Text(ETexts.createAccount)),
        ) ,
      ],
    ),
    );
  }
}