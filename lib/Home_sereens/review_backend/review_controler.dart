import 'dart:async'; // Keep this as the only async-related import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../badge_system/badge_model.dart';
import '../badge_system/badge_repository.dart';
import '../item_backend/item_controller.dart';
import '../item_review_summry/item_review_repository.dart';
import '../item_review_summry/item_review_summary_model.dart';
import '../reply_backend/reply_repository.dart';
import '../screen/pending_message.dart';
import 'review_Repository.dart';
import 'review_model.dart';

class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce(this.delay);

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<ItemReviewSummary?> selectedSummary = Rx<ItemReviewSummary?>(null);
  final ReviewRepository _repository = ReviewRepository();
  final RxMap<String, double> ratings = <String, double>{}.obs;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final ReplyRepository _replyRepository = ReplyRepository();
  final RxMap<String, double> averageRatings = <String, double>{}.obs;
  final RxList<String> currentCriteria = <String>[].obs;
  final ItemController _itemController = Get.find<ItemController>();
  final Debounce _debounce = Debounce(const Duration(seconds: 5));
  final RxString currentItemId = ''.obs;
  final _itemrepository = ItemReviewRepository();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString categoryName = ''.obs;
  final RxString itemName = ''.obs;
  final RxBool isVisible = true.obs;
  final RxBool isUpdating = false.obs;
  final RxString updateError = ''.obs;
  final categoryCriteria = {
    "Grocery & Supermarkets": [
      "Product Availability",
      "Price Fairness",
      "Cleanliness",
      "Staff Behavior",
      "Waiting Time"
    ],
    "Restaurants & Cafés": [
      "Taste & Quality",
      "Customer Service",
      "Cleanliness",
      "Delivery Speed",
      "Value for Money"
    ],
    "Pharmacies & Medical Stores": [
      "Medicine Availability",
      "Staff Knowledge",
      "Price Fairness",
      "Waiting Time",
      "Customer Service"
    ],
    "Hospitals & Clinics": [
      "Doctor’s Attention",
      "Cleanliness",
      "Waiting Time",
      "Staff Behavior",
      "Treatment Effectiveness"
    ],
    "Mobile Phone & Accessories Shops": [
      "Product Quality",
      "Customer Service",
      "Warranty Support",
      "Price Fairness",
      "Technical Knowledge"
    ],
    "Electronics & Appliance Stores": [
      "Product Durability",
      "Installation Support",
      "Price Fairness",
      "Customer Service",
      "Warranty Claim Process"
    ],
    "Clothing & Fashion Stores": [
      "Product Quality",
      "Staff Behavior",
      "Changing Room Hygiene",
      "Availability of Sizes",
      "Price-Value Ratio"
    ],
    "Online Shops & Delivery Services": [
      "Delivery Speed",
      "Product Match with Ad",
      "Return/Refund Process",
      "Customer Communication",
      "Packaging Quality"
    ],
    "Hardware & Building Materials": [
      "Material Quality",
      "Stock Availability",
      "Delivery Timeliness",
      "Price Competitiveness",
      "Technical Advice"
    ],
    "Beauty Salons & Barbers": [
      "Cleanliness",
      "Staff Friendliness",
      "Service Quality",
      "Waiting Time",
      "Value for Money"
    ],
    "Vehicle Repair & Service Centres": [
      "Repair Quality",
      "Cost Transparency",
      "Service Speed",
      "Customer Communication",
      "Warranty Provided"
    ],
    "Computer & Laptop Shops": [
      "Product Quality",
      "Customer Service",
      "After-Sales Support",
      "Technical Expertise",
      "Price Transparency"
    ],
    "Tuition Classes & Education Institutes": [
      "Teaching Quality",
      "Material Availability",
      "Time Management",
      "Student Support",
      "Facility Cleanliness"
    ],
    "Courier & Delivery Services": [
      "Delivery Time",
      "Item Safety",
      "Customer Communication",
      "Tracking Accuracy",
      "Service Cost"
    ],
    "Furniture & Homeware Stores": [
      "Product Quality",
      "Delivery Punctuality",
      "Assembly Support",
      "Warranty Support",
      "Price-Value Ratio"
    ],
    "Fitness Centres & Gyms": [
      "Equipment Condition",
      "Cleanliness",
      "Trainer Support",
      "Operating Hours",
      "Pricing Structure"
    ],
    "Event Planning & Wedding Services": [
      "Service Coordination",
      "Staff Friendliness",
      "On-Time Execution",
      "Value for Money",
      "Flexibility"
    ],
    "Repair Services (TV, Fridge, AC)": [
      "Repair Quality",
      "Response Time",
      "Parts Used",
      "Cost Transparency",
      "Communication"
    ],
    "Taxi & Ride-Hailing Services": [
      "Driver Behavior",
      "Arrival Time",
      "Fare Transparency",
      "Vehicle Cleanliness",
      "Trip Safety"
    ],
    "Pet Shops & Veterinary Clinics": [
      "Product/Medicine Availability",
      "Veterinarian Expertise",
      "Cleanliness",
      "Customer Service",
      "Pricing"
    ],
    "Home Cleaning & Maintenance": [
      "Cleaning Quality",
      "Time Accuracy",
      "Professionalism",
      "Chemical Safety",
      "Cost Effectiveness"
    ],
    "Divisional Secretariats": [
      "Staff Helpfulness",
      "Document Process Speed",
      "Cleanliness",
      "Communication",
      "Fair Treatment"
    ],
    "Municipal Councils": [
      "Waste Management Service",
      "Permit Process Time",
      "Staff Cooperation",
      "Cleanliness",
      "Responsiveness"
    ],
    "Police Stations": [
      "Responsiveness",
      "Fairness in Treatment",
      "Staff Attitude",
      "Waiting Time",
      "Communication"
    ],
    "Public Transport Services": [
      "Punctuality",
      "Cleanliness",
      "Staff Behavior",
      "Comfort Level",
      "Fare Reasonability"
    ],
    "Postal Services": [
      "Delivery Speed",
      "Item Safety",
      "Staff Helpfulness",
      "Queue Management",
      "Communication"
    ],
    "Banks & Financial Institutions": [
      "Service Speed",
      "Staff Friendliness",
      "Mobile/Online Banking",
      "Queue System",
      "Transparency"
    ],
    "Schools & Universities": [
      "Teaching Quality",
      "Staff Support",
      "Cleanliness",
      "Discipline System",
      "Facilities"
    ],
    "Water Board / CEB / Telecom": [
      "Issue Resolution Time",
      "Bill Accuracy",
      "Staff Behavior",
      "Accessibility",
      "Complaint Handling"
    ],
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
    ]
  };

  Future<void> fetchReviews(String itemId, String categoryId) async {
    try {
      if (currentItemId.value == itemId) return;
      currentItemId.value = itemId;

      isLoading(true);
      errorMessage.value = '';

      // 1. Load summary (no error if null)
      selectedSummary.value = await _itemrepository.getSummaryByItem(itemId);

      // 2. Get names
      categoryName.value = await _repository.getCategoryName(categoryId);
      itemName.value = await _repository.getItemName(itemId);

      // 3. Get criteria using ID first, then name
      currentCriteria.value = categoryCriteria[categoryId] ??
          categoryCriteria[categoryName.value] ??
          [];

      // 4. Setup single stream
      reviews.bindStream(_repository.getReviewsByItem(itemId).handleError((e) {
        errorMessage.value = e.toString();
        if (e.toString().contains('index')) {
          _showIndexErrorDialog(e.toString());
        }
      }));

      print('Fetched ${reviews.length} reviews for $itemId');
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

/////////////////////////////////
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

// Add to ReviewController
  // review_controller.dart (partial update)
  // review_controller.dart (updated)
  Future<Map<String, dynamic>> calculateReviewMetrics(String itemId) async {
    try {
      // Get all reviews for the item
      final reviews = await _firestore
          .collection('reviews')
          .where('itemId', isEqualTo: itemId)
          .get();

      // Get latest review per user
      final userReviews = <String, ReviewModel>{};
      for (final doc in reviews.docs) {
        final review = ReviewModel.fromSnapshot(doc);
        final existing = userReviews[review.userId];
        if (existing == null ||
            review.timestamp.compareTo(existing.timestamp) > 0) {
          userReviews[review.userId] = review;
        }
      }

      // Get item and category data
      final item = await _itemController.getItemById(itemId);
      final category =
          await _firestore.collection('categories').doc(item.categoryId).get();

      // Validate category exists
      if (!category.exists) {
        throw 'Associated category not found';
      }

      // Get category data and criteria
      final categoryData = category.data()!;
      final criteria = _getCriteriaForCategory(item.categoryId, categoryData);

      // Calculate review points
      final reviewPoints = <String, double>{};
      for (final criterion in criteria) {
        double total = 0.0;
        int count = 0;

        for (var review in userReviews.values) {
          final rating = review.ratings[criterion];
          if (rating != null) {
            total += rating;
            count++;
          }
        }

        reviewPoints[criterion] = count > 0 ? (total / count) : 0.0;
      }

      return {
        'quinceUsersCount': userReviews.length,
        'reviewPoints': reviewPoints,
        'totalReviews': reviews.docs.length,
      };
    } catch (e) {
      Get.log('Review metric calculation error: $e');
      throw 'Calculation failed: ${e.toString()}';
    }
  }

  List<String> _getCriteriaForCategory(
      String categoryId, Map<String, dynamic> categoryData) {
    // First check local categoryCriteriaa by category ID
    if (categoryCriteriaa.containsKey(categoryId)) {
      return categoryCriteriaa[categoryId]!;
    }

    // Then check Firestore's 'criteria' field
    if (categoryData.containsKey('criteria')) {
      return List<String>.from(categoryData['criteria']);
    }

    // Fallback to category name in categoryCriteriaa
    final categoryName = categoryData['name'] as String;
    if (categoryCriteriaa.containsKey(categoryName)) {
      return categoryCriteriaa[categoryName]!;
    }

    throw 'No criteria found for category $categoryId ($categoryName)';
  }

  final categoryCriteriaa = {
    // Using category IDs as keys
    // Mobile Repair Services
    "0001": [
      "Repair Quality",
      "Turnaround Time",
      "Technician Expertise",
      "Cost Transparency",
      "Warranty on Repairs"
    ],

    // Spice Packaging & Export Shops
    "0002": [
      "Product Freshness",
      "Packaging Quality",
      "Pricing Competitiveness",
      "Shipping Reliability",
      "Customer Service"
    ],

    // Tuk-Tuk Rental Services
    "0005": [
      "Vehicle Condition",
      "Rental Pricing Transparency",
      "Customer Support",
      "Availability of Vehicles",
      "Safety Features"
    ],

    // Sustainable Eco-Tourism Agencies
    "0006": [
      "Guide Knowledge",
      "Eco-Friendliness of Activities",
      "Itinerary Satisfaction",
      "Safety Measures",
      "Value for Money"
    ],

    // Online Tutoring Platforms
    "0007": [
      "Tutor Expertise",
      "Platform Usability",
      "Session Flexibility",
      "Course Relevance",
      "Technical Support"
    ],

    // E-Commerce Stores (Handicrafts, Apparel, Electronics)
    "0008": [
      "Website/App Usability",
      "Delivery Speed",
      "Product Accuracy (vs. Description)",
      "Return/Refund Process",
      "Payment Security"
    ],

    // Customized Travel Planners
    "0009": [
      "Personalization of Itinerary",
      "Communication Responsiveness",
      "Budget Adherence",
      "Local Experience Quality",
      "Emergency Support"
    ],

    // Agriculture Tech Providers
    "0010": [
      "IoT Device Reliability",
      "Technical Support",
      "Value for Money",
      "Training Provided",
      "Impact on Farm Yield"
    ],

    // Banks & Financial Institutions
    "0011": [
      "Transaction Speed",
      "Staff Professionalism",
      "Digital Banking Features",
      "Loan Approval Process",
      "Fee Transparency"
    ],

    // Handicraft Stores
    "0012": [
      "Product Authenticity",
      "Craftsmanship Quality",
      "Pricing Fairness",
      "Store Ambiance",
      "Seller Knowledge"
    ],

    // Tea Retailers
    "0013": [
      "Tea Freshness",
      "Packaging Appeal",
      "Variety of Blends",
      "Staff Recommendations",
      "Brand Reputation"
    ],

    // Furniture Outlets
    "0014": [
      "Durability of Products",
      "Customization Options",
      "Delivery & Assembly Service",
      "Price vs. Quality",
      "After-Sales Support"
    ],

    // Designer Boutiques
    "0015": [
      "Design Uniqueness",
      "Fabric Quality",
      "Fit & Sizing Accuracy",
      "Staff Styling Advice",
      "Luxury Experience"
    ],

    // Art Galleries
    "0016": [
      "Artwork Authenticity",
      "Curation Quality",
      "Pricing Transparency",
      "Artist Interaction Opportunities",
      "Ambiance & Lighting"
    ],

    // Spice Markets
    "0017": [
      "Spice Authenticity",
      "Vendor Knowledge",
      "Bargaining Fairness",
      "Cleanliness of Stalls",
      "Freshness of Products"
    ],

    // Antique Shops
    "0018": [
      "Item Authenticity",
      "Historical Documentation",
      "Pricing Justification",
      "Restoration Services",
      "Staff Expertise"
    ],

    // Supermarkets
    "0019": [
      "Product Variety",
      "Checkout Speed",
      "Staff Helpfulness",
      "Cleanliness",
      "Loyalty Program Benefits"
    ],

    // Digital Marketing Agencies
    "0020": [
      "Campaign Effectiveness",
      "Reporting Clarity",
      "Creativity of Content",
      "Communication Responsiveness",
      "ROI Delivered"
    ],

    // Freelancing Platforms
    "0021": [
      "Job Matching Accuracy",
      "Payment Security",
      "Client Review Authenticity",
      "Platform Fees Fairness",
      "Dispute Resolution"
    ],

    // Social Media Management Services
    "0022": [
      "Content Engagement Rates",
      "Posting Consistency",
      "Creativity of Strategy",
      "Analytics Reporting",
      "Client Collaboration"
    ],

    // Podcast Production Studios
    "0023": [
      "Audio Quality",
      "Editing Precision",
      "Host Guidance",
      "Turnaround Time",
      "Equipment Modernity"
    ],

    // Restaurants & Cafés
    "0024": [
      "Food Taste & Presentation",
      "Hygiene Standards",
      "Service Speed",
      "Ambiance",
      "Value for Money"
    ],

    // Interior Redesign Services
    "0025": [
      "Space Utilization Creativity",
      "Budget Adherence",
      "Client Consultation Quality",
      "Project Timeliness",
      "Sustainability of Materials"
    ],

    // Dropshipping Businesses
    "0026": [
      "Product Sourcing Reliability",
      "Shipping Time",
      "Customer Complaint Handling",
      "Profit Margins",
      "Supplier Communication"
    ],

    // Courier Services
    "0027": [
      "Delivery Timeliness",
      "Parcel Condition",
      "Tracking Accuracy",
      "Customer Support",
      "Pricing Transparency"
    ],

    // Insurance Providers
    "0028": [
      "Claim Processing Speed",
      "Policy Clarity",
      "Agent Support",
      "Coverage Flexibility",
      "Premium Fairness"
    ],

    // Telecom Services
    "0029": [
      "Network Reliability",
      "Data Speed",
      "Billing Transparency",
      "Customer Service",
      "Promotional Offers"
    ],

    // TV & Streaming Services
    "0030": [
      "Content Variety",
      "Streaming Quality",
      "Subscription Pricing",
      "User Interface",
      "Customer Support"
    ],

    // Vehicle Garages
    "0031": [
      "Repair Durability",
      "Cost Transparency",
      "Mechanic Expertise",
      "Parts Availability",
      "Cleanliness of Facility"
    ],

    // Salons & Beauty Parlors
    "0032": [
      "Service Hygiene",
      "Staff Skill Level",
      "Product Quality Used",
      "Wait Time Management",
      "Longevity of Results"
    ],

    // Grocery Stores
    "0033": [
      "Stock Freshness",
      "Pricing Competitiveness",
      "Checkout Efficiency",
      "Staff Friendliness",
      "Ease of Navigation"
    ],

    // Phone & Laptop Retailers
    "0034": [
      "Product Authenticity (Genuine Brands)",
      "Warranty Clarity",
      "After-Sales Support",
      "Pricing vs. Market Rates",
      "Demo & Testing Facilities"
    ],

    // Furniture Shops
    "0035": [
      "Assembly Ease",
      "Material Quality",
      "Design Modernity",
      "Delivery Punctuality",
      "Customization Options"
    ],

    // Technical Repair Shops
    "0036": [
      "Diagnostic Accuracy",
      "Repair Cost Fairness",
      "Replacement Part Quality",
      "Technician Communication",
      "Service Warranty"
    ],

    // Transport Services (Ride-Hailing, Bus/Train)
    "0037": [
      "Driver/Rider Behavior",
      "Vehicle Cleanliness",
      "Fare Accuracy",
      "Booking App Reliability",
      "Safety Features"
    ],

    // Ayurvedic & Herbal Stores
    "0038": [
      "Product Purity",
      "Staff Knowledge",
      "Packaging Sustainability",
      "Effectiveness of Remedies",
      "Price vs. Benefits"
    ],

    // Gems & Jewellery Shops
    "0039": [
      "Gem Certification Authenticity",
      "Design Uniqueness",
      "Pricing Transparency",
      "Customization Services",
      "After-Purchase Cleaning/Polishing"
    ],

    // Bookstores
    "0040": [
      "Book Variety",
      "Staff Recommendations",
      "Seating/Reading Areas",
      "Event Hosting Quality",
      "Loyalty Discounts"
    ],

    // Floral Shops
    "0041": [
      "Flower Freshness",
      "Arrangement Creativity",
      "Delivery Timeliness",
      "Pricing Fairness",
      "Seasonal Variety"
    ],

    // Fitness Centers
    "0042": [
      "Equipment Maintenance",
      "Trainer Expertise",
      "Cleanliness",
      "Class Variety",
      "Membership Value"
    ],

    // Boat-Building Workshops
    "0043": [
      "Craftsmanship Quality",
      "Material Durability",
      "Project Timeliness",
      "Cost Estimation Accuracy",
      "Custom Design Support"
    ],

    // Coconut Product Exporters
    "0044": [
      "Product Purity",
      "Eco-Friendly Packaging",
      "Export Documentation Support",
      "Bulk Order Discounts",
      "Supplier Reliability"
    ],

    // 3D Printing Studios
    "0045": [
      "Print Accuracy",
      "Material Options",
      "Turnaround Time",
      "Cost per Project",
      "Design Consultation"
    ],

    // EV Charging Stations
    "0046": [
      "Charging Speed",
      "Station Availability",
      "Payment Method Flexibility",
      "Safety Standards",
      "App Integration for Reservations"
    ]
  };

  Future<void> updateItemReviewSummary(String itemId) async {
    try {
      final metrics = await calculateReviewMetrics(itemId);
      final item = await _itemController.getItemById(itemId);

      final summary = ItemReviewSummary(
        itemId: itemId,
        itemName: item.name,
        categoryId: item.categoryId,
        quinceUsersCount: metrics['quinceUsersCount'] as int,
        reviewPoints: metrics['reviewPoints'] as Map<String, double>,
        lastUpdated: DateTime.now(),
      );

      await ItemReviewRepository().createOrUpdateSummary(summary);

      // Create/Update Badge
      final badge = Badge_item(
        itemId: itemId,
        itemName: item.name,
        categoryId: item.categoryId,
        mapLocation: item.mapLocation,
        quinceUsersCount: metrics['quinceUsersCount'] as int,
        totalReviews: metrics['totalReviews'] as int,
        reviewPoints: metrics['reviewPoints'] as Map<String, double>,
        badReviewPercentage: 0.0,
        lastUpdated: DateTime.now(),
      );
      await BadgeRepository().createOrUpdateBadge(badge);
    } catch (e) {
      Get.log('Failed to update summary for $itemId: $e');
      Get.snackbar(
          'Update Failed', 'Could not calculate metrics: ${e.toString()}');
      rethrow;
    }
  }
}
