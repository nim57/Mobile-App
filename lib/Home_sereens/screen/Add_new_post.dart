import 'package:flutter/material.dart';

import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/helpers/helper_function.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/Tab_controller.dart';
import 'Image_video_Screen.dart';
import 'New_text_post.dart';

class AddNewPost extends StatelessWidget {
  const AddNewPost({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        // Appbar
        appBar: EAppBar(
          titlt: Text('New Post'),
          showBackArrow: true,
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
                expandedHeight: 0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(ESizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      // Search Bar
                      SizedBox(height: ESizes.spaceBtwItems),
                    ],
                  ),
                ),
                // Tabs
                bottom: const ETabBar(
                  tabs: [
                    Tab(
                      child: Text('  New Text Post  '),
                    ),
                    // SizedBox(width: ESizes.spaceBtwItems),
                    Tab(
                      child: Text('  Image & Video  '),
                    ),
                  ],
                ),
              ),
            ];
          },
          // Body
          body: const TabBarView(
            children: [
              NewTextPost(),
              ImageVideoScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
