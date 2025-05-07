import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../review_backend/review_controler.dart';

class DynamicRatingBar extends StatelessWidget {
  const DynamicRatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = Get.find<ReviewController>();
    
    return Obx(() {
      // Get controller states
      final isLoading = reviewController.isLoading.value;
      final isUpdating = reviewController.isUpdating.value;
      final errorMessage = reviewController.errorMessage.value;
      final updateError = reviewController.updateError.value;

      // Combined states
      final isProcessing = isLoading || isUpdating;
      final hasError = errorMessage.isNotEmpty || updateError.isNotEmpty;

      return Column(
        children: [
          if (isProcessing) _buildCalculationProgress(reviewController),
          if (hasError) _buildErrorIndicator(errorMessage, updateError),
          if (!isProcessing && !hasError) _buildRatingContent(reviewController),
        ],
      );
    });
  }

  Widget _buildCalculationProgress(ReviewController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(
            controller.isUpdating.value 
                ? 'Updating Ratings...' 
                : 'Calculating Averages...',
            style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIndicator(String error, String updateError) {
    final message = error.isNotEmpty ? error : updateError;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: Get.textTheme.bodyMedium?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingContent(ReviewController controller) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ...controller.currentCriteria.map((criterion) {
          final average = controller.averageRatings[criterion] ?? 0.0;
          return _buildRatingRow(criterion, average);
        }),
        _buildLastUpdatedText(controller),
      ],
    );
  }

  Widget _buildRatingRow(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LinearProgressIndicator(
                value: rating / 100,
                backgroundColor: Colors.grey[300],
                color: _getProgressBarColor(rating),
                minHeight: 8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${rating.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getTextColor(rating),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedText(ReviewController controller) {
    return Obx(() {
      if (controller.averageRatings.isEmpty) return const SizedBox.shrink();
      
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Last updated: ${_formatTime(DateTime.now())}',
          style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      );
    });
  }

  Color _getProgressBarColor(double rating) {
    if (rating < 33) return Colors.red;
    if (rating < 66) return Colors.orange;
    return Colors.green;
  }

  Color _getTextColor(double rating) {
    if (rating < 33) return Colors.red;
    if (rating < 66) return Colors.orange;
    return Colors.green;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}