import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../badge_system/badge_controller.dart';
import '../badge_system/badge_model.dart';
import '../item_backend/item_model.dart';

class ReviewItemCard extends StatelessWidget {
  final Item item;

  const ReviewItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final badgeController = Get.find<BadgeController>();

    return StreamBuilder<Badge_item?>(
       stream: Get.find<BadgeController>().streamBadge(item.id),
      builder: (context, snapshot) {
        final badge = snapshot.data;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(item.profileImage),
            ),
            title: Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                _buildSellerBadge(badge?.badgeName ?? 'Loading...'),
                const SizedBox(height: 5),
              ],
            ),
            trailing: const Icon(Iconsax.arrow_right_3),
          ),
        );
      },
    );
  }

  Widget _buildSellerBadge(String badgeName) {
    Color bgColor;
    Color textColor;

    switch (badgeName) {
      case 'Pro Seller':
        bgColor = Colors.blue;
        textColor = Colors.white;
        break;
      case 'Elite Seller':
        bgColor = Colors.purple;
        textColor = Colors.white;
        break;
      case 'Legend Seller':
        bgColor = Colors.orange;
        textColor = Colors.white;
        break;
      default:
        bgColor = Colors.grey;
        textColor = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        badgeName,
        style: TextStyle(
            color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
