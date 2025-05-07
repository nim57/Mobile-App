import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  final String shopId;

  const NextScreen({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop ID: $shopId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Entered Shop ID: $shopId', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('Processing shop information...'),
          ],
        ),
      ),
    );
  }
}