import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:echo_project_123/Utils/constants/image_Strings.dart';
import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:echo_project_123/common/widgets/appbar/appbar.dart';
import 'package:echo_project_123/Home_sereens/widgets/shimmer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

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
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final UserController _userController = UserController.instonce;
  final CategoryController _categoryController = Get.put(CategoryController());
  final ItemController _itemController = Get.put(ItemController());

  Position? _currentPosition;
  bool _locationEnabled = false;
  bool _isMapReady = false;
  Set<Marker> _markers = {};
  BitmapDescriptor? _customMarkerIcon;
  String? _selectedCategoryId;
  Timer? _searchDebounce;
  DateTime _lastCameraUpdate = DateTime.now();
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _loadCustomMarkerIcon();
    _setupListeners();
    await _checkLocationStatus();
    await _categoryController.fetchAllCategories();
  }

  Future<void> _loadCustomMarkerIcon() async {
    try {
      final ByteData data = await rootBundle.load(EImages.Animal1);
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      final Uint8List resizedBytes = Uint8List.fromList(
          img.encodePng(img.copyResize(image, width: 96, height: 96)));

      if (mounted) {
        setState(() {
          _customMarkerIcon = BitmapDescriptor.fromBytes(resizedBytes);
        });
      }
    } catch (e) {
      debugPrint('Error loading custom marker: $e');
      if (mounted) {
        setState(() {
          _customMarkerIcon =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        });
      }
    }
  }

  void _setupListeners() {
    _subscriptions.addAll([
      _userController.imageUploading.listen((isUploading) {},
          onError: (e) => debugPrint('Image upload error: $e')),
      _itemController.items.listen((_) {
        if (_isMapReady) _updateMapMarkers();
      }, onError: (e) => debugPrint('Items stream error: $e')),
    ]);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  Future<void> _checkLocationStatus() async {
    try {
      _locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (_locationEnabled) await _getCurrentLocation();
    } catch (e) {
      _showErrorSnackbar('Location Error', 'Failed to check location status');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final status = await Permission.location.status;
      if (status.isDenied) await Permission.location.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _locationEnabled = true;
        });
      }

      _moveCameraToPosition(position);
    } on LocationServiceDisabledException {
      _showLocationEnableDialog();
    } catch (e) {
      _showErrorSnackbar('Location Error', 'Failed to get current location');
    }
  }

  void _showLocationEnableDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Services Disabled'),
        content:
            const Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
              await _checkLocationStatus();
            },
            child: const Text('Enable'),
          ),
        ],
      ),
      barrierDismissible: false,
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
      }
      _moveCameraToPosition(_currentPosition!);
    } catch (e) {
      _showErrorSnackbar('Location Error', 'Failed to find location');
    }
  }

  void _moveCameraToPosition(Position position) {
    if (!_isMapReady || _mapController == null) return;
    if (DateTime.now().difference(_lastCameraUpdate).inMilliseconds < 500)
      return;

    _lastCameraUpdate = DateTime.now();
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        14.0,
      ),
    );
  }

  Future<void> _handleCategorySelection(String categoryId) async {
    try {
      _selectedCategoryId = categoryId;
      await _itemController.fetchItemsByCategory(categoryId);
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to load items');
    }
  }

  void _updateMapMarkers() {
    if (!_isMapReady || _customMarkerIcon == null) return;

    final newMarkers = <Marker>{};
    final items = _itemController.items
        .where((item) => item.mapLocation.isNotEmpty)
        .take(100)
        .toList();

    for (final item in items) {
      try {
        final position = _parseMapLocation(item.mapLocation);
        final marker = Marker(
          markerId: MarkerId(item.id),
          position: position,
          icon: _customMarkerIcon!,
          infoWindow: InfoWindow(
            title: item.name,
            snippet: item.description,
          ),
          onTap: () => _showItemDetails(item),
          anchor: const Offset(0.5, 1.0),
        );
        newMarkers.add(marker);
      } catch (e) {
        debugPrint('Skipping invalid location for item ${item.id}: $e');
      }
    }

    if (mounted) {
      setState(() => _markers = newMarkers);
    }

    if (_markers.isNotEmpty) _adjustCameraToMarkers();
  }

  LatLng _parseMapLocation(String location) {
    try {
      if (location.startsWith('http')) {
        final uri = Uri.parse(location);
        final query = uri.queryParameters['q'] ?? '';
        final coords = query.split(',').take(2).toList();
        if (coords.length != 2)
          throw const FormatException('Invalid URL coordinates');
        return LatLng(
          double.parse(coords[0].trim()),
          double.parse(coords[1].trim()),
        );
      }

      final coords = location.split(',').take(2).toList();
      if (coords.length != 2)
        throw const FormatException('Invalid coordinate format');
      return LatLng(
        double.parse(coords[0].trim()),
        double.parse(coords[1].trim()),
      );
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Failed to parse location: $e');
    }
  }

  void _adjustCameraToMarkers() {
    if (_markers.isEmpty || _mapController == null) return;

    try {
      final bounds = _markers.fold<LatLngBounds?>(
        null,
        (previous, marker) {
          if (previous == null) {
            return LatLngBounds(
                southwest: marker.position, northeast: marker.position);
          }
          final southwest = LatLng(
            math.min(previous.southwest.latitude, marker.position.latitude),
            math.min(previous.southwest.longitude, marker.position.longitude),
          );
          final northeast = LatLng(
            math.max(previous.northeast.latitude, marker.position.latitude),
            math.max(previous.northeast.longitude, marker.position.longitude),
          );
          return LatLngBounds(southwest: southwest, northeast: northeast);
        },
      );

      if (bounds != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_mapController != null && mounted) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 100.0),
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error adjusting camera: $e');
    }
  }

  void _showItemDetails(Item item) {
    Get.toNamed('/item-details', arguments: item.id);
  }

  void _showErrorSnackbar(String title, String message) {
    if (!mounted) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _isMapReady = true;
                if (_itemController.items.isNotEmpty) _updateMapMarkers();
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              minMaxZoomPreference: const MinMaxZoomPreference(10, 18),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  _buildCategoriesSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 100,
              child: FloatingActionButton(
                onPressed: _findMyLocation,
                mini: true,
                backgroundColor: Colors.white,
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Obx(() {
      if (_categoryController.categoryLoading.value)
        return _buildCategoryShimmer();
      if (_categoryController.categories.isEmpty)
        return _buildNoCategoriesFound();
      return _buildCategoryList();
    });
  }

  Widget _buildCategoryShimmer() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: EShimmerEffect(width: 80, height: 60, radius: 8),
        ),
      ),
    );
  }

  Widget _buildNoCategoriesFound() {
    return const SizedBox(
      height: 60,
      child: Center(
        child:
            Text('No categories found', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categoryController.categories.length,
        itemBuilder: (context, index) =>
            _buildCategoryItem(_categoryController.categories[index]),
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () => _handleCategorySelection(category.id),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
      ),
    );
  }

  Widget _buildCategoryImage(Category category) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        category.log.isNotEmpty ? category.log : EImages.user1,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 32),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 32,
            height: 32,
            child: Center(child: CircularProgressIndicator()),
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
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
