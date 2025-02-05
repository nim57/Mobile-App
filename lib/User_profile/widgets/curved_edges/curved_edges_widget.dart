import 'package:flutter/material.dart';

import 'curved_edges.dart';

class ECurvedEdgWidget extends StatelessWidget {
  const ECurvedEdgWidget({
    super.key, this.child,
  });

  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper:ECustomCurvedEdges() ,
      child: child,
    );
  }
}

