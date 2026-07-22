import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';

class RequestDescriptionScreen extends StatefulWidget {
  final String categoryId;
  final String professionId;

  const RequestDescriptionScreen({
    super.key,
    required this.categoryId,
    required this.professionId,
  });

  @override
  State<RequestDescriptionScreen> createState() =>
      _RequestDescriptionScreenState();
}

class _RequestDescriptionScreenState extends State<RequestDescriptionScreen> {
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            '${place.street}, ${place.locality}, ${place.administrativeArea}';
        _addressController.text = address;
      }

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<CustomerBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Describe Your Request')),
        body: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is RequestCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request submitted successfully!')),
              );
              context.go('/customer/my-requests');
            } else if (state is CustomerFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe what you need...',
                  ),
                ),
                const SizedBox(height: 20),
                Text('Location', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Enter your address',
                    suffixIcon: _isLoadingLocation
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: _getCurrentLocation,
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<CustomerBloc, CustomerState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state is CustomerLoading
                            ? null
                            : () {
                                if (_descriptionController.text.isEmpty ||
                                    _addressController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Please fill all fields')),
                                  );
                                  return;
                                }
                                context.read<CustomerBloc>().add(
                                      CreateRequestEvent({
                                        'category_id': widget.categoryId,
                                        'profession_id': widget.professionId,
                                        'description': _descriptionController.text,
                                        'address': _addressController.text,
                                        if (_currentPosition != null) ...{
                                          'latitude': _currentPosition!.latitude,
                                          'longitude': _currentPosition!.longitude,
                                        },
                                      }),
                                    );
                              },
                        child: state is CustomerLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Submit Request'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
