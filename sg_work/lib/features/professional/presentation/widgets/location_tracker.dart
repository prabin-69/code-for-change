import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final LatLng? initialLocation;

  const LocationPickerScreen({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  LatLng? _currentLocation;
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialLocation != null) {
      setState(() {
        _selectedLocation = widget.initialLocation;
        _isLoading = false;
      });
      final address = await LocationService.getAddressFromLatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
      setState(() {
        _selectedAddress = address;
        _isLoading = false;
      });
      return;
    }

    final hasPermission = await LocationService.checkAndRequestPermission();
    if (hasPermission) {
      final position = await LocationService.getCurrentPosition();
      final current = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = current;
        _selectedLocation = current;
        _isLoading = false;
      });
      final address = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _selectedAddress = address;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) return;
    setState(() => _isSearching = true);

    try {
      // Use Google Places API via backend to get place details
      // For now, we'll just geocode the address
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        setState(() {
          _selectedLocation = latLng;
          _selectedAddress = query;
          _isSearching = false;
        });
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSearching = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: _searchPlace,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_selectedLocation != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation!,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: (LatLng latLng) async {
                setState(() {
                  _selectedLocation = latLng;
                });
                final address = await LocationService.getAddressFromLatLng(
                  latLng.latitude,
                  latLng.longitude,
                );
                setState(() {
                  _selectedAddress = address;
                });
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLocation!,
                        draggable: true,
                        onDragEnd: (LatLng newPos) async {
                          setState(() {
                            _selectedLocation = newPos;
                          });
                          final address = await LocationService.getAddressFromLatLng(
                            newPos.latitude,
                            newPos.longitude,
                          );
                          setState(() {
                            _selectedAddress = address;
                          });
                        },
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    }
                  : {},
            ),
          if (_selectedAddress != null && !_isLoading)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Selected Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_selectedAddress!),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _selectedLocation != null
                  ? () {
                      widget.onLocationSelected(
                        _selectedLocation!,
                        _selectedAddress ?? '',
                      );
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}