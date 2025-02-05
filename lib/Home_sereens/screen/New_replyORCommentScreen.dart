import 'package:flutter/material.dart';

import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/helpers/helper_function.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/Tab_controller.dart';
import 'Comment_screen.dart';
import 'RivewScreen.dart';

class New_replyROComment extends StatelessWidget {
  const New_replyROComment({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return DefaultTabController(
      length: 2,  // Number of tabs
      child: Scaffold(
        // Appbar
        appBar:const EAppBar(
          titlt: Text("Review Ro Comment"),
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
                      child: Text(' Review  '),
                    ),
                    // SizedBox(width: ESizes.spaceBtwItems),
                    Tab(
                      child: Text('  Comment  '),
                    ),
                  ],
                ),
              ),
            ];
          },
          // Body
          body: const TabBarView(
            children: [
              ReviewScreen(),
              CommentScreen()
            ],
          ),
        ),
      ),
    );
  }
}
