import 'package:echo_project_123/User_profile/screen/Reviews_screen.dart';
import 'package:echo_project_123/User_profile/screen/your_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Home_sereens/widgets/Tab_controller.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/helpers/helper_function.dart';
import '../widgets/profile.dart';
import '../widgets/user_profile_title.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: NestedScrollView(
          // Header
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: dark ? EColor.black : EColor.white,
                expandedHeight: 240,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(ESizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// User Profile Card
                      Center(
                        child: EUserProfileTile(
                            onPressed: () => Get.to(
                                  () => const ProfileScreen(),
                                )),
                      ),

                      const SizedBox(
                        height: ESizes.spaceBtwItems,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Followers & following count
                            Container(
                              width: 130,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "120",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .apply(
                                              color: const Color.fromARGB(
                                                  255, 247, 246, 246)),
                                    ),
                                    Text(
                                      "Following",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .apply(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              width: 130,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "120",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .apply(
                                              color: const Color.fromARGB(
                                                  255, 247, 246, 246)),
                                    ),
                                    Text(
                                      "Followers",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .apply(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: ESizes.spaceBtwItems * 2,
                      ),

                      const SizedBox(height: ESizes.spaceBtwItems),
                    ],
                  ),
                ),
                // Tabs
                bottom: const ETabBar(
                  tabs: [
                    Tab(
                      child: Text('  Your Post  '),
                    ),
                    // SizedBox(width: ESizes.spaceBtwItems),
                    Tab(
                      child: Text('  Reviews  '),
                    ),
                  ],
                ),
              ),
            ];
          },
          // Body
          body: const TabBarView(
            children: [
              YourPost_Screen(),
              YourReviewScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
