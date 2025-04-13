import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screen/pending_message.dart';
import 'review_repository.dart';
import 'review_model.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final ReviewRepository _repository = ReviewRepository();
  final RxMap<String, double> ratings = <String, double>{}.obs;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString categoryName = ''.obs;
  final RxString itemName = ''.obs;
  final RxBool isVisible = true.obs;
  final categoryCriteria = {
    'Electronics & Appliances': [
      'Customer Service',
      'Value for Money',
      'Product Quality',
      'After-Sales Support',
      'Warranty Clarity',
    ],
    'Food & Dining': [
      'Food Quality',
      'Hygiene & Cleanliness',
      'Service Speed',
      'Value for Money',
      'Ambiance',
    ],
    'Clothing & Fashion': [
      'Product Quality',
      'Pricing',
      'Staff Helpfulness',
      'Fitting Room Experience',
      'Return Policy Flexibility',
    ],
    'Automotive Services': [
      'Service Quality',
      'Timeliness',
      'Cost Transparency',
      'Technician Expertise',
      'Facility Cleanliness',
    ],
    'Healthcare': [
      'Staff Professionalism',
      'Wait Time',
      'Facility Cleanliness',
      'Treatment Effectiveness',
      'Cost Transparency',
    ],
    'Beauty & Personal Care': [
      'Service Quality',
      'Hygiene Standards',
      'Staff Friendliness',
      'Ambiance',
      'Pricing',
    ],
    'Education': [
      'Teaching Quality',
      'Facility Quality',
      'Fee Structure Clarity',
      'Student Support',
      'Campus Safety',
    ],
    'Real Estate': [
      'Transparency',
      'Responsiveness',
      'Market Knowledge',
      'Negotiation Support',
      'Documentation Assistance',
    ],
    'Tourism & Hospitality': [
      'Room/Vehicle Cleanliness',
      'Staff Courtesy',
      'Amenities Quality',
      'Location Convenience',
      'Check-in/Checkout Efficiency',
    ],
    'Grocery & Retail Stores': [
      'Product Freshness/Variety',
      'Pricing',
      'Staff Behavior',
      'Checkout Speed',
      'Parking/Accessibility',
    ],
    'Home & Construction Services': [
      'Workmanship Quality',
      'Timeliness',
      'Material Quality',
      'Cost Accuracy',
      'Cleanup After Service',
    ],
    'Transportation': [
      'Driver Behavior',
      'Vehicle Condition',
      'Pricing Transparency',
      'Safety Measures',
      'On-Time Performance',
    ],
    'Financial Services': [
      'Transparency',
      'Customer Support',
      'Processing Speed',
      'Fees & Charges Clarity',
      'Digital Tools Usability',
    ],
    'E-commerce & Online Services': [
      'Delivery Speed',
      'Product Accuracy',
      'Return Process Ease',
      'Customer Support',
      'Website/App Usability',
    ],
    'Agriculture & Farming Supplies': [
      'Product Quality',
      'Pricing',
      'Staff Knowledge',
      'Delivery Reliability',
      'After-Sales Guidance',
    ],
    'Freelancers & Independent Professionals': [
      'Communication',
      'Work Quality',
      'Deadline Adherence',
      'Professionalism',
      'Cost Fairness',
    ],
    'Religious/Spiritual Services': [
      'Guidance Quality',
      'Facility Cleanliness',
      'Staff Behavior',
      'Donation Transparency',
      'Accessibility',
    ],
    'Events & Entertainment': [
      'Event Organization',
      'Venue Quality',
      'Ticketing Process',
      'Crowd Management',
      'Value for Money',
    ],
    'Government Services': [
      'Efficiency',
      'Staff Behavior',
      'Wait Time',
      'Digital Service Quality',
      'Transparency',
    ],
    'Charity/Non-Profit Organizations': [
      'Impact Transparency',
      'Donation Utilization',
      'Communication',
      'Volunteer Support',
      'Community Engagement',
    ],
  };

    Future<void> fetchReviews(String itemId, String categoryId) async {
    try {
      isLoading(true);
      errorMessage('');

       _repository.getReviewsByItem(itemId).listen(
      (reviewsList) {
        reviews.value = reviewsList;
        isLoading(false);
      },
      onError: (e) {
        if (e.toString().contains('index')) {
          _showIndexErrorDialog(e.toString());
        } else {
          errorMessage.value = e.toString();
        }
        isLoading(false);
      }
    );
      
      categoryName.value = await _repository.getCategoryName(categoryId);
      itemName.value = await _repository.getItemName(itemId);

      reviews.bindStream(_repository.getReviewsByItem(itemId));
    } on FirebaseException catch (e) {
      errorMessage.value = 'Firebase Error: ${e.message}';
      if (e.code == 'failed-precondition') {
        _showIndexErrorDialog(e.toString());
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      if (e.toString().contains('index required')) {
        _showIndexErrorDialog(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

 void _showIndexErrorDialog(String error) {
  Get.dialog(
    AlertDialog(
      title: const Text('Index Required'),
      content: Column(
        children: [
          const Text('This query needs a Firestore index.'),
          const SizedBox(height: 10),
          SelectableText(
            _parseErrorUrl(error),
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Dismiss'),
          onPressed: () => Get.back(),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}

String _parseErrorUrl(String error) {
  try {
    return error.split('https://').last.replaceAll(',', '');
  } catch (e) {
    return 'https://console.firebase.google.com';
  }
}

 Future<void> submitReview({
    required String categoryId,
    required String itemId,
    required List<String> tags,
    required String title,
    required String comment,
    required String userId,
    required String username,
    required String userProfile,
  }) async {
    try {
      final categoryName = await getCategoryName(categoryId);
      final itemName = await getItemName(itemId);

      final review = ReviewModel(
        reviewId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        categoryId: categoryId,
        itemId: itemId,
        itemName: itemName,
        ratings: ratings.value,
        tags: tags,
        title: title,
        comment: comment,
        isVisible: isVisible.value,
        username: username,
        userProfile: userProfile,
        timestamp: Timestamp.now(),
      );

      await _repository.addReview(review);
      Get.off(() => const PendingMessage());
      Get.snackbar('Success', 'Review submitted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  void updateRating(String criterion, double rating) {
    ratings[criterion] = rating;
  }

  String getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays > 365) return '${(difference.inDays ~/ 365)}y ago';
    if (difference.inDays > 30) return '${(difference.inDays ~/ 30)}mo ago';
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  void clearReviews() {
    reviews.clear();
    errorMessage.value = '';
    categoryName.value = '';
    itemName.value = '';
    ratings.clear();
  }

   Future<String> getCategoryName(String categoryId) async {
    return await _repository.getCategoryName(categoryId);
  }

  Future<String> getItemName(String itemId) async {
    return await _repository.getItemName(itemId);
  }
}