import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/constants/image_Strings.dart';
import 'i_circularImage.dart';

class EUserProfileTile extends StatelessWidget {
  const EUserProfileTile({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instonce;
    return ListTile(
      leading: const ECircularImage(
        image: EImages.user1,
        width: 55,
        height: 50,
        padding: 0,
      ),
      title: Text(
        controller.user.value.fullname,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: EColor.white),
      ),
      subtitle: Text(
        controller.user.value.email,
        style:
            Theme.of(context).textTheme.bodySmall!.apply(color: EColor.white),
        maxLines: 1,
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Iconsax.edit,
          color: EColor.white,
        ),
      ),
    );
  }
}
