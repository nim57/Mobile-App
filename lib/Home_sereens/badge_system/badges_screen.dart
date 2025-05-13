// badge_details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Utils/constants/colors.dart';
import '../../common/widgets/appbar/appbar.dart';

class BadgeDetailsScreen extends StatelessWidget {
  final String badgeName;
  final String badgeImageUrl;

  const BadgeDetailsScreen({
    super.key,
    required this.badgeName,
    required this.badgeImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(
        titlt: Text('Badge Details'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Badge Image
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade100,
              ),
              child: CachedNetworkImage(
                imageUrl: badgeImageUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: EColor.primaryColor,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.verified_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Badge Name
            Text(
              badgeName,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: EColor.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            
            // Badge Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getBadgeDescription(badgeName),
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBadgeDescription(String badgeName) {
    switch (badgeName) {
      case 'Legend Seller':
        return 'Awarded to shops maintaining exceptional service quality with over 15,000 satisfied users and minimal negative feedback.';
      case 'Elite Seller':
        return 'Recognizes top-performing shops with 10,000+ satisfied users and consistently high ratings.';
      case 'Pro Seller':
        return 'Given to professional shops serving 5,000+ users while maintaining good service standards.';
      case 'Seller':
        return 'Basic verification badge awarded to all registered shops meeting platform requirements.';
      default:
        return 'This badge recognizes shops that meet our platform quality standards.';
    }
  }
}