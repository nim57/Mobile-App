import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:echo_project_123/User_profile/widgets/change_name.dart';
import 'package:echo_project_123/User_profile/widgets/profile_menu.dart';
import 'package:echo_project_123/Utils/constants/image_Strings.dart';
import 'package:echo_project_123/Utils/constants/sizes.dart';
import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:echo_project_123/common/widgets/appbar/appbar.dart';
import 'package:echo_project_123/Home_sereens/widgets/shimmer.dart';
import 'package:echo_project_123/User_profile/widgets/Section_heading.dart';
import 'package:echo_project_123/User_profile/widgets/i_circularImage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

import '../category_backend/category_controller.dart';
import '../category_backend/category_model.dart';
import '../item_backend/item_controller.dart';
import '../item_backend/item_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  bool _locationEnabled = false;
  final TextEditingController _searchController = TextEditingController();
  final List<MapCategory> _categories = [];
  final UserController userController = UserController.instonce;
  final CategoryController categoryController = Get.put(CategoryController());
  final ItemController itemController = Get.put(ItemController());
  Set<Marker> _markers = {};
  BitmapDescriptor? _customMarkerIcon;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _setupControllerListeners();
    _checkLocationStatus();
    _createCustomMarker();
    categoryController.fetchAllCategories();
  }


  void _createCustomMarker() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/red_user_marker.png', // Add your custom marker asset
    );
    setState(() {
      _customMarkerIcon = icon;
    });
  }

  void _setupControllerListeners() {
    // Handle errors in profile image loading
    ever(userController.imageUploading, (isUploading) {
      if (isUploading) {
        // Show loading indicator if needed
      }
    });

    ever(userController.user, (user) {
      if (user.profilePicture.isEmpty) {
        // Handle case when no profile picture exists
        debugPrint('No profile picture available');
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _checkLocationStatus() async {
    try {
      _locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (_locationEnabled) {
        await _getCurrentLocation();
      }
    } catch (e) {
      Get.snackbar(
          'Location Error', 'Failed to check location status: ${e.toString()}');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      final status = await Permission.location.status;
      if (status.isDenied) {
        await Permission.location.request();
      }
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _locationEnabled = true;
      });

      // Move camera to current position
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.4746,
        ),
      );
    } on LocationServiceDisabledException {
      _showLocationEnableDialog();
    } catch (e) {
      Get.snackbar('Location Error', 'Failed to get location: ${e.toString()}');
    }
  }

  void _showLocationEnableDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Location Services Disabled'),
        content: Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
              await _checkLocationStatus();
            },
            child: Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _findMyLocation() async {
    try {
      if (!_locationEnabled) {
        _showLocationEnableDialog();
        return;
      }

      if (_currentPosition == null) {
        await _getCurrentLocation();
        return;
      }
      _moveCameraToPosition(_currentPosition!);

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14.4746,
        ),
      );
    } catch (e) {
      Get.snackbar(
          'Location Error', 'Failed to update location: ${e.toString()}');
    }
  }

  void _updateMarkers(Position position) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(0),
      infoWindow: const InfoWindow(title: 'Your Location'),
    );

    setState(() {
      _currentPosition = position;
      _locationEnabled = true;
      _markers = {marker};
    });
  }

  void _moveCameraToPosition(Position position) {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        14.4746,
      ),
    );
  }

  Future<void> _handleCategorySelection(String categoryId) async {
    try {
      _selectedCategoryId = categoryId;
      await itemController.fetchItemsByCategory(categoryId);
      _updateMapMarkers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load items: ${e.toString()}');
    }
  }
  void _updateMapMarkers() {
    final newMarkers = <Marker>{};
    
    for (final item in itemController.items) {
      try {
        final position = _parseMapLocation(item.mapLocation);
        final marker = Marker(
          markerId: MarkerId(item.id),
          position: position,
          icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: item.name,
            snippet: item.description,
            onTap: () => _showItemDetails(item),
          ),
        );
        newMarkers.add(marker);
      } catch (e) {
        print('Error creating marker for item ${item.id}: $e');
      }
    }

    setState(() => _markers = newMarkers);
    _adjustCameraToMarkers();
  }

   LatLng _parseMapLocation(String locationUrl) {
    try {
      // Example URL format: https://maps.google.com/?q=37.422,-122.084
      final uri = Uri.parse(locationUrl);
      final query = uri.queryParameters['q']?.split(',') ?? [];
      if (query.length != 2) throw FormatException('Invalid location format');
      
      final lat = double.parse(query[0]);
      final lng = double.parse(query[1]);
      return LatLng(lat, lng);
    } catch (e) {
      throw FormatException('Invalid map location: ${e.toString()}');
    }
  }

  void _adjustCameraToMarkers() {
    if (_markers.isEmpty) return;

    final bounds = _calculateBounds();
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );
  }

  LatLngBounds _calculateBounds() {
    var southwest = const LatLng(double.maxFinite, double.maxFinite);
    var northeast = const LatLng(double.minPositive, double.minPositive);

    for (final marker in _markers) {
      southwest = LatLng(
        math.min(southwest.latitude, marker.position.latitude),
        math.min(southwest.longitude, marker.position.longitude),
      );
      northeast = LatLng(
        math.max(northeast.latitude, marker.position.latitude),
        math.max(northeast.longitude, marker.position.longitude),
      );
    }

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  void _showItemDetails(Item item) {
    Get.toNamed('/item-details', arguments: item.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Layer (Background)
          SizedBox.expand(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 14.4746,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),

          // Top Layer (Search Bar and Categories)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Categories Section
                _buildCategoriesSection(),
              ],
            ),
          ),

          // Find Me Button
          Positioned(
            right: 10,
            bottom: 106,
            child: FloatingActionButton(
              onPressed: _findMyLocation,
              backgroundColor: Colors.white,
              tooltip: 'Find My Location',
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Obx(() {
      if (categoryController.categoryLoading.value) {
        return _buildCategoryShimmer();
      }

      if (categoryController.categories.isEmpty) {
        return _buildNoCategoriesFound();
      }

      return _buildCategoryList();
    });
  }

  Widget _buildCategoryShimmer() {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          width: 100,
          margin: const EdgeInsets.only(right: 8),
          child: const EShimmerEffect(width: 80, height: 80, radius: 8),
        ),
      ),
    );
  }

  Widget _buildNoCategoriesFound() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: const Text(
        'No categories found',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryController.categories.length,
        itemBuilder: (context, index) {
          final category = categoryController.categories[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryImage(category),
                const SizedBox(height: 4),
                _buildCategoryName(category.name),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryImage(Category category) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        category.log.isNotEmpty ? category.log : EImages.user1,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 40),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          );
        },
      ),
    );
  }

  Widget _buildCategoryName(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildItemsLoadingIndicator() {
    return Obx(() {
      if (itemController.itemLoading.value) {
        return const Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildItemMarkers() {
    return Obx(() {
      if (itemController.errorMessage.value.isNotEmpty) {
        return Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              itemController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}

class MapCategory {
  final IconData icon;
  final String name;

  MapCategory(this.icon, this.name);
}
