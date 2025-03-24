import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  final String initialLocationUrl;

  const MapPickerScreen(
      {super.key,
      this.initialLocationUrl =
          'https://maps.google.com/?q=6.9271,79.8612' // Colombo default
      });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController mapController;
  LatLng? _selectedPosition;
  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = _getInitialCameraPosition();
  }

  CameraPosition _getInitialCameraPosition() {
    // Parse existing location URL or use Colombo default
    try {
      final uri = Uri.parse(widget.initialLocationUrl);
      final query = uri.queryParameters['q'] ?? '';
      final coords = query.split(',');

      if (coords.length == 2) {
        final lat = double.parse(coords[0]);
        final lng = double.parse(coords[1]);
        _selectedPosition = LatLng(lat, lng);
        return CameraPosition(target: _selectedPosition!, zoom: 14);
      }
    } catch (e) {
      print('Error parsing initial location: $e');
    }

    // Default Colombo coordinates
    return const CameraPosition(
      target: LatLng(6.9271, 79.8612), // Colombo coordinates
      zoom: 14.0,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  void _confirmSelection() {
    if (_selectedPosition != null) {
      final mapUrl =
          'https://maps.google.com/?q=${_selectedPosition!.latitude},'
          '${_selectedPosition!.longitude}';
      Get.back(result: mapUrl);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmSelection,
            tooltip: 'Confirm Location',
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialCameraPosition,
        onTap: _onMapTapped,
        markers: _buildMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    if (_selectedPosition == null) return {};

    return {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _selectedPosition!,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      ),
    };
  }
}
