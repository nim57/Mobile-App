import 'package:echo_project_123/User_profile/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/constants/sizes.dart';
import '../../common/widgets/appbar/appbar.dart';
import 'Section_heading.dart';
import 'i_circularImage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        titlt: Text('Profile',style: Theme.of(context).textTheme.headlineMedium,),
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
                   const ECircularImage(image: EImages.user1,width: 80, height: 80,),
                    TextButton(onPressed:(){}, child: const Text("Change Profile Picture"),),
                  ],
                ),
              ),
              /// Details
              const SizedBox(height: ESizes.spaceBtwItems / 2,),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              /// Heading Profile Info
              const  ESectionHeading(title: 'Profile Information', showActionButton: false,),
              const SizedBox(height: ESizes.spaceBtwItems),

              profile_menu(onPressed: () {  }, title: 'Name', value: 'Nimesh Sandaruwan',),
              profile_menu(onPressed: () {  }, title: 'Username', value: 'Nimesh123',),

              const SizedBox(height: ESizes.spaceBtwItems,),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              /// Heading Personal Info
              const  ESectionHeading(title: 'Personal Information', showActionButton: false,),
              const SizedBox(height: ESizes.spaceBtwItems),

              profile_menu(onPressed: () {  }, title: 'User ID', value: '57301',icon: Iconsax.copy,),
              profile_menu(onPressed: () {  }, title: 'Email ', value: 'Nimeshsandaruwan268@gmail.com',),
              profile_menu(onPressed: () {  }, title: 'Phone Number', value: '070-1990179',),
              profile_menu(onPressed: () {  }, title: 'Gender', value: 'Male',),
              profile_menu(onPressed: () {  }, title: 'Date Of Birth', value: '27/12/2001',),

              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: (){},
                  child: const Text('Close Account ',style: TextStyle(color: Colors.red),),
                ),
              )




            ],
          ),
        ),
      ),
    );
  }
}

