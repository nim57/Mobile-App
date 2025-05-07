import 'package:flutter/material.dart';

import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/helpers/helper_function.dart';
import '../widgets/Home_appBar.dart';
import '../widgets/Search_bar.dart';
import '../widgets/Tab_controller.dart';
import '../widgets/setting_icon.dart';
import 'New_post_Screen.dart';
import 'following_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        // Appbar
        appBar: HomeAppBar(
          showSetting: false,
          actions: [
            ESettingIcon(
              onPressed: () {},
            )
          ],
        ),
        body: NestedScrollView(
          // Header
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: dark ? EColor.black : EColor.white,
                expandedHeight: 160,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(ESizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      // Search Bar
                      SizedBox(height: ESizes.spaceBtwItems),
                      ESearchContainer(
                        text: 'Search Here...',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                // Tabs
                bottom: const ETabBar(
                  tabs: [
                    Tab(
                      child: Text('  Post  '),
                    ),
                    // SizedBox(width: ESizes.spaceBtwItems),
                    Tab(
                      child: Text('  Review  '),
                    ),
                  ],
                ),
              ),
            ];
          },
          // Body
          body: const TabBarView(
            children: [
              Following_Screen(),
              NewPost_Screen(),
            ],
          ),
        ),
      ),
    );
  }
}
