import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reply_backend/reply_repository.dart';
import '../screen/pending_message.dart';
import 'review_Repository.dart';
import 'review_model.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final ReviewRepository _repository = ReviewRepository();
  final RxMap<String, double> ratings = <String, double>{}.obs;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final ReplyRepository _replyRepository = ReplyRepository();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString categoryName = ''.obs;
  final RxString itemName = ''.obs;
  final RxBool isVisible = true.obs;
  final categoryCriteria = {
    "Mobile Repair Services": [
      "Repair Quality",
      "Turnaround Time",
      "Technician Expertise",
      "Cost Transparency",
      "Warranty on Repairs"
    ],
    "Spice Packaging & Export Shops": [
      "Product Freshness",
      "Packaging Quality",
      "Pricing Competitiveness",
      "Shipping Reliability",
      "Customer Service"
    ],
    "Tuk-Tuk Rental Services": [
      "Vehicle Condition",
      "Rental Pricing Transparency",
      "Customer Support",
      "Availability of Vehicles",
      "Safety Features"
    ],
    "Sustainable Eco-Tourism Agencies": [
      "Guide Knowledge",
      "Eco-Friendliness of Activities",
      "Itinerary Satisfaction",
      "Safety Measures",
      "Value for Money"
    ],
    "Online Tutoring Platforms": [
      "Tutor Expertise",
      "Platform Usability",
      "Session Flexibility",
      "Course Relevance",
      "Technical Support"
    ],
    "E-Commerce Stores (Handicrafts, Apparel, Electronics)": [
      "Website/App Usability",
      "Delivery Speed",
      "Product Accuracy (vs. Description)",
      "Return/Refund Process",
      "Payment Security"
    ],
    "Customized Travel Planners": [
      "Personalization of Itinerary",
      "Communication Responsiveness",
      "Budget Adherence",
      "Local Experience Quality",
      "Emergency Support"
    ],
    "Agriculture Tech Providers": [
      "IoT Device Reliability",
      "Technical Support",
      "Value for Money",
      "Training Provided",
      "Impact on Farm Yield"
    ],
    "Banks & Financial Institutions": [
      "Transaction Speed",
      "Staff Professionalism",
      "Digital Banking Features",
      "Loan Approval Process",
      "Fee Transparency"
    ],
    "Handicraft Stores": [
      "Product Authenticity",
      "Craftsmanship Quality",
      "Pricing Fairness",
      "Store Ambiance",
      "Seller Knowledge"
    ],
    "Tea Retailers": [
      "Tea Freshness",
      "Packaging Appeal",
      "Variety of Blends",
      "Staff Recommendations",
      "Brand Reputation"
    ],
    "Furniture Outlets": [
      "Durability of Products",
      "Customization Options",
      "Delivery & Assembly Service",
      "Price vs. Quality",
      "After-Sales Support"
    ],
    "Designer Boutiques": [
      "Design Uniqueness",
      "Fabric Quality",
      "Fit & Sizing Accuracy",
      "Staff Styling Advice",
      "Luxury Experience"
    ],
    "Art Galleries": [
      "Artwork Authenticity",
      "Curation Quality",
      "Pricing Transparency",
      "Artist Interaction Opportunities",
      "Ambiance & Lighting"
    ],
    "Spice Markets": [
      "Spice Authenticity",
      "Vendor Knowledge",
      "Bargaining Fairness",
      "Cleanliness of Stalls",
      "Freshness of Products"
    ],
    "Antique Shops": [
      "Item Authenticity",
      "Historical Documentation",
      "Pricing Justification",
      "Restoration Services",
      "Staff Expertise"
    ],
    "Supermarkets": [
      "Product Variety",
      "Checkout Speed",
      "Staff Helpfulness",
      "Cleanliness",
      "Loyalty Program Benefits"
    ],
    "Digital Marketing Agencies": [
      "Campaign Effectiveness",
      "Reporting Clarity",
      "Creativity of Content",
      "Communication Responsiveness",
      "ROI Delivered"
    ],
    "Freelancing Platforms": [
      "Job Matching Accuracy",
      "Payment Security",
      "Client Review Authenticity",
      "Platform Fees Fairness",
      "Dispute Resolution"
    ],
    "Social Media Management Services": [
      "Content Engagement Rates",
      "Posting Consistency",
      "Creativity of Strategy",
      "Analytics Reporting",
      "Client Collaboration"
    ],
    "Podcast Production Studios": [
      "Audio Quality",
      "Editing Precision",
      "Host Guidance",
      "Turnaround Time",
      "Equipment Modernity"
    ],
    "Restaurants & Cafés": [
      "Food Taste & Presentation",
      "Hygiene Standards",
      "Service Speed",
      "Ambiance",
      "Value for Money"
    ],
    "Interior Redesign Services": [
      "Space Utilization Creativity",
      "Budget Adherence",
      "Client Consultation Quality",
      "Project Timeliness",
      "Sustainability of Materials"
    ],
    "Dropshipping Businesses": [
      "Product Sourcing Reliability",
      "Shipping Time",
      "Customer Complaint Handling",
      "Profit Margins",
      "Supplier Communication"
    ],
    "Courier Services": [
      "Delivery Timeliness",
      "Parcel Condition",
      "Tracking Accuracy",
      "Customer Support",
      "Pricing Transparency"
    ],
    "Insurance Providers": [
      "Claim Processing Speed",
      "Policy Clarity",
      "Agent Support",
      "Coverage Flexibility",
      "Premium Fairness"
    ],
    "Telecom Services": [
      "Network Reliability",
      "Data Speed",
      "Billing Transparency",
      "Customer Service",
      "Promotional Offers"
    ],
    "TV & Streaming Services": [
      "Content Variety",
      "Streaming Quality",
      "Subscription Pricing",
      "User Interface",
      "Customer Support"
    ],
    "Vehicle Garages": [
      "Repair Durability",
      "Cost Transparency",
      "Mechanic Expertise",
      "Parts Availability",
      "Cleanliness of Facility"
    ],
    "Salons & Beauty Parlors": [
      "Service Hygiene",
      "Staff Skill Level",
      "Product Quality Used",
      "Wait Time Management",
      "Longevity of Results"
    ],
    "Grocery Stores": [
      "Stock Freshness",
      "Pricing Competitiveness",
      "Checkout Efficiency",
      "Staff Friendliness",
      "Ease of Navigation"
    ],
    "Phone & Laptop Retailers": [
      "Product Authenticity (Genuine Brands)",
      "Warranty Clarity",
      "After-Sales Support",
      "Pricing vs. Market Rates",
      "Demo & Testing Facilities"
    ],
    "Furniture Shops": [
      "Assembly Ease",
      "Material Quality",
      "Design Modernity",
      "Delivery Punctuality",
      "Customization Options"
    ],
    "Technical Repair Shops": [
      "Diagnostic Accuracy",
      "Repair Cost Fairness",
      "Replacement Part Quality",
      "Technician Communication",
      "Service Warranty"
    ],
    "Transport Services (Ride-Hailing, Bus/Train)": [
      "Driver/Rider Behavior",
      "Vehicle Cleanliness",
      "Fare Accuracy",
      "Booking App Reliability",
      "Safety Features"
    ],
    "Ayurvedic & Herbal Stores": [
      "Product Purity",
      "Staff Knowledge",
      "Packaging Sustainability",
      "Effectiveness of Remedies",
      "Price vs. Benefits"
    ],
    "Gems & Jewellery Shops": [
      "Gem Certification Authenticity",
      "Design Uniqueness",
      "Pricing Transparency",
      "Customization Services",
      "After-Purchase Cleaning/Polishing"
    ],
    "Bookstores": [
      "Book Variety",
      "Staff Recommendations",
      "Seating/Reading Areas",
      "Event Hosting Quality",
      "Loyalty Discounts"
    ],
    "Floral Shops": [
      "Flower Freshness",
      "Arrangement Creativity",
      "Delivery Timeliness",
      "Pricing Fairness",
      "Seasonal Variety"
    ],
    "Fitness Centers": [
      "Equipment Maintenance",
      "Trainer Expertise",
      "Cleanliness",
      "Class Variety",
      "Membership Value"
    ],
    "Boat-Building Workshops": [
      "Craftsmanship Quality",
      "Material Durability",
      "Project Timeliness",
      "Cost Estimation Accuracy",
      "Custom Design Support"
    ],
    "Coconut Product Exporters": [
      "Product Purity",
      "Eco-Friendly Packaging",
      "Export Documentation Support",
      "Bulk Order Discounts",
      "Supplier Reliability"
    ],
    "3D Printing Studios": [
      "Print Accuracy",
      "Material Options",
      "Turnaround Time",
      "Cost per Project",
      "Design Consultation"
    ],
    "EV Charging Stations": [
      "Charging Speed",
      "Station Availability",
      "Payment Method Flexibility",
      "Safety Standards",
      "App Integration for Reservations"
    ]
  };

  Future<void> fetchReviews(String itemId, String categoryId) async {
    try {
      isLoading(true);
      errorMessage('');

      _repository.getReviewsByItem(itemId).listen((reviewsList) {
        reviews.value = reviewsList;
        isLoading(false);
      }, onError: (e) {
        if (e.toString().contains('index')) {
          _showIndexErrorDialog(e.toString());
        } else {
          errorMessage.value = e.toString();
        }
        isLoading(false);
      });

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

  Future<void> deleteReview(String reviewId) async {
    try {
      isLoading(true);

      // Delete associated replies
      await _replyRepository.deleteRepliesByParentId(reviewId);

      // Delete the review
      await _repository.deleteReview(reviewId);

      // Update local list
      reviews.removeWhere((review) => review.reviewId == reviewId);

      Get.snackbar('Success', 'Review deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete review: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void startEditing(ReviewModel review) {
    ratings.value = Map.from(review.ratings);
  }
}
