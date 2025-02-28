import 'package:echo_project_123/Home_sereens/widgets/shimmer.dart';
import 'package:echo_project_123/User_profile/widgets/change_name.dart';
import 'package:echo_project_123/User_profile/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/constants/sizes.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../../common/widgets/appbar/appbar.dart';
import 'Section_heading.dart';
import 'i_circularImage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instonce;
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        titlt: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),

      ///-- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// --Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final neteorkImage = controller.user.value.profilePicture;
                      final image = neteorkImage.isNotEmpty
                          ? neteorkImage
                          : EImages.user1;
                      return controller.imageUploading.value
                          ? const EShimmerEffect(
                              width: 80,
                              height: 80,
                              radius: 80,
                            )
                          : ECircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkingImage: neteorkImage.isNotEmpty,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text("Change Profile Picture"),
                    ),
                  ],
                ),
              ),

              /// Details
              const SizedBox(
                height: ESizes.spaceBtwItems / 2,
              ),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              /// Heading Profile Info
              const ESectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              profile_menu(
                onPressed: () => Get.to(() => const ChangeName()),
                title: 'Name',
                value: controller.user.value.fullname,
              ),
              profile_menu(
                onPressed: () {},
                title: 'Username',
                value: controller.user.value.username,
              ),

              const SizedBox(
                height: ESizes.spaceBtwItems,
              ),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              /// Heading Personal Info
              const ESectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              profile_menu(
                onPressed: () {},
                title: 'User ID',
                value: controller.user.value.id,
                icon: Iconsax.copy,
              ),
              profile_menu(
                onPressed: () {},
                title: 'Email ',
                value: controller.user.value.email,
              ),
              profile_menu(
                onPressed: () {},
                title: 'Phone Number',
                value: controller.user.value.phoneNumber,
              ),
              profile_menu(
                onPressed: () {},
                title: 'Gender',
                value: 'Male',
              ),
              profile_menu(
                onPressed: () {},
                title: 'Date Of Birth',
                value: '27/12/2001',
              ),

              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text(
                    'Close Account ',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
