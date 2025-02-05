import 'package:flutter/material.dart';

class Views_count extends StatelessWidget {
  const Views_count({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.only( top: 10),
      child: Text(" 12", style: TextStyle(color: Colors.black,fontSize: 20)),
    );
  }
}
