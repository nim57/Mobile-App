import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../User_profile/widgets/i_circularImage.dart';
import '../../../Utils/constants/colors.dart';
import '../../../Utils/constants/image_Strings.dart';


class Foll_Profile extends StatelessWidget {
  const Foll_Profile({
    super.key, this.onPressed,
  });
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ECircularImage(
        image: EImages.user1, width: 55, height: 50, padding: 0,),
      title: Text('Nimesh Sandaruwan',style: Theme.of(context).textTheme.headlineSmall!.apply(color: EColor.white),),
      subtitle:Text('Nimeshsandaruwan268@gmail.com',style: Theme.of(context).textTheme.bodySmall!.apply(color: EColor.white),maxLines: 1,),
      trailing: IconButton(onPressed:onPressed,icon: const Icon(Iconsax.edit,color: EColor.white,),),
    );
  }
}