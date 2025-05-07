import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../branch_pending/branch_controller.dart';
import '../pending_backend/map_picker.dart';
import '../pending_backend/pending_controllers.dart';

class AddBranchItem extends StatefulWidget {
  const AddBranchItem({super.key});

  @override
  State<AddBranchItem> createState() => _AddBranchItemState();
}

class _AddBranchItemState extends State<AddBranchItem> {

  final UserController _userController = Get.put(UserController());
  final PendingController _pendingController = Get.put(PendingController());
  final BranchController _branchController = Get.put(BranchController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedMainItemId;

  @override
  void initState() {
    super.initState();
    _userEmailController.text = _userController.user.value.email;
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      await _branchController.uploadImage(file);
    }
  }

  Future<void> _getLocation() async {
    final location = await Get.to(() => const MapPickerScreen());
    if (location != null) {
      _locationController.text = location;
      _branchController.updateMapLocation(location);
    }
  }

  Future<void> _submitForm() async {
    if (_selectedCategoryId == null || _selectedMainItemId == null) {
      Get.snackbar('Error', 'Please select category and main item');
      return;
    }

    await _branchController.submitBranch(
      categoryId: _selectedCategoryId!,
      mainItemId: _selectedMainItemId!,
      name: _nameController.text,
      tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
      description: _descController.text,
      email: _emailController.text,
      website: _websiteController.text,
      phone: _phoneController.text,
    );
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Branch Item"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_branchController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _branchController.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategoryId = newValue;
                    _selectedMainItemId = null;
                    _branchController.fetchMainItems(newValue!);
                  });
                },
              ),
              const SizedBox(height: 20),

              // Main Item Dropdown
              DropdownButtonFormField<String>(
                value: _selectedMainItemId,
                decoration: InputDecoration(
                  labelText: 'Main Item',
                  prefixIcon: const Icon(Icons.business),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _branchController.mainItems.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'],
                    child: Text(item['name']),
                  );
                }).toList(),
                onChanged: _selectedCategoryId == null 
                    ? null
                    : (newValue) {
                        setState(() {
                          _selectedMainItemId = newValue;
                        });
                      },
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Branch Name',
                  hintText: 'ABC Company Athurugiriya',
                  prefixIcon: const Icon(Iconsax.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                ),
              ),
              ),
              const SizedBox(height: 20),

              // Tags Field
              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  prefixIcon: const Icon(Iconsax.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description Field
              TextFormField(
                controller: _descController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Contact Info Section
              _buildContactInfoSection(),
              const SizedBox(height: 20),

              // Map Location
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Map Location',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Choose Location'),
                    onPressed: _getLocation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Image Upload Section
              _buildImageUploadSection(),
              const SizedBox(height: 20),
            

              // Date Field
              TextFormField(
                readOnly: true,
                initialValue:
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

// User Email Field
              TextFormField(
                controller: _userEmailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Request Branch',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _websiteController,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: 'Website',
            prefixIcon: const Icon(Icons.web),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Mobile Number',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickMedia,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(() => _pendingController.imageUrl.isNotEmpty
                ? Image.network(
                    _pendingController.imageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, size: 50),
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 40),
                        SizedBox(height: 10),
                        Text('Tap to upload image'),
                      ],
                    ),
                  )),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => _pendingController.imageUrl.isNotEmpty
            ? Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _pendingController.clearImage(),
                  child: const Text('Clear Image'),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}
