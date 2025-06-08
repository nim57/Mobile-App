import 'package:flutter/material.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/helpers/helper_function.dart';
import '../filtering_system/earchFilterScreen.dart';
import '../widgets/Home_appBar.dart';
import '../widgets/Search_bar.dart';
import '../widgets/setting_icon.dart';
import 'New_post_Screen.dart';
import 'following_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      _showPostsTabDialog();
    }
  }

  void _showPostsTabDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Section Not Available'),
        content: const Text('This section is not available at the moment.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
            child: const Text('Go Back'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: HomeAppBar(
        showSetting: false,
        actions: [
          ESettingIcon(
            onPressed: () {},
          )
        ],
      ),
      body: NestedScrollView(
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
                  children: [
                    const SizedBox(height: ESizes.spaceBtwItems),
                    ESearchContainer(
                      text: 'Search Here...',
                      showBorder: true,
                      showBackground: false,
                      padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchFilterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(child: Text('  Reviews  ')),
                  Tab(child: Text('  posts  ')),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            NewPost_Screen(),
            PostScreen(), // Updated to PostScreen
          ],
        ),
      ),
    );
  }
}