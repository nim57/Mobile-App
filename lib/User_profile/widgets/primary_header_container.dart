import 'package:flutter/material.dart';

import '../../Utils/constants/colors.dart';
import 'circular_container.dart';
import 'curved_edges/curved_edges_widget.dart';

class EPrimaryHeaderContainer extends StatelessWidget {
  const EPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ECurvedEdgWidget(
      child: Container(
        color: EColor.primaryColor,

        /// --if[size.isFinite' : is not true.in tack] error occurred -> Read READMEN.md file at
          child:
          Stack(
            children: [
              /// -- Background Customer Shapes
              Positioned(top: -150, right: -250, child: ECircularContainer(background: EColor.white.withOpacity(0.1),),), // Container
              Positioned(top: 100, right: -300, child: ECircularContainer(background: EColor.white.withOpacity(0.1),),), // Container
            child,
            ], // Stack Children
          ),
        ), // Stack
    );
  }
}
