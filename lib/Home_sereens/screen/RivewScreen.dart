// screens/review_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../review_backend/review_controler.dart';
import '../widgets/CustomRatingBar.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.categoryId,
    required this.itemId,
  });

  final String categoryId;
  final String itemId;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewController controller = Get.put(ReviewController());
  final UserController _userController =
      Get.put(UserController()); // Add user controller
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  late String categoryName;
  late String itemName;
  bool _isLoading = true;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      categoryName = await controller.getCategoryName(widget.categoryId);
      itemName = await controller.getItemName(widget.itemId);

      if (!controller.categoryCriteria.containsKey(categoryName)) {
        throw Exception('Invalid category');
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isValid = false);
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) return const SizedBox.shrink();

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Write Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$categoryName  $itemName',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),

              // Dynamic Rating Bars
              Column(
                children: controller.categoryCriteria[categoryName]!
                    .map(
                      (criterion) => Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CustomRatingBar(
                            title: criterion,
                            rating: controller.ratings[criterion] ?? 0,
                            onRatingChanged: (rating) =>
                                controller.updateRating(criterion, rating),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // Form elements
              TextFormField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Review Title',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => SwitchListTile(
                  title: const Text('Visible to Public'),
                  value: controller.isVisible.value,
                  onChanged: (value) => controller.isVisible.value = value,
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.submitReview(
                    categoryId: widget.categoryId,
                    itemId: widget.itemId,
                    tags: tagsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                    title: titleController.text,
                    comment: commentController.text,
                    userId: _userController.user.value.id,
                    username: _userController.user.value.username,
                    userProfile: _userController.user.value.profilePicture,
                  ),
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
