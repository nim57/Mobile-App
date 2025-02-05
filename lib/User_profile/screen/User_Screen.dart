import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/Section_heading.dart';
import '../widgets/primary_header_container.dart';
import '../widgets/profile.dart';
import '../widgets/settings_menu_tile.dart';
import '../widgets/user_profile_title.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// -- Header
              EPrimaryHeaderContainer(child: Column(
                children: [
                  /// Appbar
                  EAppBar(titlt: Text('Account',style: Theme.of(context).textTheme.headlineMedium!.apply(color: EColor.white),),),
                  const SizedBox(height: ESizes.spaceBtwItems,),

                  /// User Profile Card
                  EUserProfileTile(onPressed: () => Get.to(() =>const ProfileScreen(),)),
                  const SizedBox(height: ESizes.spaceBtwItems,),
                  const SizedBox(height: ESizes.spaceBtwItems,),
                ],
              ),),
              /// --Body

              Padding(
                padding: const EdgeInsets.all(ESizes.defaultSpace),
                child: Column(
                  children: [
                    /// -- Account  Settings
                   const ESectionHeading(title: 'Account Settings',),
                    const SizedBox(height: ESizes.spaceBtwItems,),

                    ESettingsMenuTile(icon: Iconsax.notification, title: 'Notification', subtitle: 'Set and kind of notification message ', onTap: (){},),
                    ESettingsMenuTile(icon: Iconsax.security_card, title: 'Account Privacy', subtitle: 'Manage data usage and connect ', onTap: (){},),

                    /// --App Settings
                    const SizedBox(height: ESizes.spaceBtwItems,),
                    const ESectionHeading(title: 'App Settings',),
                    const SizedBox(height: ESizes.spaceBtwItems,),
                    ESettingsMenuTile(icon: Iconsax.document_upload, title: 'Lode Data', subtitle: 'Upload Your Data ', onTap: (){},),
                    ESettingsMenuTile(icon: Iconsax.location, title:'Geolocations', subtitle: 'Set recommendation based on Location', trailing: Switch(value: true,onChanged: (value){},),),
                    ESettingsMenuTile(icon: Iconsax.security_user, title:'Safe Mode', subtitle: 'Search result is safe all ages', trailing: Switch(value: false,onChanged: (value){},),),
                    ESettingsMenuTile(icon: Iconsax.image, title:'Hd Image Quality', subtitle: 'Ste Image quality to be seen', trailing: Switch(value: false,onChanged: (value){},),),

                    /// --Logout Button

                    const SizedBox(height: ESizes.spaceBtwItems,),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: (){}, child: const Text('Logout'),),
                    ),
                    const SizedBox(height: ESizes.spaceBtwItems*2.5),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}


