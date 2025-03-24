// item_tile.dart
import 'package:flutter/material.dart';

class Item_tile extends StatelessWidget {
  const Item_tile({
    super.key,
    this.action,
    required this.image,
    required this.name,
  });

  final VoidCallback? action;
  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Logo from Firebase
            _buildCategoryImage(),
            const SizedBox(height: 10),
            // Category Name from Firebase
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage() {
    return image.isNotEmpty
        ? Image.network(
            image,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error_outline, size: 50),
          )
        : const Placeholder(
            fallbackHeight: 120,
            fallbackWidth: 120,
          );
  }
}
